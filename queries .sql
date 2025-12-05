-- #########################################################
-- Fichier : queries.sql
-- Auteur : Yannick MUBAKILAYI CIBANGU
-- Description : Préparation, nettoyage et analyse des ventes Kawa Market
-- #########################################################

-- #########################################################
-- 0. Création d'une table de travail nettoyée
-- #########################################################
-- Objectif : Créer une table temporaire ou permanente avec les données nettoyées
-- Gestion des dates, suppression des doublons, valeurs manquantes, calcul de CA et marge

DROP TABLE IF EXISTS public.kawa_ventes_clean;
CREATE TABLE public.kawa_ventes_clean AS
SELECT
    id_vente,
    date_vente::date AS date_vente_clean,       -- Conversion en type date
    magasin_code,
    magasin_nom,
    categorie_produit,
    produit_nom,
    mode_paiement,
    quantite,
    prix_unitaire,
    cout_unitaire,
    remise_pct,
    client_type,
    vendeur_id,
    quantite * prix_unitaire AS CA,             -- Calcul du chiffre d'affaires par ligne
    (prix_unitaire - cout_unitaire) * quantite AS marge -- Calcul de la marge par ligne
FROM public.kawa_ventes
WHERE magasin_nom IS NOT NULL               -- Suppression des lignes sans magasin
  AND date_vente IS NOT NULL                -- Suppression des lignes sans date
  AND quantite > 0                           -- Suppression des ventes nulles ou négatives
  AND prix_unitaire >= 0                     -- Suppression des prix négatifs
  AND cout_unitaire >= 0                     -- Suppression des coûts négatifs
GROUP BY id_vente, date_vente, magasin_code, magasin_nom,
         categorie_produit, produit_nom, mode_paiement,
         quantite, prix_unitaire, cout_unitaire, remise_pct, client_type, vendeur_id;

-- #########################################################
-- 1. Suppression des doublons (au cas où)
-- #########################################################
DELETE FROM public.kawa_ventes_clean a
USING public.kawa_ventes_clean b
WHERE a.id_vente < b.id_vente
  AND a.id_vente = b.id_vente;

-- #########################################################
-- 2. Chiffre d’affaires (CA) total par magasin pour le dernier mois disponible
-- #########################################################
SELECT 
    magasin_nom, 
    SUM(CA) AS CA_total
FROM public.kawa_ventes_clean
WHERE date_vente_clean >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
GROUP BY magasin_nom
ORDER BY CA_total DESC;

-- #########################################################
-- 3. Top 3 catégories en volume de ventes sur les 3 derniers mois
-- #########################################################
SELECT 
    categorie_produit, 
    SUM(quantite) AS total_ventes
FROM public.kawa_ventes_clean
WHERE date_vente_clean >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY categorie_produit
ORDER BY total_ventes DESC
LIMIT 3;

-- #########################################################
-- 4. Marge moyenne par magasin et par catégorie
-- #########################################################
SELECT 
    magasin_nom, 
    categorie_produit, 
    AVG(marge) AS marge_moyenne
FROM public.kawa_ventes_clean
GROUP BY magasin_nom, categorie_produit
ORDER BY magasin_nom, categorie_produit;

-- #########################################################
-- 5. Évolution du chiffre d’affaires par mois sur les 12 derniers mois
-- #########################################################
SELECT 
    DATE_TRUNC('month', date_vente_clean) AS mois, 
    SUM(CA) AS CA
FROM public.kawa_ventes_clean
WHERE date_vente_clean >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY mois
ORDER BY mois;

-- #########################################################
-- 6. Part de chaque mode de paiement dans le CA total
-- #########################################################
SELECT 
    mode_paiement, 
    SUM(CA) * 100.0 / SUM(SUM(CA)) OVER() AS part_CA
FROM public.kawa_ventes_clean
GROUP BY mode_paiement
ORDER BY part_CA DESC;

-- #########################################################
-- 7. Panier moyen par magasin
-- #########################################################
SELECT 
    magasin_nom,
    AVG(CA) AS panier_moyen
FROM public.kawa_ventes_clean
GROUP BY magasin_nom
ORDER BY panier_moyen DESC;

-- #########################################################
-- 8. CA et marge par catégorie
-- #########################################################
SELECT 
    categorie_produit,
    SUM(CA) AS CA_total,
    SUM(marge) AS marge_total
FROM public.kawa_ventes_clean
GROUP BY categorie_produit
ORDER BY CA_total DESC;

-- #########################################################
-- 9. Top 5 produits les plus vendus par quantité
-- #########################################################
SELECT 
    produit_nom, 
    SUM(quantite) AS total_ventes
FROM public.kawa_ventes_clean
GROUP BY produit_nom
ORDER BY total_ventes DESC
LIMIT 5;

-- #########################################################
-- 10. Magasins avec CA < moyenne globale
-- #########################################################
WITH CA_par_magasin AS (
    SELECT 
        magasin_nom, 
        SUM(CA) AS CA
    FROM public.kawa_ventes_clean
    GROUP BY magasin_nom
)
SELECT *
FROM CA_par_magasin
WHERE CA < (SELECT AVG(SUM(CA)) FROM public.kawa_ventes_clean GROUP BY magasin_nom)
ORDER BY CA ASC;


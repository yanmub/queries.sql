/* ============================================================================
   fichier : queries.sql
   auteur  : Yannick MUBAKILAYI CIBANGU
   objet   : Ensemble complet des requêtes SQL utilisées dans le test technique
             Kawa Market : exploration, nettoyage, KPIs et analyses finales
   base    : PostgreSQL
   ============================================================================ */


/* ============================================================================
   1. EXPLORATION DES DONNÉES
   ============================================================================ */

-- Aperçu des données
SELECT * FROM sales LIMIT 20;

-- Schéma de la table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'sales';

-- Compter les lignes
SELECT COUNT(*) FROM sales;

-- Vérifier les valeurs manquantes
SELECT
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS missing_date,
    SUM(CASE WHEN store_name IS NULL THEN 1 ELSE 0 END) AS missing_store,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS missing_category,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS missing_quantity
FROM sales;

-- Détecter doublons par transaction
SELECT sale_id, COUNT(*)
FROM sales
GROUP BY sale_id
HAVING COUNT(*) > 1;

-- Distribution des quantités
SELECT quantity, COUNT(*)
FROM sales
GROUP BY quantity
ORDER BY quantity;


/* ============================================================================
   2. NETTOYAGE DES DONNÉES
   ============================================================================ */

-- Suppression des doublons exacts
DELETE FROM sales s1
USING sales s2
WHERE s1.ctid < s2.ctid
AND s1.sale_id = s2.sale_id;

-- Suppression des ventes sans magasin (inexploitable)
DELETE FROM sales WHERE store_name IS NULL;

-- Remplacement des modes de paiement inconnus
UPDATE sales
SET payment_method = 'Inconnu'
WHERE payment_method IS NULL OR payment_method = '';

-- Correction des dates invalides (créer une valeur par défaut)
UPDATE sales
SET date = '2023-01-01'
WHERE date IS NULL;

-- Suppression des quantités négatives
DELETE FROM sales
WHERE quantity < 0;


/* ============================================================================
   3. CALCULS — ENRICHISSEMENT DE LA TABLE
   ============================================================================ */

-- CA (Chiffre d'affaires)
ALTER TABLE sales ADD COLUMN sales_amount NUMERIC;
UPDATE sales
SET sales_amount = quantity * unit_price;

-- Coût total
ALTER TABLE sales ADD COLUMN cost_amount NUMERIC;
UPDATE sales
SET cost_amount = quantity * unit_cost;

-- Marge
ALTER TABLE sales ADD COLUMN margin_amount NUMERIC;
UPDATE sales
SET margin_amount = sales_amount - cost_amount;

-- Mois et année
ALTER TABLE sales ADD COLUMN year INT;
ALTER TABLE sales ADD COLUMN month INT;

UPDATE sales
SET year = EXTRACT(YEAR FROM date),
    month = EXTRACT(MONTH FROM date);


/* ============================================================================
   4. INDICATEURS KPI GLOBAUX
   ============================================================================ */

-- CA total
SELECT SUM(sales_amount) AS total_sales FROM sales;

-- Marge totale
SELECT SUM(margin_amount) AS total_margin FROM sales;

-- Panier moyen
SELECT SUM(sales_amount) / COUNT(DISTINCT sale_id) AS avg_basket
FROM sales;

-- Quantité totale vendue
SELECT SUM(quantity) AS total_quantity FROM sales;


/* ============================================================================
   5. REQUÊTES DEMANDÉES DANS LE TEST TECHNIQUE
   ============================================================================ */

-- 5.1 CA total par magasin pour le dernier mois disponible
WITH last_month AS (
    SELECT DATE_TRUNC('month', MAX(date)) AS month_start
    FROM sales
)
SELECT 
    store_name,
    SUM(sales_amount) AS total_sales
FROM sales
JOIN last_month lm ON DATE_TRUNC('month', sales.date) = lm.month_start
GROUP BY store_name
ORDER BY total_sales DESC;


-- 5.2 Top 3 catégories en volume sur les 3 derniers mois
WITH last_3_months AS (
    SELECT DATE_TRUNC('month', MAX(date)) - INTERVAL '2 months' AS start_period
    FROM sales
)
SELECT 
    category,
    SUM(quantity) AS total_quantity
FROM sales
JOIN last_3_months p ON DATE_TRUNC('month', sales.date) >= p.start_period
GROUP BY category
ORDER BY total_quantity DESC
LIMIT 3;


-- 5.3 Marge moyenne par magasin et par catégorie
SELECT
    store_name,
    category,
    AVG(margin_amount) AS avg_margin
FROM sales
GROUP BY store_name, category
ORDER BY store_name, avg_margin DESC;


-- 5.4 Évolution du CA par mois sur les 12 derniers mois
WITH last_year AS (
    SELECT MAX(date) - INTERVAL '12 months' AS start_date
    FROM sales
)
SELECT
    DATE_TRUNC('month', date) AS month,
    SUM(sales_amount) AS total_sales
FROM sales
JOIN last_year y ON date >= y.start_date
GROUP BY month
ORDER BY month;


-- 5.5 Part de chaque mode de paiement dans le CA total (optionnel)
SELECT
    payment_method,
    SUM(sales_amount) AS total_sales,
    SUM(sales_amount) * 100.0 / SUM(SUM(sales_amount)) OVER () AS pct_sales
FROM sales
GROUP BY payment_method
ORDER BY pct_sales DESC;


/* ============================================================================
   FIN DU FICHIER
   auteur : Yannick MUBAKILAYI CIBANGU
   ============================================================================ */

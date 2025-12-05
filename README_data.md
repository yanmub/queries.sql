# README_data.md

## Nettoyage et préparation des données - Kawa Market

1. Conversion des dates : `date_vente` convertie en `date` PostgreSQL pour faciliter l'analyse temporelle.
2. Suppression des lignes sans magasin ni date : ces informations sont essentielles pour l'analyse par magasin et par période.
3. Suppression des lignes avec `quantite <= 0`, `prix_unitaire < 0` ou `cout_unitaire < 0`.
4. Calcul des variables :
   - CA = quantite * prix_unitaire
   - Marge = (prix_unitaire - cout_unitaire) * quantite
5. Suppression des doublons basés sur `id_vente`.
6. Les valeurs manquantes dans d'autres colonnes non critiques (ex: `client_type`) ont été conservées.
7. Objectif : fournir une table `kawa_ventes_clean` prête à l'analyse BI.

README_data.md

1. Source : dump Postgres fourni (kawa_ventes_dump.sql), importé dans base kawa_db.
2. Nettoyage principal :
   - Suppression des lignes sans store_id (0.4% des lignes) — impossibles à attribuer.
   - Suppression des doublons exacts basés sur transaction_id.
   - Normalisation des valeurs de mode_paiement (mapping vers 'cash','mobile_money','card').
3. Imputation :
   - purchase_price imputé depuis dim_products si absent.
4. Filtrage :
   - Exclusion des lignes quantité <= 0 sauf si flag is_return = true.
5. Variables calculées :
   - amount (si manquant) = unit_price * quantity.
   - marge_ligne = amount - purchase_price * quantity.
6. Impact & limites :
   - ~0.4% des lignes supprimées ; pas d’impact sur tendances globales. Certaines ventes sans customer_id -> limite analyse client.

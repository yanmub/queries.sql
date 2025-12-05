# Dimension pédagogique - Kawa Market

## Objectif pédagogique
Permettre aux apprenants de :
- Comprendre le cycle complet d’un projet Data/BI : extraction, nettoyage, modélisation, analyse.
- Manipuler SQL pour l’exploration et l’agrégation des données.
- Construire des KPI pertinents pour le suivi commercial.
- Concevoir un tableau de bord Power BI pour la prise de décision.

## Étapes proposées aux apprenants
1. **Compréhension du besoin**  
   Identifier les indicateurs clés de performance (KPI) pour le suivi des ventes et de la marge par magasin, catégorie, et mode de paiement.

2. **Préparation et nettoyage des données**
   - Identifier et corriger les valeurs manquantes ou incohérentes.
   - Convertir les dates et créer des variables calculées (CA, marge, panier moyen).
   - Supprimer les doublons et les lignes invalides.

3. **Modélisation**
   - Créer un mini schéma en étoile : table de faits `ventes` + dimensions `magasin`, `produit`, `temps`, `mode_paiement`.
   - Réaliser les requêtes SQL pour extraire les indicateurs clés.

4. **Visualisation et tableau de bord**
   - Construire les vues par magasin, catégorie, mode de paiement.
   - Ajouter les filtres dynamiques par période et par magasin/catégorie.
   - Interpréter les résultats et générer des recommandations.

## Méthodologie pédagogique
- Encourager la réflexion sur les décisions de nettoyage.
- Décomposer les KPI en formules simples et interprétables.
- Mettre en avant la cohérence entre SQL et visualisation Power BI.
- Discuter des limites des données et des possibles améliorations.

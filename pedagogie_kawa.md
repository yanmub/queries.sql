# pedagogie_kawa.md

## Objectif pédagogique
Le cas Kawa Market permet d’évaluer la capacité d’un·e apprenant·e à conduire un projet Data/BI complet : compréhension du besoin métier, préparation des données, modélisation SQL, construction d’indicateurs, réalisation d’un tableau de bord Power BI et restitution des insights. Il simule une mission réelle en entreprise et mesure la maturité analytique, la rigueur et la capacité à communiquer clairement des résultats utiles à la prise de décision.

## Compétences évaluées

### 1. Compréhension du besoin métier
- Savoir reformuler un besoin non technique.
- Identifier les indicateurs nécessaires au pilotage.
- Cadrer la demande et la traduire en objectifs analytiques.

### 2. Préparation et nettoyage des données
- Détecter les valeurs manquantes, doublons, incohérences.
- Documenter les choix de nettoyage.
- Construire un dataset fiable et exploitable.

### 3. Modélisation et SQL
- Proposer un schéma adapté à l’analyse (schéma en étoile).
- Écrire des requêtes SQL claires, robustes et efficaces.
- Réaliser des agrégations temporelles et catégorielles pertinentes.

### 4. Conception d’un tableau de bord Power BI
- Structurer un modèle de données cohérent.
- Créer des mesures DAX pertinentes (CA, marge, taux, évolution).
- Concevoir un tableau de bord lisible, dynamique et orienté décision.
- Construire une navigation logique : magasins → catégories → paiements → temps.

### 5. Communication et storytelling
- Produire une note analytique synthétique et professionnelle.
- Présenter les enseignements clés.
- Proposer des recommandations basées sur les données.

## Ce que l’on veut observer

- Capacité à analyser un besoin non technique.
- Qualité du raisonnement, structuration et cohérence du travail.
- Maîtrise du nettoyage et de la documentation.
- Compétence réelle en SQL.
- Compréhension de Power BI (modèle, DAX, visuels pertinents).
- Clarté de la note d’analyse et pertinence des recommandations.

## Structure des livrables attendus

kawa-market-bi-test/
│
├── README.md
├── .gitignore
│
├── data/
│   ├── raw/
│   │   └── kawa_ventes_dump.sql          # Données brutes Postgres
│   └── cleaned/
│       ├── kawa_ventes_cleaned.csv       # Données nettoyées
│       └── README_data.md                # Documentation du nettoyage
│
├── sql/
│   ├── schema_inspection.sql             # Exploration du schéma
│   ├── cleaning.sql                      # Nettoyage / transformations SQL
│   └── queries.sql                       # Requêtes principales et KPI
│
├── etl/
│   ├── ingest_postgres.sh                # Script d’ingestion du dump
│   └── etl_pipeline.sql                  # Agrégations et transformations
│
├── analysis/
│   └── exploratory_analysis.ipynb       # Analyse exploratoire et visualisations intermédiaires
│
├── powerbi/
│   └── dashboard.pbix                    # Tableau de bord final Power BI
│
└── docs/
    ├── note_analyse.pdf                  # Note de synthèse pour la direction
    ├── pedagogie_kawa.md                 # Dimension pédagogique du cas
    └── data_dictionary.md                # Dictionnaire des données

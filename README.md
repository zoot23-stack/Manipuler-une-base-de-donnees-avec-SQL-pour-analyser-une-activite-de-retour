# Manipuler-une-base-de-donnees-avec-SQL-pour-analyser-une-activite-de-retour
Identifiez les causes de retour de colis d'une entreprise d'e-commerce. Proposez ensuite des solutions pour limiter certains retours, et en valoriser d'autres.

## Présentation du projet
L'entreprise Regaload commercialise des produits high-tech, de bricolage, d’ameublement et d’autres catégories. Les retours et remboursements représentent des enjeux financiers, logistiques et environnementaux.
Ma mission consiste à documenter les données, construire une base relationnelle et interroger les informations pour répondre aux questions des équipes métier.
## Problématique
Comment relier les commandes, les expéditions, les produits et les remboursements pour comprendre les pertes et identifier les priorités d’amélioration ?

## Objectifs principaux
1. Documenter les données et leurs règles de gestion.
2. Concevoir un schéma relationnel avec clés primaires et étrangères.
3. Créer et alimenter une base SQLite.
4. Répondre à dix questions métier grâce à SQL.
5. Analyser les remboursements selon les produits, les transporteurs, les bâtiments et les lignes d’emballage.
6. Évaluer la compensation des retours et une hypothèse de prestation externe.

## Jeu de données
La base fournie couvre les expéditions du 1er au 31 mars 2022. Elle contient six tables métier.
| Table | Rôle | Nombre de ligne |
| :--- | :--- | --- |
| Client | Identifiants clients | 143 096 |
| Commande | Commandes et rattachement aux clients | 251 617 |
| Colis | Dates, transporteurs et informations logistiques | 263 853 |
| Produit | Références, marques et catégories | 26 727 |
| Ligne_Expedition | Produits expédiés, quantités et chiffre d’affaires | 319 820 |
| Retour_Remboursement | Motifs, montants remboursés et devenir des produits | 13 778 |

La table Ligne_Expedition relie les commandes, colis et produits. Chaque enregistrement de Retour_Remboursement est rattaché à une ligne d’expédition.
Le dictionnaire décrit les champs, les types, les contraintes et les règles de calcul. Les dates sont stockées comme chaînes de caractères dans la base fournie.

## Outils et technologies
- SQLite : base relationnelle et exécution des requêtes SQL.
- SQL : jointures, filtres, agrégations et calculs de ratios.
- Excel : dictionnaire de données et documentation des questions, requêtes et résultats.
- dbdiagram.io : outil indiqué sur le schéma relationnel fourni.
Le livrable technique principal est une base .db

## Analyse SQL
- SELECT, WHERE et IN : sélectionner et filtrer les informations.
- LEFT JOIN : relier les expéditions, les colis, les produits et les remboursements.
- SUM, COUNT et GROUP BY : calculer les montants et segmenter les résultats.
- ROUND et NULLIF : présenter les ratios et protéger certains calculs contre une division par zéro.
- WITH : structurer l’analyse des flux non livrés et des retours associés.
- HAVING et ORDER BY : sélectionner les groupes pertinents et classer les résultats.

## Démarche d’analyse
1. Explorer et documenter les champs utiles aux questions métier.
2. Modéliser les entités et leurs relations.
3. Créer et charger les six tables de la base SQLite.
4. Interroger les données pour les équipes marge, retours, transport, logistique et achats.
5. Comparer les montants, ratios et segments pour éclairer les décisions.
Les dix questions portent sur le total des remboursements, leur répartition par bâtiment et semaine, les motifs, les rétractations sans retour, la compensation, les transporteurs, les flux non livrés, les départements, les avaries et les marques de multicuiseurs.

## Principaux enseignements
- Les rétractations concentrent le premier montant de remboursement par motif : 931 220,83 €, soit environ 40,70 % du total.
- La compensation constitue un levier financier important : le montant enregistré représente 55,42 % des remboursements globaux.
- Les écarts entre transporteurs méritent une investigation : la requête Q6 donne notamment un ratio financier de 7,29 % pour Chronopost et 5,18 % pour Colissimo, sans démontrer à elle seule la responsabilité du transporteur.
- La segmentation des avaries facilite l’identification d’anomalies : le classeur enregistre 34 remboursements pour la ligne B_9 le 15 mars 2022, pour 3 161,01 €. Ce résultat enregistré n’établit pas à lui seul un lien causal avec l’incident de colle décrit dans la question.
- Le modèle relationnel permet de relier les dimensions métier, depuis le produit jusqu’au transport et au remboursement.

## Limites de l’étude
- Le périmètre des expéditions couvre un mois ; l’annualisation de Q4 repose sur une hypothèse de stabilité.
- Les ratios financiers de remboursement ne sont pas des taux de retour en nombre de commandes ou de colis.
- La requête Q7 compte des lignes liées aux remboursements ; son résultat ne correspond pas nécessairement à un nombre de colis distincts.
- Certaines requêtes écrites dans le classeur comportent des erreurs de syntaxe et ne s’exécutent pas telles quelles, notamment Q2, Q3, Q8 et Q9. Les fichiers sources n’ont pas été corrigés pour cette documentation.
- Les contraintes physiques, les types et les règles décrits dans le dictionnaire doivent être distingués de leur implémentation réelle dans SQLite.

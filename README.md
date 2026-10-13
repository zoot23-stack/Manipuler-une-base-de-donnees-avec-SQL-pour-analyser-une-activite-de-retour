# Manipuler-une-base-de-donnees-avec-SQL-pour-analyser-une-activite-de-retour

Analyse des retours et remboursements avec SQL

## Présentation du projet
L'entreprise Regaload commercialise des produits high-tech, de bricolage, d’ameublement et d’autres catégories. Les retours et remboursements représentent des enjeux financiers, logistiques et environnementaux.
Au sein de l’équipe chargée des remboursements, ma mission est de créer et alimenter une base de données relationnelle reliant les clients, les commandes, les colis, les produits et les remboursements, puis d’exécuter des requêtes SQL pour répondre aux questions métier des équipes financière, logistique, transport et achats : mesurer les montants remboursés, comparer les transporteurs, repérer les problèmes d’emballage et évaluer la valeur récupérée grâce aux retours.

### Problématique
Comment exploiter les données de commandes, d’expéditions et de remboursements pour identifier les principales sources de pertes et améliorer la gestion des retours produits chez Regaload ?

## Objectifs métier
- Quantifier les montants remboursés.
- Identifier les produits et les flux logistiques à investiguer.
- Évaluer la valeur récupérée grâce aux retours.
- Éclairer les décisions des équipes métier pour réduire les pertes.
  
## Jeu de données
Les données de départ sont regroupées dans un tableau unique au format csv contenant les informations sur les clients, les commandes, les produits, les colis, les expéditions et les éventuels retours et remboursements.
Chaque ligne décrit un produit expédié dans un colis pour une commande donnée, avec les informations de remboursement et de retour lorsqu’elles sont renseignées.
Ces données ont été réparties dans une base relationnelle couvrant les expéditions du *1er au 31 mars 2022*, organisée en six tables métier :

| Table | Rôle | Nombre d'enregistrements |
| :--- | :--- | --- |
| Client | Identifiants clients | 143 096 |
| Commande | Commandes et rattachement aux clients | 251 617 |
| Colis | Dates, transporteurs et informations logistiques | 263 853 |
| Produit | Références, marques et catégories | 26 727 |
| Ligne_Expedition | Produits expédiés, quantités et chiffre d’affaires | 319 820 |
| Retour_Remboursement | Motifs, montants remboursés et devenir des produits | 13 778 |

La table Ligne_Expedition relie les commandes, colis et produits. Chaque enregistrement de Retour_Remboursement est rattaché à une ligne d’expédition.
Cette organisation limite la répétition des informations et permet de croiser les données grâce aux clés primaires et étrangères. Le dictionnaire de données documente les champs, les types, les contraintes et les règles de calcul.
Le dictionnaire décrit les champs, les types, les contraintes et les règles de calcul. Les dates sont stockées comme chaînes de caractères dans la base fournie.

## Outils
- **SQLite** : moteur de la base, stockée dans un fichier.db
- **Letos 4.0.1 (anciennement SQLiteStudio)** : interface utilisée pour manipuler la base et exécuter les requêtes.
- **Excel** : dictionnaire de données et documentation des questions, requêtes et résultats.
- **dbdiagram.io** : conception du schéma relationnel.

## Méthodes SQL utilisées
- Jointures *LEFT JOIN* pour relier les tables.
- Filtres *WHERE* pour sélectionner les données pertinentes.
- Agrégations *SUM* et *COUNT* pour calculer les montants et compter les enregistrements.
- Regroupements *GROUP BY* pour comparer les résultats par catégorie.
- Tris *ORDER BY* pour classer les résultats.
- Expressions communes *WITH* pour structurer les requêtes.
- Arrondis *ROUND* et utilisation de *NULLIF* pour éviter certaines divisions par zéro.

## Démarche d’analyse
1. Explorer et documenter les champs utiles aux questions métier.
2. Modéliser les entités et leurs relations.
3. Créer et alimenter les six tables de la base SQLite.
4. Interroger les données pour les équipes marge, retours, transport, logistique et achats.
5. Comparer les montants, les ratios et les segments pour éclairer les décisions.

Les questions  business portent sur les remboursements, les motifs de retour, la compensation, les transporteurs, les flux non livrés, les départements, les avaries et les marques de multicuiseurs.

## Chargement des données
L'étape nettoyage et préparation des données m'a permis de créer un fichier csv pour chaque table. Une fois les six tables créées dans SQLite, j'ai chargée les données de chaque fichier dans la table correspondante à l'aide de l'assistant d'import Letos. 

## Analyses métier — exemples
### 1. Mesurer le montant total des remboursements

**Question métier :** quel est le montant total des remboursements clients ?

sql
SELECT SUM(Montant_Rb) AS Montant_Total_Remboursements
FROM Retour_Remboursement;


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

-- Question 1: Quel est le montant total d’émission de remboursements clients ?
SELECT SUM(Montant_Rb) AS Montant_Total_Remboursements FROM Retour_Remboursement;

-- Question 2: Quel est le taux d’émission de remboursements clients (Montant de remboursement/CA) par bâtiment et par semaine ?
SELECT
c.Batiment_Expe,
c.Semaine_Expe,
ROUND(SUM(rr.Montant_Rb)/SUM(le.CA_Vente),2) AS Taux_de_Remboursement
FROM Ligne_Expedition le
LEFT JOIN Colis c ON le.ColisID=c.id
LEFT JOIN Retour_Remboursement rr ON le.id=rr .Ligne_ExpeditionID
GROUP BY c.Batiment_Expe, c.Semaine_Expe;

-- Question 3: Quel est le taux d’émission de remboursements clients par motif de remboursement ?
SELECT
rr.Motif_Rb,
ROUND(SUM(rr.Montant_Rb) / SUM(le.CA_Vente),2) AS Taux_de_Remboursement
FROM Ligne_Expedition le
LEFT JOIN Retour_Remboursement rr ON le.id=rr.Ligne_ExpeditionID
GROUP BY rr.Motif_Rb;

-- Question 4: Calculer le montant total remboursé uniquement pour les cas ou le motif est "Retractation", les catégories produits sont "INFORMATIQUE ou TELEPHONIE-GPS" et le produit n'a pas été retourné par le client. 
SELECT
SUM(rr.Montant_Rb) AS Remboursements_Retractation_Informatique_Telephonie
FROM Ligne_Expedition le
LEFT JOIN Retour_Remboursement rr ON le.id=rr.Ligne_ExpeditionID
LEFT JOIN Produit p ON le.ProduitID=p.id
WHERE rr.Motif_Rb='Retractation'
AND rr.Produit_Retourne ='Non retourne'
AND p.Categorie_Produit_lvl_1 IN ('INFORMATIQUE','TELEPHONIE - GPS');

-- Question 5: Calculer le montant total de compensation récupérée et le montant total remboursé pour les produits ayant été physiquement retournés, afin d'en déduire le taux de compensation. La part du remboursement récupéré grâce à la revalorisation du produit retourné.
SELECT
ROUND(SUM(rr.Compensation_Retour),2) AS Total_compensation,
ROUND(SUM(rr.Compensation_Retour) / SUM(rr.Montant_Rb),4) AS Taux_compensation
FROM Retour_Remboursement rr;

-- Question 6: Calculer le taux de remboursement pour chaque transporteur, trié du taux le plus élevé au plus faible, afin d'évaluer si leurs performances justifient une hausse tarifaire.
SELECT
c.Transporteur,
ROUND(SUM(rr.Montant_Rb) / SUM(le.CA_Vente),4) AS Taux_remboursement_Transporteur
FROM Ligne_Expedition le
LEFT JOIN Retour_Remboursement rr ON le.id=rr.Ligne_ExpeditionID
LEFT JOIN Colis c ON le.ColisID=c.id
GROUP BY c.Transporteur
ORDER BY Taux_remboursement_Transporteur DESC;


-- Question 7: Calculer pour chaque transporteur le nombre de colis non livrés et retournés, et le taux (retournés / non livrés).  Pour vérifier la fiabilité de chaque transporteur dans la gestion des erreurs de livraison. 
With Colis_Non_Livres AS (
SELECT
c.Transporteur,
COUNT(*) AS Nb_non_livres
FROM Ligne_Expedition le
LEFT JOIN Colis c ON le.ColisID=c.id
LEFT JOIN Retour_Remboursement rr ON le.id=rr.Ligne_ExpeditionID
WHERE rr.Pre_Post_Livraison='Non livre'
GROUP BY c.Transporteur
),
Colis_Retournes AS(
SELECT
c.Transporteur,
COUNT(*) AS Nb_Retournes
FROM Ligne_Expedition le
LEFT JOIN Colis c ON le.ColisID=c.id
LEFT JOIN Retour_Remboursement rr ON le.id=rr.Ligne_ExpeditionID
WHERE rr.Pre_Post_Livraison='Non livre'
AND (rr.Produit_Retourne!='Non retourne' OR rr.Produit_Retourne IS NULL)
GROUP BY c.Transporteur
)
SELECT
nl.Transporteur,
nl.Nb_Non_Livres,
r.Nb_Retournes,
ROUND(r.Nb_retournes * 1.0 / nl.Nb_non_livres, 4) AS Taux_de_retour
FROM Colis_Non_Livres nl
LEFT JOIN Colis_Retournes r ON nl.Transporteur = r.Transporteur
ORDER BY Taux_de_retour DESC;

-- Question 8: Pour chaque département calculer le montant total remboursé et le taux de remboursement, avec filtrage sur le transporteur "CHRONOPOST"pour identifier géographiquement si les problèmes sont localisés dans certains départements ou répartis sur l'ensemble du territoire. 
SELECT
c.Pays AS Pays,
c.Departement AS Departement,
SUM(rr.Montant_RB) AS Montant_total_remboursement,
ROUND(SUM(rr.Montant_RB) / SUM(le.CA_Vente),4) AS Taux_remboursement
FROM Ligne_Expedition le
LEFT JOIN Colis c ON le.ColisID=c.id
LEFT JOIN Retour_Remboursement rr ON le.id=rr.Ligne_ExpeditionID
WHERE c.Transporteur='CHRONOPOST'
GROUP BY c.Pays, c.Departement
HAVING SUM(rr.Montant_Rb) IS NOT NULL
ORDER BY: Taux_remboursement DESC;

-- Question 9: Calculer le nombre de remboursements et le montant  total remboursé pour le motif "Avarie", regroupé par jour et par ligne d'emballage, afin d'identifier la journée et la ligne ou un décrochage anormal est observé, signe de la défaillance du prestataire technique. 
SELECT c.Date_Expe AS Date,
c.ligne_emballage AS Ligne,
COUNT(*) AS Nombre_Remboursements,
ROUND(SUM(rr.montant_Rb),2) AS Montant_total_remboursement
FROM Ligne_Expedition le
LEFT JOIN Retour_Remboursement rr ON le.id=rr.Ligne_ExpeditionID
LEFT JOIN Colis c ON le.ColisID=c.id
WHERE rr.info_motif='Avarie'
GROUP BY c.date_Expe, c.ligne_emballage
ORDER BY nombre_remboursements DESC;

-- Question 10: Calculer pour chaque marque de multicuiseur le CA total,le montant total remboursé et le taux de remboursement, filtre sur la catégorie produit "Multicuiseur Electrique" afin d'identifier la marque qui génère le moinns de remboursements et donc satisfait le mieux les clients. Trie du taux le plus faible au plus élevé
SELECT 
p.Marque_Produit AS Marque,
ROUND(SUM(le.CA_Vente),2) AS Chiffre_affaires,
ROUND(SUM(rr.Montant_Rb),2) AS Total_remboursements,
ROUND(SUM(rr.Montant_Rb) / NULLIF (SUM(le.CA_Vente),0)*100,2) AS Taux_remboursement
FROM Ligne_Expedition le
LEFT JOIN Produit p ON le.ProduitID=p.id
LEFT JOIN Retour_Remboursement rr ON rr.Ligne_ExpeditionID=le.id
WHERE p.Categorie_Produit_lvl_3 ='MULTICUISEUR ELECTRIQUE'
GROUP BY p.Marque_Produit
ORDER BY Taux_remboursement ASC;
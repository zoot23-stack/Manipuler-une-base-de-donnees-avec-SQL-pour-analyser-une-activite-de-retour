-- Activer le contrôle des clés étrangères
PRAGMA foreign_keys = ON;

-- Création de la table Client
CREATE TABLE Client(
id INTEGER PRIMARY KEY
);

-- Création de la table Colis
CREATE TABLE Colis(
id VARCHAR NOT NULL PRIMARY KEY,
Date_Expe VARCHAR,
Semaine_Expe INTEGER,
Site_Expe VARCHAR,
Batiment_Expe CHAR,
Ligne_Emballage VARCHAR,
Transporteur VARCHAR,
Departement VARCHAR,
Pays CHAR
);

-- Création de la table Commande
CREATE TABLE Commande(
id VARCHAR NOT NULL PRIMARY KEY,
ClientID INTEGER NOT NULL,
FOREIGN KEY (ClientID) REFERENCES Client(id)
);

-- Création de la table Ligne_Expedition
CREATE TABLE Ligne_Expedition(
id VARCHAR NOT NULL PRIMARY KEY,
Nb_Produits INTEGER,
CA_Vente DECIMAL(10,2),
CommandeID VARCHAR NOT NULL,
ColisID VARCHAR NOT NULL,
ProduitID VARCHAR NOT NULL,
FOREIGN KEY (CommandeID) REFERENCES Commande(id),
FOREIGN KEY (ColisID) REFERENCES Colis(id),
FOREIGN KEY (ProduitID) REFERENCES Produit(id)
);

-- Création de la table Produit
CREATE TABLE Produit(
id VARCHAR NOT NULL PRIMARY KEY,
Nom_Produit VARCHAR,
Marque_Produit VARCHAR,
Categorie_Produit_lvl_1 VARCHAR,
Categorie_Produit_lvl_2 VARCHAR,
Categorie_Produit_lvl_3 VARCHAR
);

-- Création de la table Retour_Remboursement
CREATE TABLE Retour_Remboursement(
id INTEGER PRIMARY KEY AUTOINCREMENT,
Date_Rb VARCHAR,
Motif_Rb VARCHAR,
Info_Motif VARCHAR,
Pre_Post_Livraison VARCHAR,
Montant_Rb DECIMAL (10,2),
Nb_Produits_Rb INTEGER,
Date_Retour VARCHAR,
Produit_Retourne VARCHAR,
Etat_Retour CHAR,
Compensation_Retour CHAR,
Ligne_ExpeditionID VARCHAR NOT NULL,
FOREIGN KEY (Ligne_ExpeditionID) REFERENCES Ligne_Expedition(id)
);

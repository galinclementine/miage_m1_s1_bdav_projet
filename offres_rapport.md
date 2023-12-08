## Projet de BDAV : Offres d'emploi en Nouvelle-Calédonie

[Jeu de données](https://data.gouv.nc/explore/dataset/offres-demploi/information/?flg=fr-fr&disjunctive.experience&disjunctive.typecontrat&disjunctive.communeemploi&disjunctive.niveauformation&disjunctive.employeur_type&disjunctive.employeur_nomentreprise&disjunctive.specifites_multivalue&disjunctive.zonesdeplacement_multivalue&disjunctive.permis_affichage&disjunctive.langues_affichage)

**Membres du groupe :** Dévi Berges & Clémentine Galin

---

### Introduction

Nous avons choisi de normaliser un fichier CSV comportant des informations sur les offres d'emploi en Nouvelel-Calédonie.
Cette document contient 79 colonnes, nous l'appelerons fichier source.

Pour réaliser ce projet, nous avons choisit de travailler avec PostgreSQL et Python.
Nous avons mis en place différentes étapes :
1. Insertion dans une table temporaire l'ensemble des données du fichier source
2. Création du schéma normalisé
3. Import des données de la table temporaire dans le schéma normalisé

---

### 1. Faire un schéma E/A avec mocodo et le traduire en relationnel PostgreSQL en le complétant et le simplifiant si besoin

- Modoco -> [schema_EA/offres_schema_ea.mcd](https://www.mocodo.net/?mcd=eNp1Vk2PmzAQvfMr-AEcutueckOJs0JKICVkte3FcmCSdcXX2iba9Nd3_EFw2FQ5gJ_H45k3b4YsgoX5rQ45IbQg292e7uK8SMhmEfKKVoMAoAqaXtKeCcWhjsK2a44C6DvgZhRKGHiNLvDsJksWYc2PUNdA8Uzd8Sgsuwqo6BpAmyBe5WS_J6FxzioBUqKLCmp-AXGlfcdbpY_gWWhAv0uFEeCz4vjGj4PiXYvocKz4hUuzKLuhVeKK_n9nKaErstvES7IlaWGu-du1QCvoa1Y6n2OI8x1NxDoKn9LwAR-IP4XZep0Ta-QWxtzmHqTJK4kPdJ3l27hIstRc32JqbKCnTjTMBj9eP9_RBDnXjqfJ-S9yyINllqZxst_H6ZLQJF1n5oKya1vGJWtLoLw9ddMF8x10cHh1Ic-pisJvqUtvmW13pCB4ifPf9KAAnfieRwyD3u_IMlkny6SwB2QPJT_xkivvhAcGK7KN0xWZkfiVvYqjhBqISkDl4VnDEq27ktUQ3Wij8MnPYOR1o8rEYRR4RZVGobr24K9RwhQLLqAXXCtQr3sQKPL3q-QfA0K9gAfozQdtGMr-sRJMsVKyxBIiJ09m40vtPMJvps_OdOTfs9llqIeVc-Yx7pnM1Is3Fnlc-Lr18dBrcBSKEkyNre34Mns3Sepj8bKYZbkj-TbZG1fIVMPlVHG7Dshb8qLDxjCtMb5-twEtQgEfA9q4FTrpTid9fymAKaiioa_Mk-FoGC4dFxQr3x5xJRXIiJVaiOzc2sbWtrQfjrWTigWYKN_5hZ3BLjEmlEJLmUL9KgcK-INDpgJJscrau-RHvEkqpgYVSX5uUXLO9sJqXmlt65YaNTiNLMaFESeVIC4cO-8-yKnY320p49csySkpcr-UHmpbipnkQQm_pSbQDPHAlSgcx4Jipa3pqGYsLNTQv-Pci8KmO3LMMTyxTz1DjbVVtdPaqEZX9yz93_hzinrQDW9Y8kQrefRpk0Z_yeu9eI1Mng2widOXg91zM-GGzIVzt--P25q15wG-zFoLa64WgYv6RpZpAG90amCq1g8T-M9DvNGNZwbUXfRjonbyfKL4-f3InLBHBG63h5QEIy_281gq_MT5M3REAi_feaJ-hovgLl5j_zGgfMdZOh27gw05JqLxA9AM7f3014D97_APxrWqgw==)
- Schéma E/A en version PDF -> [schema_EA/offres_schema_ea.pdf](schema_EA/offres_schema_ea.pdf)
- Schéma relationnel -> [sql/offres_schema.sql](sql/offres_schema.sql)

---

### 2. Préparer un (des) script(s) (psql ou Python) de chargement des données originales (CSV généralement) dans le modèle normalisé.

**Pré-requis :**
1. Télécharger le [jeu de données](https://data.gouv.nc/explore/dataset/offres-demploi/information/?flg=fr-fr&disjunctive.experience&disjunctive.typecontrat&disjunctive.communeemploi&disjunctive.niveauformation&disjunctive.employeur_type&disjunctive.employeur_nomentreprise&disjunctive.specifites_multivalue&disjunctive.zonesdeplacement_multivalue&disjunctive.permis_affichage&disjunctive.langues_affichage) au format CSV et le mettre dans le dossier "***data***" du projet (le nom du fichier doit être `offres-demploi.csv`).
2. Modifier les variables `USER_BDAV` et `PASSWORD_BDAV` en début de fichier `offres-script.py` (identifiants de connexion à la base `bdav`).
3. Installer le module PrettyTable (commande `pip install PrettyTable`).
4. Lancer le script Python `offres_script.py`

**Différents packages**
1. data -> qui contient le ficher source csv uniquement
2. schema_EA -> qui contient le fichier mocodo et le mocodo en version PDF
3. sql -> qui contient l'ensemble des requêtes SQL

**Résumé des fonctions du script Python :**

- `table_exists(table_name, conn)`: Vérifie l'existence d'une table dans la base de données
- `create_table_from_csv(file_path, table_name, conn)`: Crée une nouvelle table à partir d'un fichier CSV
- `insert_data_from_csv(file_path, table_name, conn)`: Insère les données d'un fichier CSV
- `execute_sql_file(file_path, conn)`: Exécute une requête SQL depuis un fichier

**Description du script SQL pour la création du schéma de la base de données :**

1. **Création du schéma et configuration du chemin de recherche :**
   - Crée un schéma `offre` s'il n'existe pas déjà.
   - Définit le chemin de recherche sur `offre`.

2. **Suppression des tables existantes :**
   - Supprime toutes les tables potentiellement existantes pour éviter les conflits lors de la création de nouvelles tables.

3. **Création de tables simples et "multivalue" :**
   - Crée une série de tables pour stocker des informations spécifiques (ex: `activite`, `competence`, `specificite`).
   - Chaque table est dotée d'un identifiant unique (`id_`) généré automatiquement.

4. **Tables avec clés étrangères :**
   - Définit des tables telles que `contact` et `adresse`, liées à d'autres tables par des clés étrangères.

5. **Tables de liaison pour les relations plusieurs-à-plusieurs :**
   - Crée des tables comme `activite_requise`, `competence_requise` pour gérer les relations plusieurs-à-plusieurs.

6. **Structure principale - Table `offre` :**
   - Conçoit la table `offre`, qui est au cœur du schéma, pour stocker les détails des offres d'emploi.

---

### 3. Proposer quelques requêtes analytiques/statistiques intéressantes présentes dans le fichier sql

**Requête 1 : Top 3 des compétences les plus demandées par expérience**

1. **Jointures :** Associe les offres d'emploi à leurs compétences requises et niveaux d'expérience.
2. **Classement :** Compte et classe les compétences par fréquence d'apparition pour chaque niveau d'expérience.
3. **Sélection :** Extrai les trois compétences les plus demandées pour chaque niveau d'expérience.
4. **Résultat :** Affiche un tableau listant, pour chaque niveau d'expérience, ses trois compétences les plus recherchées.

Cette requête aide à comprendre quelles compétences sont les plus valorisées en fonction de l'expérience dans le marché de l'emploi.

**Requête 2 : Nombre d'offres par commune et par type de contrat (CDD, CDI)**

1. **Calcul des Comptes :** Calcule le nombre d'offres pour chaque combinaison de commune et de type de contrat (CDD, CDI, Autre).
2. **Transformation et Agrégation :** Regroupe les résultats par commune, en séparant et en comptant les offres CDD et CDI.
3. **Présentation des Résultats :** Affiche un tableau résumant, pour chaque commune, le nombre d'offres en CDD, en CDI, et le total des offres.

Cette requête est utile pour analyser la répartition des types de contrats dans différentes communes, offrant une vue d'ensemble de la dynamique du marché de l'emploi local.

**Requête 3 : Métiers Polyglottes**

1. **Jointures :** Associe les offres d'emploi aux langues requises, en se concentrant sur celles où la maîtrise d'une langue spécifique est essentielle.
2. **Classement :** Compte le nombre distinct de langues requises pour chaque emploi. 
3. **Sélection :** Se concentre sur les emplois nécessitant la maîtrise de plus d'une langue.
4. **Résultat :** Affiche un tableau classant les emplois en fonction du nombre de langues requises, montrant les postes demandant le plus de compétences linguistiques.

Cette requête est utile pour identifier les emplois où le multilinguisme est particulièrement valorisé.

**Requête 4 : Métiers couvrant toutes les zones de déplacement** 

1. **Jointures :** Associe les offres d'emploi aux zones de déplacement correspondantes, en reliant les tables des offres, des zones de couverture de déplacement, et des zones de déplacement elles-mêmes.
2. **Classement :** Compte le nombre distinct de zones de déplacement pour chaque emploi.
3. **Sélection :** Filtre pour ne conserver que les emplois qui nécessitent une couverture de toutes les zones de déplacement disponibles dans la base de données.
4. **Résultat :** Affiche un tableau listant les emplois qui demandent une disponibilité de déplacement dans toutes les zones géographiques référencées.

Cette requête est particulièrement utile pour les analyses du marché de l'emploi focalisées sur les postes impliquant une grande mobilité géographique.

**Requête 5 : Niveau de formation demandé en NC**

1. **Jointure :** Relie les offres d'emploi à leur niveau de formation correspondant, en utilisant une jointure gauche pour inclure toutes les offres, même celles sans niveau de formation spécifié.
2. **Traitement des Valeurs Manquantes :** Utilise la fonction COALESCE pour remplacer les valeurs manquantes (NULL) par la mention 'Non renseigné', garantissant ainsi une meilleure compréhension et classification des données.
3. **Agrégation :** Compte le nombre total d'offres pour chaque niveau de formation, y compris celles non renseignées.
4. **Résultat :** Affiche un tableau récapitulatif des niveaux de formation demandés, en ordonnant les résultats par le nombre décroissant d'offres.

Cette requête est particulièrement utile pour les analyses du marché de l'emploi qui cherchent à identifier les tendances en matière d'exigences de formation.

---

### Conclusion

Notre projet sur les offres d'emploi en Nouvelle-Calédonie a permis une optimisation significative de la base de données. 
Nous avons confronté et géré un volume important de données manquantes, transformant les valeurs 'NaN' en null et convertissant les données binaires en booléens pour plus de clarté et d'efficacité. 

De plus, l'introduction d'identifiants uniques générés automatiquement dans de nombreuses tables a amélioré la structure et la relation entre les données. 
Ces modifications ont conduit à une base de données plus organisée, facilitant les analyses et extractions de données pertinentes pour une meilleure compréhension du marché de l'emploi en Nouvelle-Calédonie.
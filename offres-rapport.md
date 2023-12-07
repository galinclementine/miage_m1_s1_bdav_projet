## Projet de BDAV : Offres d'emploi en Nouvelle-Calédonie

[Jeu de données](https://data.gouv.nc/explore/dataset/offres-demploi/information/?flg=fr-fr&disjunctive.experience&disjunctive.typecontrat&disjunctive.communeemploi&disjunctive.niveauformation&disjunctive.employeur_type&disjunctive.employeur_nomentreprise&disjunctive.specifites_multivalue&disjunctive.zonesdeplacement_multivalue&disjunctive.permis_affichage&disjunctive.langues_affichage)

**Membres du groupe :** Dévi Berges & Clémentine Galin

---

### 1. Faire un schéma E/A avec mocodo et le traduire en relationnel PostgreSQL en le complétant et le simplifiant si besoin

- Modoco -> [mocodo/offres-schema-ea.mcd](https://www.mocodo.net/?mcd=eNqNVcmO2zgQvesr9AE6TKeTHHwTbDoQYEuOLDeSuRC0VHZzoK1JymjP109x0WY7GEMHicVSserVe8WFt_D-TmJCV2S3CZdkS-Js4fOC_tvUQAtoS5ZDBbUK_JIfoSzhbgcjkO1uk0SLwQWqtmx44OdNAVQ0FaDPM48XrlKy3xPfpMAKAVJC4BdQ8guIK20brjPJG4zvspJKAOC74PjFj53iTY3W7ljwC5dmkTddrcTV2yUYekW-Bv7Li-9Owu_YN-n_JofUWyZxHEb7fRgvCY3idWISyZu6ZlyyOgfK61MzYnG7gwEOb6mNegtr4P8V-8l6nRL02u5IRvAQF79qQQEGmUbubd5qbTI2v475Rt5-R5bROlpGmQ0jW8j5iedcTeJMjM-1wHVTw2Giml5eoROBr64tTNd1U1FsgoBWcN0nvW5BSNq-XyX_6NDUCnhgHWLQivHyDwWahsRkiW3CCl_Mxl1_JqAOrl-ca4_xxMdR4JvxmOA3uiy8FdmG8YrcpBRHbyQ80HWSbsMsSuIFMg6LqCDIQSiNMNPUo2WTsxKCUyMqa4BPfgbw7v9HbGukNevo4Dy27Xbnuc658l5N7ohVFi6zG0B3JN1Ge3M6NqXicjzTrj3yK_phAbG--PnqsPEFfHTo4lYYozmdBASGGKgFJZiWpwCmoAi6tjBvhrrtLg0XFIGpj7iSCmTAcs1xdq6tkrUvbbtj6ZC0Bibyd35hZ7BLzA8ZWFOmUBrKGQX8gxOgAEmRXDq65Ec8SSqmOhVIfq6xI873wkpeaIFotfYtGucJ48L0jkoQF46inic5cuzVMih8S6KUkiydkmxitbpkpnhAoUx0ORqf1aVrqN_PJMVyZUTXywwVCiW07zigA79qjhxR8E_sU49A423lNhTxrdeU5UnSF3Cnx-z3jlDtl4bZA7X-QqJEWmmWO18MFpsw_nGwsDjuD5aBTkYbPWutbDGT6G2mSK832UshVzjYpxOutzwHon6m5QxgGupO5ro2eGNpdhZ-okb4fFCPtntkcAZtDzHxbOUmRMnqczf53a69GUTT2XDrPzPPihva-tWc_fMQbvR0M9NmgqZ1nu2a8z46lEY_xsbzZubHcC4MN02l_XVWdfX8LtOG2z8fR1odUkJohhNrT3dhmkVkY6IWHV70VOHVgTcJw5ELpSH_UQB9x6sEz5PQIb3_nwMPrI6D3w10NgVHkLGlswTdrj_JbWCRzcrdl2bvj9n8B7uG17E=)
- Schéma E/A en version PDF -> [mocodo/offres-schema-ea.pdf](mocodo/offres-schema-ea.pdf)
- Schéma relationnel -> [sql/offres-schema.sql](sql/offres-schema.sql)

---

### 2. Préparer un (des) script(s) (psql ou Python) de chargement des données originales (CSV généralement) dans le modèle normalisé.

**Pré-requis :**
1. Créer un utilisateur avec le nom "devi" et le mdp "123456" afin de se connecter à la bdd "bdav".
2. Créer une bdd nommée "bdav" avec l'utilisateur "devi" comme propriétaire.
3. Télécharger le jeu de données au format CSV et le mettre dans le dossier "data" du projet (le nom du fichier doit être `offres-demploi.csv`).

**Résumé des fonctions du script Python :**

- `table_exists(table_name, conn)`: Vérifie l'existence d'une table dans la base de données
- `create_table_from_csv(file_path, table_name, conn)`: Crée une nouvelle table à partir d'un fichier CSV
- `insert_data_from_csv(file_path, table_name, conn)`: Insère les données d'un fichier CSV
- `execute_sql_file(file_path, conn)`: Exécute une requête SQL depuis un fichier

**Description du script SQL pour la création du schéma de la base de données :**

1. **Création du schéma et configuration du chemin de recherche :**
   - Crée un schéma `offre` s'il n'existe pas déjà.
   - Définit le chemin de recherche sur `offre, public`.

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

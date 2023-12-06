DROP TABLE IF EXISTS specificite_requise, activite_requise, contact_offre, qualification_requise, savoir_etre_requis
    , competence_requise, connaissance_requise, langage_requis, permis_requis, couvrir_deplacement, offre, adresse,
    contact, savoir_etre, competence, experience, niveau_langue, langue, permis, employeur, emploi, duree_temps_partiel,
    duree_contrat, zone_deplacement, connaissance_info, competence, commune, activite CASCADE;


-- Tables simples

CREATE TABLE IF NOT EXISTS activite (
    id_activite INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_activite TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS commune (
    id_commune INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_commune TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS competence (
    id_competence INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_competence TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS connaissance_info (
    id_connaisance_info INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_connaisance_info TEXT
);

CREATE TABLE IF NOT EXISTS zone_deplacement (
    libelle_deplacement TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS duree_contrat (
    id_duree_contrat INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nombre INTEGER NOT NULL,
    type_duree TEXT CHECK(type_duree in ('an(s)','jours', 'mois'))
);

CREATE TABLE IF NOT EXISTS duree_temps_partiel (
    id_duree_temps_partiel INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nombre_heure INTEGER NOT NULL,
    seuil TEXT CHECK(seuil in ('min', 'max'))
);

CREATE TABLE IF NOT EXISTS emploi (
    libelle_emploi TEXT PRIMARY KEY,
    code_rome TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS employeur (
    id_employeur INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    type_employeur TEXT CHECK(type_employeur in ('ENTREPRISE', 'PARTICULIER')),
    nom_entreprise TEXT,
    nom_pers_physique TEXT,
    prenom_pers_physique TEXT,
    employeur_mail TEXT
);

CREATE TABLE IF NOT EXISTS permis (
    id_permis INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_permis TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS langue (
    libelle_langue TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS niveau_langue (
    libelle_niveau TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS experience (
  id_experience INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  libelle_experience TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS competence (
    id_competence INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_competence TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS savoir_etre (
    id_savoir_etre INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_savoir_etre TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS qualification (
    libelle_qualification TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS niveau_formation (
    niveau_formation TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS specificite (
    id_specificite INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_specificite TEXT NOT NULL
);


-- Tables avec une clé étrangère

CREATE TABLE IF NOT EXISTS contact (
      id_contact INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
      nom TEXT NOT NULL,
      prenom TEXT NOT NULL,
      telephone TEXT,
      mobile TEXT,
      fax TEXT,
      contact_mail TEXT,
      id_employeur INTEGER NOT NULL REFERENCES employeur(id_employeur)
);

CREATE TABLE IF NOT EXISTS adresse (
      id_adresse INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
      delivery_point TEXT,
      complement TEXT,
      street TEXT,
      distribution TEXT,
      subdivision TEXT,
      country TEXT,
      id_employeur INTEGER NOT NULL REFERENCES employeur(id_employeur)
);


-- Tables avec plusieurs clés étrangères


CREATE TABLE IF NOT EXISTS offre (
  numero_offre TEXT PRIMARY KEY,
  type_contrat TEXT NOT NULL CHECK(type_contrat in ('CDD', 'CDI', 'CDD évolutif')),
  created DATE NOT NULL,
  updated DATE NOT NULL,
  a_pouvoir_le DATE NOT NULL,
  nb_postes INTEGER NOT NULL,
  accompagnement INTEGER NOT NULL CHECK(accompagnement in (0, 1)),
  date_publication DATE NOT NULL,
  date_archivage DATE,
  date_mise_en_attente DATE,
  date_rejet DATE,
  des_que_possible INTEGER NOT NULL CHECK(des_que_possible in (0, 1)),
  statut TEXT NOT NULL,
  signalee INTEGER NOT NULL CHECK(signalee in (0, 1)),
  date_validite DATE,
  information_complementaire TEXT,
  for_service_accompagnement INTEGER NOT NULL CHECK(for_service_accompagnement in (0, 1)),
  libelle_emploi TEXT NOT NULL REFERENCES emploi(libelle_emploi),
  id_commune INTEGER NOT NULL REFERENCES commune(id_commune),
  id_employeur INTEGER NOT NULL REFERENCES employeur(id_employeur),
  niveau_Formation TEXT REFERENCES niveau_formation(niveau_formation),
  diplome TEXT,
  certification_locale TEXT,
  formation_exigee INTEGER NOT NULL CHECK(formation_exigee in (0, 1)),
  id_experience INTEGER NOT NULL REFERENCES experience(id_experience),
  id_duree_contrat INTEGER REFERENCES duree_contrat(id_duree_contrat),
  id_duree_temps_partiel INTEGER REFERENCES duree_temps_partiel(id_duree_temps_partiel)
);

CREATE TABLE IF NOT EXISTS couvrir_deplacement (
      PRIMARY KEY (libelle_deplacement, numero_offre),
      libelle_deplacement TEXT REFERENCES zone_deplacement(libelle_deplacement),
      numero_offre TEXT REFERENCES offre(numero_offre)
);

CREATE TABLE IF NOT EXISTS permis_requis (
      PRIMARY KEY (id_permis, numero_offre),
      id_permis INTEGER REFERENCES permis(id_permis),
      numero_offre TEXT REFERENCES offre(numero_offre),
      requis TEXT NOT NULL CHECK(requis in ('True', 'False'))
);

CREATE TABLE IF NOT EXISTS langage_requis (
      PRIMARY KEY (libelle_langue, niveau, numero_offre),
      libelle_langue TEXT REFERENCES langue(libelle_langue),
      niveau TEXT REFERENCES niveau_langue(libelle_niveau),
      numero_offre TEXT REFERENCES offre(numero_offre),
      requis TEXT NOT NULL CHECK(requis in ('true', 'false'))
);

CREATE TABLE IF NOT EXISTS connaissance_requise (
      PRIMARY KEY (id_connaisance_info, numero_offre),
      id_connaisance_info INTEGER REFERENCES connaissance_info(id_connaisance_info),
      numero_offre TEXT REFERENCES offre(numero_offre)
);

CREATE TABLE IF NOT EXISTS competence_requise (
    PRIMARY KEY (id_competence, numero_offre),
    id_competence INTEGER REFERENCES competence(id_competence),
    numero_offre TEXT REFERENCES offre(numero_offre)
);

CREATE TABLE IF NOT EXISTS savoir_etre_requis (
    PRIMARY KEY (id_savoir_etre, numero_offre),
    id_savoir_etre INTEGER REFERENCES savoir_etre(id_savoir_etre),
    numero_offre TEXT REFERENCES offre(numero_offre)
);

CREATE TABLE IF NOT EXISTS qualification_requise (
  PRIMARY KEY (libelle_qualification, numero_offre),
    libelle_qualification TEXT REFERENCES qualification(libelle_qualification),
    numero_offre TEXT REFERENCES offre(numero_offre)
);

CREATE TABLE IF NOT EXISTS contact_offre (
    PRIMARY KEY (id_contact, numero_offre),
    id_contact INTEGER REFERENCES contact(id_contact),
    numero_offre TEXT REFERENCES offre(numero_offre)
);

CREATE TABLE IF NOT EXISTS activite_requise (
  PRIMARY KEY (id_activite, numero_offre),
  id_activite INTEGER REFERENCES activite(id_activite),
  numero_offre TEXT REFERENCES offre(numero_offre)
);

CREATE TABLE IF NOT EXISTS specificite_requise (
  PRIMARY KEY (id_specificite, numero_offre),
  id_specificite INTEGER REFERENCES specificite(id_specificite),
  numero_offre TEXT REFERENCES offre(numero_offre)
);

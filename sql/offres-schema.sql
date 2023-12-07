-- Création du schéma de la base de données de l'offre

CREATE SCHEMA IF NOT EXISTS offre;
SET search_path TO offre, public;


-- Suppression des tables

DROP TABLE IF EXISTS offre.contact_offre CASCADE;
DROP TABLE IF EXISTS offre.langue_requise CASCADE;
DROP TABLE IF EXISTS offre.permis_requis CASCADE;
DROP TABLE IF EXISTS offre.connaissance_info_requise CASCADE;
DROP TABLE IF EXISTS offre.savoir_etre_requis CASCADE;
DROP TABLE IF EXISTS offre.couvrir_zone_deplacement CASCADE;
DROP TABLE IF EXISTS offre.specificite_requise CASCADE;
DROP TABLE IF EXISTS offre.competence_requise CASCADE;
DROP TABLE IF EXISTS offre.activite_requise CASCADE;
DROP TABLE IF EXISTS offre.offre CASCADE;
DROP TABLE IF EXISTS offre.adresse CASCADE;
DROP TABLE IF EXISTS offre.contact CASCADE;
DROP TABLE IF EXISTS offre.employeur CASCADE;
DROP TABLE IF EXISTS offre.duree_temps_partiel CASCADE;
DROP TABLE IF EXISTS offre.duree_contrat CASCADE;
DROP TABLE IF EXISTS offre.niveau_langue CASCADE;
DROP TABLE IF EXISTS offre.langue CASCADE;
DROP TABLE IF EXISTS offre.permis CASCADE;
DROP TABLE IF EXISTS offre.emploi CASCADE;
DROP TABLE IF EXISTS offre.niveau_formation CASCADE;
DROP TABLE IF EXISTS offre.qualification CASCADE;
DROP TABLE IF EXISTS offre.experience CASCADE;
DROP TABLE IF EXISTS offre.commune CASCADE;
DROP TABLE IF EXISTS offre.contrat CASCADE;
DROP TABLE IF EXISTS offre.connaissance_info CASCADE;
DROP TABLE IF EXISTS offre.savoir_etre CASCADE;
DROP TABLE IF EXISTS offre.zone_deplacement CASCADE;
DROP TABLE IF EXISTS offre.specificite CASCADE;
DROP TABLE IF EXISTS offre.competence CASCADE;
DROP TABLE IF EXISTS offre.activite CASCADE;


-- Tables simples ("multivalue")

CREATE TABLE IF NOT EXISTS offre.activite (
    id_activite INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_activite TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.competence (
    id_competence INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_competence TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.specificite (
    id_specificite INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_specificite TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.zone_deplacement (
    id_zone_deplacement INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_zone_deplacement TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.savoir_etre (
    id_savoir_etre INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_savoir_etre TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.connaissance_info (
    id_connaisance_info INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_connaisance_info TEXT UNIQUE NOT NULL
);



-- Tables simples

CREATE TABLE IF NOT EXISTS offre.contrat (
    id_contrat INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_contrat TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.commune (
    id_commune INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_commune TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.experience (
  id_experience INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  libelle_experience TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.qualification (
    id_qualification INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_qualification TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.niveau_formation (
    id_niveau_formation INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_niveau_formation TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.emploi (
    libelle_emploi TEXT PRIMARY KEY,
    code_rome TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.permis (
    id_permis INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_permis TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.langue (
    id_langue INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_langue TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.niveau_langue (
    id_niveau_langue INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    libelle_niveau_langue TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS offre.duree_contrat (
    id_duree_contrat INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nombre INTEGER NOT NULL,
    type_duree TEXT CHECK(type_duree in ('an(s)','jours', 'mois','NaN'))
);

CREATE TABLE IF NOT EXISTS offre.duree_temps_partiel (
    id_duree_temps_partiel INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nombre_heure INTEGER,
    seuil TEXT CHECK(seuil in ('min', 'max', 'NaN'))
);

CREATE TABLE IF NOT EXISTS offre.employeur (
    id_employeur INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    type_employeur TEXT CHECK(type_employeur in ('ENTREPRISE', 'PARTICULIER')),
    nom_entreprise TEXT,
    nom_pers_physique TEXT,
    prenom_pers_physique TEXT,
    employeur_mail TEXT
);



-- Tables avec une clé étrangère

CREATE TABLE IF NOT EXISTS offre.contact (
      id_contact INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
      nom TEXT NOT NULL,
      prenom TEXT NOT NULL,
      telephone TEXT,
      mobile TEXT,
      fax TEXT,
      contact_mail TEXT,
      id_employeur INTEGER NOT NULL REFERENCES offre.employeur(id_employeur)
);

CREATE TABLE IF NOT EXISTS offre.adresse (
      id_adresse INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
      delivery_point TEXT,
      complement TEXT,
      street TEXT,
      distribution TEXT,
      subdivision TEXT,
      country TEXT,
      id_employeur INTEGER NOT NULL REFERENCES offre.employeur(id_employeur)
);

CREATE TABLE IF NOT EXISTS offre.offre (
  id_offre TEXT PRIMARY KEY,
  id_contrat INTEGER NOT NULL REFERENCES offre.contrat(id_contrat),
  created DATE NOT NULL,
  updated DATE NOT NULL,
  a_pouvoir_le DATE NOT NULL,
  nb_postes INTEGER NOT NULL,
  accompagnement BOOLEAN NOT NULL,
  date_publication DATE NOT NULL,
  date_archivage DATE,
  date_mise_en_attente DATE,
  date_rejet DATE,
  des_que_possible BOOLEAN NOT NULL,
  statut TEXT NOT NULL,
  signalee BOOLEAN NOT NULL,
  date_validite DATE,
  information_complementaire TEXT,
  for_service_accompagnement BOOLEAN NOT NULL,
  libelle_emploi TEXT NOT NULL REFERENCES offre.emploi(libelle_emploi),
  id_commune INTEGER NOT NULL REFERENCES offre.commune(id_commune),
  id_qualification INTEGER NOT NULL REFERENCES offre.qualification(id_qualification),
  id_employeur INTEGER NOT NULL REFERENCES offre.employeur(id_employeur),
  id_niveau_formation INTEGER NOT NULL REFERENCES offre.niveau_formation(id_niveau_formation),
  diplome TEXT,
  certification_locale TEXT,
  formation_exigee BOOLEAN NOT NULL,
  id_experience INTEGER NOT NULL REFERENCES offre.experience(id_experience),
  id_duree_contrat INTEGER REFERENCES offre.duree_contrat(id_duree_contrat),
  id_duree_temps_partiel INTEGER REFERENCES offre.duree_temps_partiel(id_duree_temps_partiel)
);

CREATE TABLE IF NOT EXISTS offre.activite_requise (
  PRIMARY KEY (id_offre, id_activite),
  id_offre TEXT REFERENCES offre.offre(id_offre),
  id_activite INTEGER REFERENCES offre.activite(id_activite)
);

CREATE TABLE IF NOT EXISTS offre.competence_requise (
    PRIMARY KEY (id_offre, id_competence),
    id_offre TEXT REFERENCES offre.offre(id_offre),
    id_competence INTEGER REFERENCES offre.competence(id_competence)
);

CREATE TABLE IF NOT EXISTS offre.specificite_requise (
  PRIMARY KEY (id_offre, id_specificite),
  id_offre TEXT REFERENCES offre.offre(id_offre),
  id_specificite INTEGER REFERENCES offre.specificite(id_specificite)
);

CREATE TABLE IF NOT EXISTS offre.couvrir_zone_deplacement (
      PRIMARY KEY (id_offre, id_zone_deplacement),
      id_offre TEXT REFERENCES offre.offre(id_offre),
      id_zone_deplacement INTEGER REFERENCES offre.zone_deplacement(id_zone_deplacement)
);

CREATE TABLE IF NOT EXISTS offre.savoir_etre_requis (
    PRIMARY KEY (id_offre, id_savoir_etre),
    id_offre TEXT REFERENCES offre.offre(id_offre),
    id_savoir_etre INTEGER REFERENCES offre.savoir_etre(id_savoir_etre)
);

CREATE TABLE IF NOT EXISTS offre.connaissance_info_requise (
    PRIMARY KEY (id_offre, id_connaisance_info),
    id_offre TEXT REFERENCES offre.offre(id_offre),
    id_connaisance_info INTEGER REFERENCES offre.connaissance_info(id_connaisance_info)
);

CREATE TABLE IF NOT EXISTS offre.permis_requis (
      PRIMARY KEY (id_offre, id_permis),
      id_offre TEXT REFERENCES offre.offre(id_offre),
      id_permis INTEGER REFERENCES offre.permis(id_permis),
      requis TEXT NOT NULL CHECK(requis in ('true', 'false', 'NaN'))
);

CREATE TABLE IF NOT EXISTS offre.langue_requise (
    PRIMARY KEY (id_offre, id_langue, id_niveau_langue),
    id_offre TEXT REFERENCES offre.offre(id_offre),
    id_langue INTEGER REFERENCES offre.langue(id_langue),
    id_niveau_langue INTEGER REFERENCES offre.niveau_langue(id_niveau_langue),
    requis BOOLEAN
);

CREATE TABLE IF NOT EXISTS offre.contact_offre (
    PRIMARY KEY (id_offre, id_contact),
    id_offre TEXT REFERENCES offre.offre(id_offre),
    id_contact INTEGER REFERENCES offre.contact(id_contact)
);
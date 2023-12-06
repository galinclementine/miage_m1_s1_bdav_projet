-- Insertion des données brutes dans les tables de la base de données


-- Préparation en amont des colonnes "multivalue" afin de formater la séparation des données par des virgules

-- On remplace les , par des ; pour les activités, et on remplace les , par des . pour les chiffres
UPDATE offre_temp
SET activites_multivalue = replace(activites_multivalue,', ','; ')
WHERE activites_multivalue like '%, %';
UPDATE offre_temp
SET activites_multivalue = REGEXP_REPLACE(activites_multivalue,E',([0-9]+)',E'.\\1','g')
WHERE activites_multivalue ~ E',[0-9]+';
COMMIT;

-- On remplace les , par des ; pour les compétences
UPDATE offre_temp
SET competences_multivalue = replace(competences_multivalue,', ','; ')
WHERE competences_multivalue like '%, %';
COMMIT;

-- On remplace les , par des ; pour les spécificités
UPDATE offre_temp
SET specifites_multivalue = replace(specifites_multivalue,', ','; ')
WHERE specifites_multivalue like '%, %';
COMMIT;

-- On remplace les , par des ; pour les zones de déplacement
UPDATE offre_temp
SET zonesdeplacement_multivalue = replace(zonesdeplacement_multivalue,', ','; ')
WHERE zonesdeplacement_multivalue like '%, %';
COMMIT;

-- On remplace les , par des ; pour les savoir être
UPDATE offre_temp
SET savoirsetre_multivalue = replace(savoirsetre_multivalue,', ','; ')
WHERE savoirsetre_multivalue like '%, %';
COMMIT;

-- On remplace les , par des ; pour les connaissances info
UPDATE offre_temp
SET connaissancesinfo_multivalue = replace(connaissancesinfo_multivalue,', ','; ')
WHERE connaissancesinfo_multivalue like '%, %';
COMMIT;



-- Tables simples ("multivalue")

INSERT INTO activite (libelle_activite)
SELECT regexp_split_to_table(activites_multivalue, E',') activite
FROM offre_temp
GROUP BY activite
ORDER BY activite
ON CONFLICT (libelle_activite) DO NOTHING;

INSERT INTO competence (libelle_competence)
SELECT regexp_split_to_table(competences_multivalue, E',') competence
FROM offre_temp
GROUP BY competence
ORDER BY competence
ON CONFLICT (libelle_competence) DO NOTHING;

INSERT INTO specificite (libelle_specificite)
SELECT regexp_split_to_table(specifites_multivalue, E',') specificite
FROM offre_temp
GROUP BY specificite
ORDER BY specificite;

INSERT INTO zone_deplacement (libelle_deplacement)
SELECT regexp_split_to_table(zonesdeplacement_multivalue, E',') zone_deplacement
FROM offre_temp
GROUP BY zone_deplacement
ORDER BY zone_deplacement
ON CONFLICT (libelle_deplacement) DO NOTHING;

INSERT INTO savoir_etre (libelle_savoir_etre)
SELECT regexp_split_to_table(savoirsetre_multivalue, E',') savoir_etre
FROM offre_temp
GROUP BY savoir_etre
ORDER BY savoir_etre
ON CONFLICT (libelle_savoir_etre) DO NOTHING;

INSERT INTO connaissance_info (libelle_connaisance_info)
SELECT regexp_split_to_table(connaissancesinfo_multivalue, E',') connaissance_info
FROM offre_temp
GROUP BY connaissance_info
ORDER BY connaissance_info
ON CONFLICT (libelle_connaisance_info) DO NOTHING;



-- Tables simples

INSERT INTO contrat (libelle_contrat)
SELECT typeContrat
FROM offre_temp
GROUP BY typeContrat
ORDER BY typeContrat
ON CONFLICT (libelle_contrat) DO NOTHING;

INSERT INTO commune (libelle_commune)
SELECT communeemploi
FROM offre_temp
GROUP BY communeemploi
ORDER BY communeemploi
ON CONFLICT (libelle_commune) DO NOTHING;

INSERT INTO experience (libelle_experience)
SELECT experience
FROM offre_temp
GROUP BY experience
ORDER BY experience
ON CONFLICT (libelle_experience) DO NOTHING;

INSERT INTO qualification (libelle_qualification)
SELECT qualifications
FROM offre_temp
GROUP BY qualifications
ORDER BY qualifications
ON CONFLICT (libelle_qualification) DO NOTHING;

INSERT INTO niveau_formation (niveau_formation)
SELECT niveauformation
FROM offre_temp
GROUP BY niveauformation
ORDER BY niveauformation
ON CONFLICT (niveau_formation) DO NOTHING;


INSERT INTO emploi (libelle_emploi, code_rome)
SELECT titreOffre, codeROME
FROM offre_temp
GROUP BY titreOffre, codeROME
ORDER BY titreOffre, codeROME;


INSERT INTO permis (libelle_permis)
SELECT permis_1_libelle permis FROM offre_temp
UNION
SELECT permis_2_libelle permis FROM offre_temp
UNION
SELECT permis_3_libelle permis FROM offre_temp
ORDER BY permis
ON CONFLICT (libelle_permis) DO NOTHING;

INSERT INTO langue (libelle_langue)
SELECT langues_1_libelle langue FROM offre_temp
UNION
SELECT langues_2_libelle langue FROM offre_temp
UNION
SELECT langues_3_libelle langue FROM offre_temp
ORDER BY langue
ON CONFLICT (libelle_langue) DO NOTHING;

INSERT INTO niveau_langue (libelle_niveau)
SELECT langues_1_niveau niveau FROM offre_temp
UNION
SELECT langues_2_niveau niveau FROM offre_temp
UNION
SELECT langues_3_niveau niveau FROM offre_temp
ORDER BY niveau
ON CONFLICT (libelle_niveau) DO NOTHING;


INSERT INTO duree_contrat (nombre, type_duree)
SELECT duree::INTEGER, uniteduree
FROM offre_temp
GROUP BY duree, uniteduree
ORDER BY uniteduree, duree::INTEGER;

INSERT INTO duree_temps_partiel (nombre_heure, seuil)
SELECT
    substring(dureetempspartiel,'([0-9]{1,4})')::INTEGER,
    CASE
        WHEN dureetempspartiel like 'Au moins %' THEN 'min'
        WHEN dureetempspartiel like 'Moins de %' THEN 'max'
        WHEN dureetempspartiel = 'NaN' THEN 'NaN'
    END seuil
FROM offre_temp
GROUP BY dureetempspartiel
ORDER BY dureetempspartiel;


INSERT INTO employeur (type_employeur, nom_entreprise, nom_pers_physique, prenom_pers_physique, employeur_mail)
SELECT 
    employeur_type,
    employeur_nomentreprise,
    employeur_nompersphysique,
    employeur_prenompersphysique,
    employeur_email
FROM offre_temp
GROUP BY
    employeur_type,
    employeur_nomentreprise,
    employeur_nompersphysique,
    employeur_prenompersphysique,
    employeur_email
ORDER BY
    employeur_type,
    employeur_nomentreprise,
    employeur_nompersphysique,
    employeur_prenompersphysique,
    employeur_email;



-- Tables avec une clé étrangère

INSERT INTO contact (id_employeur, nom, prenom, telephone, mobile, fax, contact_mail)
SELECT
	e.id_employeur,
	t.employeur_nompersphysique,
	t.employeur_prenompersphysique,
	t.contact_telephone,
	t.contact_mobile,
	t.contact_fax,
	t.contact_mail
FROM offre_temp t LEFT JOIN employeur e
	ON t.employeur_type = e.type_employeur
	AND t.employeur_nomentreprise = e.nom_entreprise
	AND t.employeur_nompersphysique = e.nom_pers_physique
	AND t.employeur_prenompersphysique = e.prenom_pers_physique
	AND t.employeur_email = e.employeur_mail
GROUP BY 
	e.id_employeur,
	t.employeur_nompersphysique,
	t.employeur_prenompersphysique,
	t.contact_telephone,
	t.contact_mobile,
	t.contact_fax,
	t.contact_mail;


INSERT INTO adresse (id_employeur, delivery_point, complement, street, distribution, subdivision, country)
SELECT
	e.id_employeur,
	t.employeur_adressecorrespondance_deliverypoint,
	t.employeur_adressecorrespondance_complement,
	t.employeur_adressecorrespondance_street,
	t.employeur_adressecorrespondance_distribution,
	t.employeur_adressecorrespondance_subdivision,
	t.employeur_adressecorrespondance_country
FROM offre_temp t LEFT JOIN employeur e
	ON t.employeur_type = e.type_employeur
	AND t.employeur_nomentreprise = e.nom_entreprise
	AND t.employeur_nompersphysique = e.nom_pers_physique
	AND t.employeur_prenompersphysique = e.prenom_pers_physique
	AND t.employeur_email = e.employeur_mail
GROUP BY
	e.id_employeur,
	t.employeur_adressecorrespondance_deliverypoint,
	t.employeur_adressecorrespondance_complement,
	t.employeur_adressecorrespondance_street,
	t.employeur_adressecorrespondance_distribution,
	t.employeur_adressecorrespondance_subdivision,
	t.employeur_adressecorrespondance_country;



-- Tables avec plusieurs clés étrangères

INSERT INTO offre (
    numero_offre,
    type_contrat,
    created,
    updated,
    a_pouvoir_le,
    nb_postes,
    accompagnement,
    date_publication,
    date_archivage,
    date_mise_en_attente,
    date_rejet,
    des_que_possible,
    statut,
    signalee,
    date_validite,
    information_complementaire,
    for_service_accompagnement,
    libelle_emploi,
    id_commune,
    id_employeur,
    niveau_Formation,
    diplome,
    certification_locale,
    formation_exigee,
    id_experience,
    id_duree_contrat,
    id_duree_temps_partiel
)
SELECT
	t.numero,
	t.typeContrat,
	t.created::TIMESTAMP created,
	t.updated::TIMESTAMP updated,
	t.aPourvoirLe::DATE aPourvoirLe,
	t.nbPostes::INTEGER nbPostes,
	t.accompagnement::INTEGER accompagnement,
	t.datePublication::TIMESTAMP datePublication,
	CASE WHEN t.dateArchivage != 'NaN' THEN t.dateArchivage::TIMESTAMP END dateArchivage,
	CASE WHEN t.dateMiseEnAttente != 'NaN' THEN t.dateMiseEnAttente::TIMESTAMP END dateMiseEnAttente,
	CASE WHEN t.dateRejet != 'NaN' THEN t.dateRejet::TIMESTAMP END dateRejet,
	t.desQuePossible::INTEGER desQuePossible,
	t.statut,
	t.signalee::INTEGER signalee,
	t.dateValidite::DATE dateValidite,
	t.informationComplementaire,
	t.forServiceAccompagnement::INTEGER forServiceAccompagnement,
	t.titreOffre,
	c.id_commune,
	e.id_employeur,
	t.niveauFormation,
	t.diplome,
	t.certificationLocale,
	t.formationExigee::INTEGER formationExigee,
	ex.id_experience,
	dc.id_duree_contrat,
	dtp.id_duree_temps_partiel
FROM offre_temp t LEFT JOIN employeur e
	ON t.employeur_type = e.type_employeur
		AND t.employeur_nomentreprise = e.nom_entreprise
		AND t.employeur_nompersphysique = e.nom_pers_physique
		AND t.employeur_prenompersphysique = e.prenom_pers_physique
		AND t.employeur_email = e.employeur_mail
	LEFT JOIN commune c
	ON t.communeEmploi = c.libelle_commune
	LEFT JOIN duree_temps_partiel dtp
	ON substring(t.dureetempspartiel,'([0-9]{1,4})')::INTEGER = dtp.nombre_heure
		AND CASE
				WHEN t.dureetempspartiel like 'Au moins %' THEN 'min'
				WHEN t.dureetempspartiel like 'Moins de %' THEN 'max'
				WHEN t.dureetempspartiel = 'NaN' THEN 'NaN'
			END = dtp.seuil
	LEFT JOIN duree_contrat dc
	ON t.duree::INTEGER = dc.nombre
		AND t.uniteduree = dc.type_duree
	LEFT JOIN experience ex
	ON t.experience = ex.libelle_experience;


INSERT INTO activite_requise (numero_offre, id_activite)
WITH r AS (
	SELECT numero, regexp_split_to_table(activites_multivalue, E',') activite
	FROM offre_temp
	GROUP BY numero, activite
)
SELECT r.numero, a.id_activite
FROM r LEFT JOIN activite a ON r.activite = a.libelle_activite
ORDER BY r.numero, a.id_activite;

INSERT INTO competence_requise (numero_offre, id_competence)
WITH r AS (
	SELECT numero, regexp_split_to_table(competences_multivalue, E',') competence
	FROM offre_temp
	GROUP BY numero, competence
)
SELECT r.numero, c.id_competence
FROM r LEFT JOIN competence c ON r.competence = c.libelle_competence
ORDER BY r.numero, c.id_competence;

INSERT INTO specificite_requise (numero_offre, id_specificite)
WITH r AS (
	SELECT numero, regexp_split_to_table(specifites_multivalue, E',') specificite
	FROM offre_temp
	GROUP BY numero, specificite
)
SELECT r.numero, s.id_specificite
FROM r LEFT JOIN specificite s ON r.specificite = s.libelle_specificite
ORDER BY r.numero, s.id_specificite;

INSERT INTO couvrir_deplacement (numero_offre, libelle_deplacement)
SELECT numero, regexp_split_to_table(zonesdeplacement_multivalue, E',') libelle_deplacement
FROM offre_temp
GROUP BY numero, libelle_deplacement
ORDER BY numero, libelle_deplacement;

INSERT INTO savoir_etre_requis (numero_offre, id_savoir_etre)
WITH r AS (
	SELECT numero, regexp_split_to_table(savoirsetre_multivalue, E',') savoir_etre
	FROM offre_temp
	GROUP BY numero, savoir_etre
)
SELECT r.numero, se.id_savoir_etre
FROM r LEFT JOIN savoir_etre se ON r.savoir_etre = se.libelle_savoir_etre
ORDER BY r.numero, se.id_savoir_etre;

INSERT INTO connaissance_requise (numero_offre, id_connaisance_info)
WITH r AS (
	SELECT numero, regexp_split_to_table(connaissancesinfo_multivalue, E',') connaisance_info
	FROM offre_temp
	GROUP BY numero, connaisance_info
)
SELECT r.numero, ci.id_connaisance_info
FROM r LEFT JOIN connaissance_info ci ON r.connaisance_info = ci.libelle_connaisance_info
ORDER BY r.numero, ci.id_connaisance_info;


INSERT INTO permis_requis (numero_offre, id_permis, requis)
WITH r AS (
	SELECT numero, permis_1_libelle permis, permis_1_exige requis FROM offre_temp
	UNION
	SELECT numero, permis_2_libelle permis, permis_2_exige requis FROM offre_temp
	UNION
	SELECT numero, permis_3_libelle permis, permis_3_exige requis FROM offre_temp
)
SELECT r.numero, p.id_permis, r.requis
FROM r LEFT JOIN permis p ON r.permis = p.libelle_permis
ORDER BY r.numero, p.id_permis, r.requis;

INSERT INTO langage_requis (numero_offre, libelle_langue, niveau, requis)
SELECT numero, langues_1_libelle langue, langues_1_niveau niveau, langues_1_exige requis FROM offre_temp
UNION
SELECT numero, langues_2_libelle langue, langues_2_niveau niveau, langues_2_exige requis FROM offre_temp
UNION
SELECT numero, langues_3_libelle langue, langues_3_niveau niveau, langues_3_exige requis FROM offre_temp
ORDER BY numero, langue, niveau, requis;


INSERT INTO contact_offre (numero_offre, id_contact)
SELECT t.numero, c.id_contact
FROM offre_temp t LEFT JOIN employeur e
	ON t.employeur_type = e.type_employeur
		AND t.employeur_nomentreprise = e.nom_entreprise
		AND t.employeur_nompersphysique = e.nom_pers_physique
		AND t.employeur_prenompersphysique = e.prenom_pers_physique
		AND t.employeur_email = e.employeur_mail
	LEFT JOIN contact c
	ON t.employeur_nompersphysique = c.nom
		AND t.employeur_prenompersphysique = c.prenom
		AND t.contact_telephone = c.telephone
		AND t.contact_mobile = c.mobile
		AND t.contact_fax = c.fax
		AND t.contact_mail = c.contact_mail
		AND e.id_employeur = c.id_employeur
GROUP BY t.numero, c.id_contact
ORDER BY t.numero, c.id_contact;

INSERT INTO qualification_requise (numero_offre, libelle_qualification)
SELECT numero, qualifications
FROM offre_temp
GROUP BY numero, qualifications
ORDER BY numero, qualifications;



-- Reformatage initial des colonnes "multivalue"

-- On remet les ; par des , pour les activités, et les . par des , pour les chiffres
UPDATE offre_temp
SET activites_multivalue = replace(activites_multivalue,'; ',', ')
WHERE activites_multivalue like '%; %';
UPDATE offre_temp
SET activites_multivalue = REGEXP_REPLACE(activites_multivalue,E'.([0-9]+)',E',\\1','g')
WHERE activites_multivalue ~ E'.[0-9]+';
UPDATE activite
SET libelle_activite = replace(libelle_activite,'; ',', ')
WHERE libelle_activite like '%; %';
UPDATE activite
SET libelle_activite = REGEXP_REPLACE(libelle_activite,E'\\.([0-9]+)',E',\\1','g')
WHERE libelle_activite ~ E'\.[0-9]+';
COMMIT;

-- On remet les ; par des , pour les compétences,
UPDATE offre_temp
SET competences_multivalue = replace(competences_multivalue,'; ',', ')
WHERE competences_multivalue like '%; %';
UPDATE competence
SET libelle_competence = replace(libelle_competence,'; ',', ')
WHERE libelle_competence like '%; %';
COMMIT;

-- On remet les ; par des , pour les spécificités
UPDATE offre_temp
SET specifites_multivalue = replace(specifites_multivalue,'; ',', ')
WHERE specifites_multivalue like '%; %';
UPDATE specificite
SET libelle_specificite = replace(libelle_specificite,'; ',', ')
WHERE libelle_specificite like '%; %';
COMMIT;

-- On remet les ; par des , pour les zones de déplacement
UPDATE offre_temp
SET zonesdeplacement_multivalue = replace(zonesdeplacement_multivalue,'; ',', ')
WHERE zonesdeplacement_multivalue like '%; %';
UPDATE zone_deplacement
SET libelle_deplacement = replace(libelle_deplacement,'; ',', ')
WHERE libelle_deplacement like '%; %';
COMMIT;

-- On remet les ; par des , pour les savoir être
UPDATE offre_temp
SET savoirsetre_multivalue = replace(savoirsetre_multivalue,'; ',', ')
WHERE savoirsetre_multivalue like '%; %';
UPDATE savoir_etre
SET libelle_savoir_etre = replace(libelle_savoir_etre,'; ',', ')
WHERE libelle_savoir_etre like '%; %';
COMMIT;

-- On remet les ; par des , pour les connaissances info
UPDATE offre_temp
SET connaissancesinfo_multivalue = replace(connaissancesinfo_multivalue,'; ',', ')
WHERE connaissancesinfo_multivalue like '%; %';
UPDATE connaissance_info
SET libelle_connaisance_info = replace(libelle_connaisance_info,'; ',', ')
WHERE libelle_connaisance_info like '%; %';
COMMIT;
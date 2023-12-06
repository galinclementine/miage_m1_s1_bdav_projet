-- Insertion des données brutes dans les tables de la base de données

-- Tables simples

INSERT INTO activite (libelle_activite)
SELECT activites_multivalue
FROM offre_temp
--WHERE activites_multivalue not in (SELECT libelle_activite FROM activite)
GROUP BY activites_multivalue
ORDER BY activites_multivalue
ON CONFLICT (libelle_activite) DO NOTHING;

INSERT INTO commune (libelle_commune)
SELECT communeemploi
FROM offre_temp
--WHERE communeemploi not in (SELECT libelle_commune FROM commune)
GROUP BY communeemploi
ORDER BY communeemploi
ON CONFLICT (libelle_commune) DO NOTHING;

INSERT INTO competence (libelle_competence)
SELECT competences_multivalue
FROM offre_temp
--WHERE competences_multivalue not in (SELECT libelle_competence FROM competence)
GROUP BY competences_multivalue
ORDER BY competences_multivalue
ON CONFLICT (libelle_competence) DO NOTHING;

INSERT INTO connaissance_info (libelle_connaisance_info)
SELECT connaissancesinfo
FROM offre_temp
--WHERE connaissancesinfo not in (SELECT libelle_connaisance_info FROM connaissance_info)
GROUP BY connaissancesinfo
ORDER BY connaissancesinfo
ON CONFLICT (libelle_connaisance_info) DO NOTHING;

INSERT INTO zone_deplacement (libelle_deplacement)
SELECT zonesdeplacement_multivalue
FROM offre_temp
--WHERE zonesdeplacement_multivalue not in (SELECT libelle_deplacement FROM zone_deplacement)
GROUP BY zonesdeplacement_multivalue
ORDER BY zonesdeplacement_multivalue
ON CONFLICT (libelle_deplacement) DO NOTHING;

INSERT INTO duree_contrat (nombre, type_duree)
SELECT duree::INTEGER, uniteduree
FROM offre_temp
--WHERE (duree::INTEGER, uniteduree) not in (SELECT nombre, type_duree FROM duree_contrat)
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

INSERT INTO emploi (libelle_emploi, code_rome)
SELECT titreOffre, codeROME
FROM offre_temp
--WHERE (titreOffre, codeROME) not in (SELECT libelle_emploi, code_rome FROM emploi)
GROUP BY titreOffre, codeROME
ORDER BY titreOffre, codeROME;
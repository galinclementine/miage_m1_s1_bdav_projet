-- Insertion des données brutes dans les tables de la base de données

INSERT INTO activite (libelle_activite)
SELECT activites_multivalue
FROM offre_temp
WHERE activites_multivalue not in (SELECT libelle_activite FROM activite)
ON CONFLICT (libelle_activite) DO NOTHING;

INSERT INTO emploi (libelle_emploi, code_rome)
SELECT titreOffre, codeROME
FROM offre_temp
WHERE (titreOffre, codeROME) not in (SELECT libelle_emploi, code_rome FROM emploi)
GROUP BY titreOffre, codeROME;
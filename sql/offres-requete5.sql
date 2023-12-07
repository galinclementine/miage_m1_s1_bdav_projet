-- Niveau de formation demandé en NC

SELECT coalesce(libelle_niveau_formation,'Non renseigné') AS "Niveaux de formation", count(*) AS "Nb offres"
FROM offre.offre
	LEFT JOIN offre.niveau_formation USING(id_niveau_formation)
GROUP BY libelle_niveau_formation
ORDER BY 2 desc;
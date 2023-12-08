-- Métiers couvrant toutes les zones de déplacement

SELECT libelle_emploi AS "Emploi"
FROM offre.offre
	JOIN offre.couvrir_zone_deplacement USING(id_offre)
	JOIN offre.zone_deplacement USING(id_zone_deplacement)
GROUP BY libelle_emploi
HAVING count(distinct libelle_zone_deplacement) = (SELECT count(*) FROM offre.zone_deplacement)
ORDER BY 1;
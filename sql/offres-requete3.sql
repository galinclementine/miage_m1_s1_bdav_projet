-- Métiers polyglothes

SELECT libelle_emploi AS "Emploi", count(distinct id_langue) AS "Nb langues requises"
FROM offre.offre
	JOIN offre.langue_requise USING(id_offre)
WHERE requis
GROUP BY libelle_emploi
HAVING count(distinct id_langue) > 1
ORDER BY 2 desc, 1;
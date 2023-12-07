-- Top 3 des compétences les plus demandées par expérience

WITH competence_ranking AS (
    SELECT 
        exp.libelle_experience,
        comp.libelle_competence,
        COUNT(*) AS nombre_offres,
        ROW_NUMBER() OVER (
            PARTITION BY exp.libelle_experience
            ORDER BY COUNT(*) DESC
        ) AS rank
    FROM 
        offre.offre o
    JOIN offre.competence_requise comp_req ON o.id_offre = comp_req.id_offre
    JOIN offre.competence comp ON comp_req.id_competence = comp.id_competence
    JOIN offre.experience exp ON o.id_experience = exp.id_experience
    GROUP BY 
        exp.libelle_experience, 
        comp.libelle_competence
)
SELECT 
    libelle_experience,
    MAX(CASE WHEN rank = 1 THEN libelle_competence END) AS "Top 1 Competence",
    MAX(CASE WHEN rank = 2 THEN libelle_competence END) AS "Top 2 Competence",
    MAX(CASE WHEN rank = 3 THEN libelle_competence END) AS "Top 3 Competence"
FROM 
    competence_ranking
WHERE 
    rank <= 3
GROUP BY 
    libelle_experience
ORDER BY 
    libelle_experience;

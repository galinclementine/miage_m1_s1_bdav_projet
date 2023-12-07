-- Nombre d'offres par commune et par type de contrat
WITH ContratCounts AS (
    SELECT 
        c.libelle_commune,
        CASE 
            WHEN ct.libelle_contrat LIKE '%CDD%' THEN 'CDD'
            WHEN ct.libelle_contrat LIKE '%CDI%' THEN 'CDI'
            ELSE 'Autre'
        END AS TypeContrat,
        COUNT(*) AS nombre_offres
    FROM 
        offre.offre o
    JOIN offre.commune c ON o.id_commune = c.id_commune
    JOIN offre.contrat ct ON o.id_contrat = ct.id_contrat
    GROUP BY 
        c.libelle_commune, 
        TypeContrat
),
PivotContrats AS (
    SELECT 
        libelle_commune AS "Commune",
        SUM(CASE WHEN TypeContrat = 'CDD' THEN nombre_offres ELSE 0 END) AS "Offres CDD",
        SUM(CASE WHEN TypeContrat = 'CDI' THEN nombre_offres ELSE 0 END) AS "Offres CDI",
        SUM(nombre_offres) as "Total"
    FROM 
        ContratCounts
    WHERE 
        TypeContrat IN ('CDD', 'CDI')
    GROUP BY 
        libelle_commune
)
SELECT 
    *
FROM 
    PivotContrats
ORDER BY 
    "Total" DESC;
:
:
EMPLOI: code_rome,libelle_emploi
:
SAVOIRS_ETRE: id_savoir_etre, libelle_savoir_etre
:
:
:
:
:
:
:

:
CONNAISSANCES_INFO: id_connaisances_info, libelle_connaisances_info
DF, 11 OFFRE, 1N EMPLOI
EXPERIENCE: id_experience, libelle_experience
NECESSITE3, 1N SAVOIRS_ETRE, 0N OFFRE
COMMUNE: id_commune, libelle_commune
:
:
:
:
:
:

ACTIVITE: id_activite, libelle_activite
POSSEDE2, 1N ACTIVITE, 0N OFFRE
NECESSITE1, 1N CONNAISSANCES_INFO, 0N OFFRE
DF, 11 OFFRE, 1N EXPERIENCE
DF, 11 OFFRE, 1N COMMUNE
EXIGE, 0N PERMIS, 03 OFFRE: exige
PERMIS: id_permis, libelle_permis
:
:
:
:
:

:
SPECIFICITE: id_specificite, libelle_specificite
POSSEDE5, 1N SPECIFICITE, 0N OFFRE
OFFRE: numero,created,updated,aPourvoirLe,nbPostes,accompagnement,datePublication,dateArchivage,dateMiseEnAttente,dateRejet,duree,uniteDuree,dureeTempsPartiel,desQuePossible,statut,signalee,dateValidite,informationComplementaire,forServiceAccompagnement,contact_telephone,contact_mobile,contact_fax,contact_mail
NECESSITE2, 1N COMPETENCE, 0N OFFRE
COMPETENCE: id_competence, libelle_competence
:
:
:
:
:
:

NIVEAU_FORMATION: niveauFormation
DEMANDE, 11 OFFRE, 1N NIVEAU_FORMATION: diplome,certificationLocale,formationExigee
COUVRE, 1N ZONES_DEPLACEMENT, 0N OFFRE
DF, 11 OFFRE, 1N EMPLOYEUR
EMPLOYEUR: employeur_nomentreprise,employeur_nompersphysique,employeur_prenompersphysique,employeur_email,employeur_adressecorrespondance_deliverypoint,employeur_adressecorrespondance_complement,employeur_adressecorrespondance_street,employeur_adressecorrespondance_distribution,employeur_adressecorrespondance_subdivision,employeur_adressecorrespondance_country,
EXIGE2, 0N LANGUES, 0N NIVEAU_LANGUES, 03 OFFRE: exige
LANGUES: libelle
:
:
:
:
NECESSITE4, 1N QUALIFICATIONS, 0N OFFRE
QUALIFICATIONS: libelle

:
ZONES_DEPLACEMENT: libelle
DF, 11 OFFRE, 1N TYPE_CONTRAT
TYPE_EMPLOYEUR: employeur_type
DF, 11 EMPLOYEUR, 1N TYPE_EMPLOYEUR
NIVEAU_LANGUES: niveau
:
:
:
:
:
:

:
:
TYPE_CONTRAT: typeContrat
:
:
:
:
:
:
:
:
:

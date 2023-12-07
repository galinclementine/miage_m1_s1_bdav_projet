:
:
NIVEAU_LANGUE: niveau
LANGUE: libelle_langue
:
:

:
SPECIFICITE: id_specificite, libelle_specificite
EXIGE2, 0N LANGUE, 0N NIVEAU_LANGUE, 03 OFFRE: exige
COMMUNE: id_commune, libelle_commune

ACTIVITE: id_activite, libelle_activite

ADRESSE : id_adresse, delivery_point, complement, street, distribution, subdivision, country 

EMPLOI: libelle_emploi, code_rome
DF, 11 OFFRE, 1N EMPLOI
POSSEDE5, 1N SPECIFICITE, 0N OFFRE
DF, 11 OFFRE, 1N COMMUNE
POSSEDE2, 1N ACTIVITE, 0N OFFRE
DF, 11 OFFRE, 1N EMPLOYEUR
EMPLOYEUR: id_employeur, type_employeur, nom_entreprise, nom_pers_physique, prenom_pers_physique, employeur_mail
POSSEDE4, 11 ADRESSE, 1N EMPLOYEUR

:
COMPETENCE: id_competence, libelle_competence
NECESSITE2, 1N COMPETENCE, 0N OFFRE
OFFRE: numero_offre,type_contrat, created,updated,a_pouvoir_le,nb_postes,accompagnement,date_publication,date_archivage,date_mise_en_attente,date_rejet,des_que_possible,statut,signalee,date_validite,information_complementaire,for_service_accompagnement
NECESSITE5, 1N CONTACT, ON OFFRE
CONTACT : id_contact, nom, prenom, telephone, mobile, fax, contact_mail
POSSEDE3, 11 CONTACT, 1N EMPLOYEUR
:

ZONE_DEPLACEMENT: libelle
COUVRE, 1N ZONE_DEPLACEMENT, 0N OFFRE
DEMANDE, 11 OFFRE, 1N NIVEAU_FORMATION: diplome,certification_locale,formation_exigee
NECESSITE3, 1N SAVOIR_ETRE, 0N OFFRE
NECESSITE1, 1N CONNAISSANCE_INFO, 0N OFFRE
DF, 11 OFFRE, 1N EXPERIENCE
EXPERIENCE: id_experience, libelle_experience
:

:
NIVEAU_FORMATION: niveauFormation
EXIGE, 0N PERMIS, 03 OFFRE: requis
SAVOIR_ETRE: id_savoir_etre, libelle_savoir_etre
NECESSITE4, 1N QUALIFICATION, 0N OFFRE
CONNAISSANCE_INFO: id_connaisance_info, libelle_connaisance_info
:
:

:
:
PERMIS: id_permis, libelle_permis
:
QUALIFICATION: libelle_qualification
:
:
:
DUREE_CONTRAT : id_duree_contrat, nombre, type_duree
POSSEDE6, 1N DUREE_CONTRAT, 11 OFFRE
DUREE_TEMPS_PARTIEL: id_duree_temps_partiel, nombre_heure, seuil
POSSEDE7, 1N DUREE_TEMPS_PARTIEL, 11 OFFRE
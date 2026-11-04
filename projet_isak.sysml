package aspWash {
    private import ScalarValues::Boolean;
    package parts {
        /* acteurs */
        part def ResponsableProduction;
        part def OperateurUsager;
        part def ResponsableMaintenance;
        part def ReseauAlerte;

        /* systeme */
        part def AspWashRA1;
    }

    package useCases {
        private import aspWash::parts::*;

        actor responsableProduction : ResponsableProduction;
        actor operateurUsager : OperateurUsager;
        actor responsableMaintenance : ResponsableMaintenance;
        actor reseauAlerte : ReseauAlerte;

        use case reconnaitreDechets {
            ref actor responsableProduction;
        }

        use case detecterObstaclesUsagers {
            ref actor operateurUsager;
        }

        use case nettoyerZoneInaccessible {
            ref actor responsableProduction;
        }

        use case alarmeInterventionSol {
            ref actor responsableMaintenance;
            ref actor reseauAlerte;
        }
    }
    part def Contexte {
        part responsableProduction: ResponsableProduction;
        part operateurUsager: OperateurUsager[*];
        part responsableMaintenance: ResponsableMaintenance;
        part reseauAlerte: ReseauAlerte;
        part robot: AspWashRA1;
        part reseauElectrique;
        part stationRecharge: StationRecharge;
        part dechet: Dechet[*];
        part obstacle: Obstacle[*];
        part benneDechets: BenneDechets;
        part solIndustriel;
        part zoneInaccessible;
        part pointEau;

        flow parametre from responsableProduction to robot;
        flow entretient from responsableMaintenance to robot;
        flow cohabite from operateurUsager to robot;
        flow alerte from robot to reseauAlerte;
        flow alimente from reseauElectrique to stationRecharge;
        flow recharge from stationRecharge to robot;
        flow detecte from dechet to robot;
        flow detecte from obstacle to robot;
        flow vide from robot to benneDechets;
        flow nettoie from robot to solIndustriel;
        flow nettoie from robot to zoneInaccessible;
        flow approvisionne from pointEau to robot;
        connect robot to stationRecharge;
    }
    package requirements {
        /* exigences extraites des cas d'utilisation */
        requirement reconnaissanceDechets specializes fonctions {
            doc /* le robot doit pouvoir reconnaitre les dechets et choisir le mode de nettoyage adapte */
        }

        requirement signalementDechetInhabituel specializes fonctions {
            doc /* le robot doit signaler au responsable production tout dechet inhabituel */
        }

        requirement detectionObstaclesUsagers specializes fonctions {
            doc /* le robot doit detecter les obstacles et les usagers et ralentir, contourner ou s'arreter */
        }

        requirement nettoyageZoneInaccessible specializes fonctions {
            doc /* le robot doit pouvoir nettoyer une zone inaccessible en deployant puis recuperant un satellite */
        }

        requirement alarmeIntervention specializes fonctions {
            doc /* le robot doit declencher une alarme et localiser l'incident pour permettre une intervention au sol */
        }

        /* exigences extraites de la description du produit */
        requirement autonomie specializes contraintes {
            doc /* le robot doit fonctionner au moins 4 h entre deux recharges */
        }

        requirement vitesseProximite specializes contraintes {
            doc /* a proximite d'une personne, la vitesse du robot doit etre inferieure a 0,3 m/s */
        }

        requirement arretUrgence specializes contraintes {
            doc /* le robot doit disposer d'un arret d'urgence accessible et visible */
        }

        requirement signalisationPresence specializes contraintes {
            doc /* le robot doit signaler sa presence par un signal lumineux et sonore */
        }

        requirement protectionEnvironnement specializes contraintes {
            doc /* le robot doit resister a la poussiere et aux projections d'eau (IP54 minimum) */
        }

        requirement maintenabilite specializes contraintes {
            doc /* les consommables (brosses, filtres, reservoirs) doivent etre accessibles sans outillage specifique */
        }

        /* exigences extraites des interactions avec les elements de contexte */
        requirement communicationReseauAlerte specializes interactionsMaterielles {
            doc /* le robot doit communiquer sans fil avec le reseau d'alerte du site */
        }

        requirement rechargeAutonome specializes interactionsMaterielles {
            doc /* le robot doit rejoindre seul sa station de recharge */
        }

        requirement compatibiliteElectrique specializes interactionsMaterielles {
            doc /* la station de recharge doit etre compatible avec le reseau electrique du site */
        }

        requirement approvisionnementEau specializes interactionsMaterielles {
            doc /* le robot doit pouvoir etre rempli en eau a partir d'un point d'eau du site */
        }

        requirement vidageDechets specializes interactionsMaterielles {
            doc /* le robot doit pouvoir vider ses dechets dans une benne */
        }

        /* exigences creees pour regrouper l'ensemble de maniere hierarchique */
        requirement contraintes specializes specificationsASPWash {
            doc /* le systeme doit respecter les contraintes ci-dessous */
        }

        requirement fonctions specializes specificationsASPWash {
            doc /* le systeme doit comprendre les fonctions listees ci-dessous */
        }

        requirement interactionsMaterielles specializes specificationsASPWash {
            doc /* le systeme doit pouvoir disposer des interactions materielles listees */
        }

        requirement specificationsASPWash {
            doc /* le systeme repond aux categories d'exigences listees ci-dessous */
        }

            package fluxActions {
        private import ScalarValues::Boolean;

        action def DetecterObstaclesUsagers {
            attribute contactImminent: Boolean;

            first start;
            then action detecter;
            then action classifier;
            then action ralentir;
            then decide;
                if contactImminent then arreter;
                else contourner;

            action arreter;
            then done;

            action contourner;
            then done;
        }
    }

    package sequences {
        private import aspwash::parts::*;

        part sequenceDetectionObstacle {
            part usager: OperateurUsager {
                event occurrence presenceSurTrajectoire;
                then event occurrence recoitAvertissement;
                then event occurrence liberePassage;
            }
            part robot: RobotNettoyage {
                event occurrence detectePresence;
                then event occurrence emetAvertissement;
                then event occurrence emetAlerte;
                then event occurrence recoitPassageLibre;
            }
            part reseauAlerte: ReseauAlerteSite {
                event occurrence recoitAlerte;
            }

            message presence from usager.presenceSurTrajectoire to robot.detectePresence;
            message avertissement from robot.emetAvertissement to usager.recoitAvertissement;
            message alerte from robot.emetAlerte to reseauAlerte.recoitAlerte;
            message passageLibre from usager.liberePassage to robot.recoitPassageLibre;
        }
    }
    }
}


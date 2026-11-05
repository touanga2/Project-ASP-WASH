package aspWash {

    private import ScalarValues::Boolean;

    package parts {
        part def ResponsableProduction;
        part def OperateurUsager;
        part def ResponsableMaintenance;
        part def ReseauAlerte;

        part def AspWashRA1;

        part def Capteur;
        part def Controleur;
        part def Motorisation;
        part def ModuleNettoyage;
        part def ModuleCommunication;
        part def Signalisation;
        part def BoutonArret;
        part def Batterie;
        part def ReservoirEau;
        part def BacDechets;
        part def Chassis;
        part def MiniRobot;

        part def StationRecharge;
        part def Dechet;
        part def Obstacle;
        part def BenneDechets;
    }

    private import aspWash::parts::*;

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
    }

    action reconnaitreDechets {
        attribute finMission : Boolean;
        attribute dechetDetecte : Boolean;
        attribute dechetReconnu : Boolean;

        first start;
        then merge boucle;
        then action scannerSol;
        then decide detection;
            if finMission then done;
            if dechetDetecte then analyserDechet;
            else boucle;

        action analyserDechet;
        then decide tri;
            if dechetReconnu then nettoyerDechet;
            else signalerDechetInhabituel;

        action nettoyerDechet;
        then boucle;

        action signalerDechetInhabituel;
        then boucle;
    }

    part scenarioDechetReconnu {
        part capteur;
        part controleur;
        part moduleNettoyage;

        message donneesSol from capteur to controleur;
        message ordreNettoyage from controleur to moduleNettoyage;
        message nettoyageTermine from moduleNettoyage to controleur;
    }

    part scenarioDechetInhabituel {
        part capteur;
        part controleur;
        part operateur;

        message donneesSol from capteur to controleur;
        message alerteInhabituel from controleur to operateur;
    }

    action vueAction {
        attribute zoneInaccessible : Boolean;

        first start;
        then action detecterZone;
        then decide decisionZone;
            if zoneInaccessible then DeployerRobot;
            else NettoyerZone;

        action DeployerRobot;
        then action RetourBase;
        then done;

        action NettoyerZone;
        then done;
    }

    part sequence {
        part RobotAspirateur;
        part ZoneAnettoyer;
        part miniRobot;
        part BaseRobotAspirateur;

        message detecterZone from RobotAspirateur to ZoneAnettoyer;
        message verifierAccessibilite from RobotAspirateur to ZoneAnettoyer;
        message deployerRobot from RobotAspirateur to miniRobot;
        message nettoyerZone from miniRobot to ZoneAnettoyer;
        message retourBase from miniRobot to BaseRobotAspirateur;
    }

    action detecterObstacles {
        attribute finMission : Boolean;
        attribute obstacleDetecte : Boolean;
        attribute contactImminent : Boolean;
        attribute passageBloque : Boolean;

        first start;
        then merge boucle;
        then action scannerTrajectoire;
        then decide detection;
            if finMission then done;
            if obstacleDetecte then classifierObstacle;
            else boucle;

        action classifierObstacle;
        then action ralentir;
        then decide risque;
            if contactImminent then arreter;
            if passageBloque then recalculerItineraire;
            else contourner;

        action arreter;
        then boucle;

        action contourner;
        then boucle;

        action recalculerItineraire;
        then boucle;
    }

    part scenarioObstacleArret {
        part capteur;
        part controleur;
        part motorisation;
        part operateur;

        message donneesTrajectoire from capteur to controleur;
        message ordreRalentir from controleur to motorisation;
        message avertissementLocal from controleur to operateur;
        message ordreArret from controleur to motorisation;
    }

    part scenarioObstacleContourne {
        part capteur;
        part controleur;
        part motorisation;

        message donneesTrajectoire from capteur to controleur;
        message ordreRalentir from controleur to motorisation;
        message ordreContournement from controleur to motorisation;
    }

    action alarmeInterventionSol {
        attribute finMission : Boolean;
        attribute incidentDetecte : Boolean;

        first start;
        then merge merge0;
        then action surveiller;
        then decide decide0;
            if finMission then done;
            if incidentDetecte then declencherAlarme;

        action declencherAlarme;
        then action localiserIncident;
        then action attendreIntervention;
        then merge0;
    }

    part def SequenceAlarmeIntervention {
        part robot : AspWashRA1 {
            event occurrence envoiAlarme;
            event occurrence envoiPosition;
            event occurrence finIntervention;
        }

        part reseauAlerte : ReseauAlerte {
            event occurrence receptionAlarme;
            event occurrence receptionPosition;
            event occurrence envoiOrdre;
        }

        part responsableMaintenance : ResponsableMaintenance {
            event occurrence receptionOrdre;
            event occurrence intervention;
        }

        message declencherAlarme from robot.envoiAlarme to reseauAlerte.receptionAlarme;
        message localiserIncident from robot.envoiPosition to reseauAlerte.receptionPosition;
        message demanderIntervention from reseauAlerte.envoiOrdre to responsableMaintenance.receptionOrdre;
        message intervenirAuSol from responsableMaintenance.intervention to robot.finIntervention;
    }

    part def Architecture {
        part robot: AspWashRA1 {
            part capteur: Capteur;
            part controleur: Controleur;
            part motorisation: Motorisation;
            part moduleNettoyage: ModuleNettoyage;
            part moduleCommunication: ModuleCommunication;
            part signalisation: Signalisation;
            part boutonArret: BoutonArret;
            part batterie: Batterie;
            part reservoirEau: ReservoirEau;
            part bacDechets: BacDechets;
            part chassis: Chassis;
            part miniRobot: MiniRobot;

            connect capteur to controleur;
            connect controleur to motorisation;
            connect controleur to moduleNettoyage;
            connect controleur to moduleCommunication;
            connect controleur to signalisation;
            connect controleur to boutonArret;
            connect controleur to miniRobot;
            connect batterie to controleur;
            connect batterie to motorisation;
            connect moduleNettoyage to reservoirEau;
            connect moduleNettoyage to bacDechets;
            connect miniRobot to bacDechets;
        }

        part reseauAlerte: ReseauAlerte;
        part stationRecharge: StationRecharge;
        part benneDechets: BenneDechets;
        part pointEau;

        connect robot.moduleCommunication to reseauAlerte;
        connect robot.batterie to stationRecharge;
        connect robot.bacDechets to benneDechets;
        connect robot.reservoirEau to pointEau;
    }

    part archi: Architecture;

    allocate reconnaitreDechets.scannerSol to archi.robot.capteur;
    allocate reconnaitreDechets.analyserDechet to archi.robot.controleur;
    allocate reconnaitreDechets.nettoyerDechet to archi.robot.moduleNettoyage;
    allocate reconnaitreDechets.signalerDechetInhabituel to archi.robot.moduleCommunication;

    allocate vueAction.detecterZone to archi.robot.capteur;
    allocate vueAction.DeployerRobot to archi.robot.miniRobot;
    allocate vueAction.NettoyerZone to archi.robot.miniRobot;
    allocate vueAction.RetourBase to archi.robot.miniRobot;

    allocate detecterObstacles.scannerTrajectoire to archi.robot.capteur;
    allocate detecterObstacles.classifierObstacle to archi.robot.controleur;
    allocate detecterObstacles.ralentir to archi.robot.motorisation;
    allocate detecterObstacles.arreter to archi.robot.motorisation;
    allocate detecterObstacles.contourner to archi.robot.motorisation;
    allocate detecterObstacles.recalculerItineraire to archi.robot.controleur;

    allocate alarmeInterventionSol.surveiller to archi.robot.capteur;
    allocate alarmeInterventionSol.declencherAlarme to archi.robot.signalisation;
    allocate alarmeInterventionSol.localiserIncident to archi.robot.controleur;
    allocate alarmeInterventionSol.attendreIntervention to archi.robot.controleur;

    private import requirements::*;

    satisfy reconnaissanceDechets by archi.robot.capteur;
    satisfy reconnaissanceDechets by archi.robot.controleur;
    satisfy reconnaissanceDechets by archi.robot.moduleNettoyage;
    satisfy signalementDechetInhabituel by archi.robot.controleur;
    satisfy signalementDechetInhabituel by archi.robot.moduleCommunication;
    satisfy detectionObstaclesUsagers by archi.robot.capteur;
    satisfy detectionObstaclesUsagers by archi.robot.controleur;
    satisfy detectionObstaclesUsagers by archi.robot.motorisation;
    satisfy nettoyageZoneInaccessible by archi.robot.miniRobot;
    satisfy alarmeIntervention by archi.robot.signalisation;
    satisfy alarmeIntervention by archi.robot.moduleCommunication;
    satisfy alarmeIntervention by archi.robot.controleur;

    satisfy autonomie by archi.robot.batterie;
    satisfy vitesseProximite by archi.robot.motorisation;
    satisfy vitesseProximite by archi.robot.controleur;
    satisfy arretUrgence by archi.robot.boutonArret;
    satisfy signalisationPresence by archi.robot.signalisation;
    satisfy protectionEnvironnement by archi.robot.chassis;
    satisfy maintenabilite by archi.robot.moduleNettoyage;

    satisfy communicationReseauAlerte by archi.robot.moduleCommunication;
    satisfy rechargeAutonome by archi.robot.controleur;
    satisfy compatibiliteElectrique by archi.stationRecharge;
    satisfy approvisionnementEau by archi.robot.reservoirEau;
    satisfy vidageDechets by archi.robot.bacDechets;

    verification def verifFonctions {
        doc /* essais sur site avec dechets, obstacles, alarme et zone inaccessible */
        objective {
            verify reconnaissanceDechets;
            verify signalementDechetInhabituel;
            verify detectionObstaclesUsagers;
            verify nettoyageZoneInaccessible;
            verify alarmeIntervention;
        }
    }

    verification def verifContraintes {
        doc /* mesure de vitesse, essai arret d'urgence, essai autonomie, test IP54 */
        objective {
            verify autonomie;
            verify vitesseProximite;
            verify arretUrgence;
            verify signalisationPresence;
            verify protectionEnvironnement;
            verify maintenabilite;
        }
    }

    verification def verifInteractions {
        doc /* test liaison reseau, recharge, remplissage en eau et vidage */
        objective {
            verify communicationReseauAlerte;
            verify rechargeAutonome;
            verify compatibiliteElectrique;
            verify approvisionnementEau;
            verify vidageDechets;
        }
    }
}
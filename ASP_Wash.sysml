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
        actor operateurUsager : OperateurUsager[*];
        actor responsableMaintenance : ResponsableMaintenance;
        actor reseauAlerte : ReseauAlerte;

        /* cas d'utilisation secondaires */
        use case choisirModeNettoyage;
        use case signalerDechetInhabituel;
        use case ralentirContournerArreter;
        use case deployerRecupererSatellite;
        use case localiserIncident;

        /* cas d'utilisation principaux */
        use case reconnaitreDechets {
            subject robot : AspWashRA1;
            ref actor responsableProduction;
            include choisirModeNettoyage;
            include signalerDechetInhabituel;
        }

        use case detecterObstaclesUsagers {
            subject robot : AspWashRA1;
            ref actor operateurUsager;
            include ralentirContournerArreter;
        }

        use case nettoyerZoneInaccessible {
            subject robot : AspWashRA1;
            ref actor responsableProduction;
            include deployerRecupererSatellite;
        }

        use case alarmeInterventionSol {
            subject robot : AspWashRA1;
            ref actor responsableMaintenance;
            ref actor reseauAlerte;
            include localiserIncident;
        }
    }
}
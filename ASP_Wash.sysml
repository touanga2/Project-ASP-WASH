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
}
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

}

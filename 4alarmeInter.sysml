package aspWash {
    private import ScalarValues::Boolean;

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
}
package aspWash {
    package parts {
        part def AspWashRA1;
        part def ReseauAlerte;
        part def ResponsableMaintenance;
    }

    private import aspWash::parts::*;

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
}
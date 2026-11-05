package aspWash {
    private import ScalarValues::Boolean;

    action detecterObstacles {
        attribute finMission : Boolean;
        attribute obstacleDetecte : Boolean;
        attribute contactImminent : Boolean;
        attribute passageBloque : Boolean;

        action scannerTrajectoire;
        action classifierObstacle;
        action ralentir;
        action arreter;
        action contourner;
        action recalculerItineraire;

        first start;
        then merge boucle;
        then scannerTrajectoire;
        then decide detection;
            if finMission then done;
            if obstacleDetecte then classifierObstacle;
            else boucle;

        first classifierObstacle then ralentir;

        first ralentir;
        then decide risque;
            if contactImminent then arreter;
            if passageBloque then recalculerItineraire;
            else contourner;

        first arreter then boucle;
        first contourner then boucle;
        first recalculerItineraire then boucle;
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
}


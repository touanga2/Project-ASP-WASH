package aspWash {
    private import ScalarValues::Boolean;

    action reconnaitreDechets {
        attribute finMission : Boolean;
        attribute dechetDetecte : Boolean;
        attribute dechetReconnu : Boolean;

        action scannerSol;
        action analyserDechet;
        action nettoyerDechet;
        action signalerDechetInhabituel;

        first start;
        then merge boucle;
        then scannerSol;
        then decide detection;
            if finMission then done;
            if dechetDetecte then analyserDechet;
            else boucle;

        first analyserDechet;
        then decide tri;
            if dechetReconnu then nettoyerDechet;
            else signalerDechetInhabituel;

        first nettoyerDechet then boucle;
        first signalerDechetInhabituel then boucle;
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
}

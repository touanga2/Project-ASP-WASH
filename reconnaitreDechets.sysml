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
}
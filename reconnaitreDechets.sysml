package aspWash {
    private import ScalarValues::Boolean;

    action reconnaitreDechets {
        attribute nettoyageLance : Boolean;
        attribute finMission : Boolean;
        attribute dechetDetecte : Boolean;
        attribute dechetReconnu : Boolean;
        attribute dechetInhabituel : Boolean;
        action scannerSol;
        action analyserDechet;
        action choisirModeNettoyage;
        action nettoyerDechet;
        action signalerDechetInhabituel;
        merge merge0;

        first start;
        succession start if nettoyageLance then merge0;
        then scannerSol;
        then decide decide0;
            if finMission then done;
            if dechetDetecte then analyserDechet;
            else merge0;
        succession analyserDechet then decide decide1;
            if dechetReconnu then choisirModeNettoyage;
            if dechetInhabituel then signalerDechetInhabituel;
        succession choisirModeNettoyage then nettoyerDechet;
        then merge0;
        succession signalerDechetInhabituel then merge0;
    }
}
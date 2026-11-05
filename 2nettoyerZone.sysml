
action vueAction {
    action detecterZone;
    action deployerRobot;
    action nettoyerZone;
    action retourBase;

    first detecterZone;
    then deployerRobot;
    then nettoyerZone;
    then merge signalerProbleme?;
    then retourBase
    then done;
}




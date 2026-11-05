
action vueAction {
    action detecterZone;
    action deployerRobot;
    action nettoyerZone;
    action signalerProbleme;
    action retourBase;

    first detecterZone;
    then deployerRobot;
    then nettoyerZone;

        if problemeVraie then signalerProbleme ;
        if problemeFaux then retourBase;
    then done;
}




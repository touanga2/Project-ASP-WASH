action vueAction {

    action detecterZone;
    action DeployerRobot;
    action NettoyerZone;
    action RetourBase;

    decide decisionZone;
    

    first start;
    then detecterZone;
    then decisionZone;

    if zoneInaccessible then DeployerRobot;
    if not zoneInaccessible then NettoyerZone;

    succession DeployerRobot then RetourBase;
    succession NettoyerZone then done;
    succession RetourBase then done;
    
}

            




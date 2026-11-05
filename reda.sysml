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


part sequence {

    part RobotAspirateur;
    part ZoneAnettoyer;
    part miniRobot;
    part BaseRobotAspirateur

    message detecterZone from RobotAspirateur to ZoneAnettoyer;

    message verifierAccessibilite from RobotAspirateur to ZoneAnettoyer;

    message deployerRobot from RobotAspirateur to miniRobot;

    message nettoyerZone from miniRobot to ZoneAnettoyer;

    message retourBase from miniRobot to BaseRobotAspirateur;
}

            




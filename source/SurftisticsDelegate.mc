import Toybox.Lang;
import Toybox.WatchUi;

class SurftisticsDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKeyPressed(keyEvent) as Boolean {
        System.println(keyEvent.getType());
        System.println(keyEvent.getKey());
        WatchUi.pushView(new SurftisticsMonitoringView(), new SurftisticsMonitoringDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}

class SurftisticsMonitoringDelegate extends WatchUi.BehaviorDelegate {

    private var _surftistics_sensor;

    function initialize() {
        BehaviorDelegate.initialize();
        System.println("inited");
        _surftistics_sensor = new SurftisticsSensor();
        _surftistics_sensor.monitor();
    }

    function onKeyPressed(keyEvent) as Boolean {
        System.println(keyEvent.getType());
        System.println(keyEvent.getKey());
        _surftistics_sensor.stop();
        WatchUi.pushView(new Rez.Menus.MainMenu(),
                        new SurftisticsMenuDelegate(_surftistics_sensor.record_names_array,
                        RECORD_NAME_PREFIX), WatchUi.SLIDE_UP);
        return true;
    }

}

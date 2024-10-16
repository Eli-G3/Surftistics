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
    private var _is_sensor_initialized = false;

    function initialize() {
        BehaviorDelegate.initialize();
        System.println("inited");
        if (!_is_sensor_initialized) {
            _surftistics_sensor = new SurftisticsSensor();
            _is_sensor_initialized = true;
        }
        _surftistics_sensor.monitor();
    }

    function onKeyPressed(keyEvent) as Boolean {
        System.println(keyEvent.getType());
        System.println(keyEvent.getKey());
        WatchUi.pushView(new Rez.Menus.MainMenu(), new SurftisticsMenuDelegate(), WatchUi.SLIDE_UP);
        _surftistics_sensor.stop();
        return true;
    }

}

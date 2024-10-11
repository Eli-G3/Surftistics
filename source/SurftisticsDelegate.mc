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

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKeyPressed(keyEvent) as Boolean {
        System.println(keyEvent.getType());
        System.println(keyEvent.getKey());
        WatchUi.pushView(new Rez.Menus.MainMenu(), new SurftisticsMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}

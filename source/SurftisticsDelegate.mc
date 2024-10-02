import Toybox.Lang;
import Toybox.WatchUi;

class SurftisticsDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new SurftisticsMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}
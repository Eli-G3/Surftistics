import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SurftisticsMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :caught) {
            System.println("caught");
            var a = new SurftisticsSensorPrinter();
            System.println("A: " + a.toString());
        } else if (item == :missed) {
            System.println("missed");
        } else if (item == :paddling) {
            System.println("paddiling");
        } else {
            System.error("Invalid Selection!");
        }
        WatchUi.pushView(new SurftisticsView(), new SurftisticsDelegate(), WatchUi.SLIDE_BLINK);
    }

}
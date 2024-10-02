import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SurftisticsMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :item_1) {
            System.println("item 1");
            var a = new SurftisticsSensorPrinter();
            System.println("A: " + a.toString());
        } else if (item == :item_2) {
            System.println("item 2");
        }
    }

}
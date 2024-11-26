import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SurftisticsMenuDelegate extends WatchUi.MenuInputDelegate {
    private var _monitor_record_names;
    private var _monitor_record_name_prefix;

    function initialize(record_names as Array<String>, record_name_prefix as String) {
        MenuInputDelegate.initialize();
        self._monitor_record_names = record_names;
        self._monitor_record_name_prefix = record_name_prefix;
        System.println("Names: " + self._monitor_record_names.toString());
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == null) {
            System.error("Invalid Selection!");
        }
        System.println(item.toString());
        // if (item == :missed);
        self.rename_records(item.toString());
        WatchUi.pushView(new SurftisticsView(), new SurftisticsDelegate(), WatchUi.SLIDE_BLINK);
    }

    function rename_records(record_description as String) as Void {
        var i = 0;
        for (i = 0; i < self._monitor_record_names.size(); ++i) {
            self.rename_record(self._monitor_record_names[i], record_description);
        }
    }

    function rename_record(old_record_name as String, new_record_name as String) as Void {
        var record = Application.Storage.getValue(old_record_name);
        if (record == null) {
            System.println("Record is null. Skipping...");
            return;
        }
        Application.Storage.deleteValue(old_record_name);
        var new_keyname = new_record_name + old_record_name.substring(self._monitor_record_name_prefix.length() - 1, null);
        System.println("New key: " + new_keyname);
        Application.Storage.setValue(new_keyname, record);
    }


}
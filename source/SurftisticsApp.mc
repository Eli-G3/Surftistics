import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SurftisticsApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        if (state == null)
        {
            System.println("State is null");
        }
        else 
        {
            System.println("Launched from activity");
            System.println("State is: " + state.get(:launchedFromGlance));
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new SurftisticsView(), new SurftisticsDelegate() ];
    }

}

function getApp() as SurftisticsApp {
    return Application.getApp() as SurftisticsApp;
}
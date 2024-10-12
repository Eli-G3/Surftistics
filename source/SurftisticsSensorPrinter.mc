import Toybox.Sensor;
import Toybox.Timer;


class SurftisticsSensor {

    private var _sampling_timer;

    function initialize() {
        Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE] );
        // Sensor.enableSensorEvents( method( :onSensor ) );
        _sampling_timer = new Timer.Timer();
    }

    function onSensor() as Void {
        var sensorInfo = Sensor.getInfo();
        System.println( "Heart Rate: " + sensorInfo.heartRate );
        System.println( "Accel : " + sensorInfo.accel);
        System.println( "Altitude: " + sensorInfo.altitude);
        System.println( "cadence: " + sensorInfo.cadence);
        System.println( "heading: " + sensorInfo.heading);
        System.println( "mag: " + sensorInfo.mag);
        System.println( "oxy sat: " + sensorInfo.oxygenSaturation);
        System.println( "power: " + sensorInfo.power);
        System.println( "pressure: " + sensorInfo.pressure);
        System.println( "speed: " + sensorInfo.speed);
        System.println( "temp: " + sensorInfo.temperature);
    }

    function monitor() as Void {
        _sampling_timer.start(method(:onSensor), 500, true); // A half second timer
    }

    function stop() as Void {
        _sampling_timer.stop();
    }

}

import Toybox.Sensor;


class SurftisticsSensorPrinter {
    function initialize() {
        Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE] );
        Sensor.enableSensorEvents( method( :onSensor ) );
    }

    function onSensor(sensorInfo as Sensor.Info) as Void {
        System.println( "Heart Rate: " + sensorInfo.heartRate );
    }
}

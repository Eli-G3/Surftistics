import Toybox.Sensor;
import Toybox.Timer;
import Toybox.Lang;


    module RecordIndexes {
        enum {
            HEART_RATE = 0,
            ACCEL_X = 1,
            ACCEL_Y = 2,
            ACCEL_Z = 3,
            ALTITUDE = 4,
            HEADING = 5,
            MAG_X = 6,
            MAG_Y = 7,
            MAG_Z = 8,
            OXY_SAT = 9,
            PRESSURE = 10,
            SPEED = 11,
            TEMP = 12,
            NUM_OF_INDEXES = 13,
        }
    }

    const RECORDS_COUNT = 125;
    const RECORDS_SIZE = RecordIndexes.NUM_OF_INDEXES * RECORDS_COUNT;

class SurftisticsSensor {
    private var _sampling_timer;
    private var _records_array = new Array<Float>[RECORDS_SIZE];
    private var _current_idx = 0;
    private var _sensor_calls = 0;

    function initialize() {
        Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE] );
        // Sensor.enableSensorEvents( method( :onSensor ) );
        self._sampling_timer = new Timer.Timer();
    }

    function onSensor() as Void {
        self._sensor_calls++;

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
        self._add_records(sensorInfo);

        if (self._sensor_calls >= RECORDS_COUNT) {
            self._store_records();
            self._sensor_calls = 0;
        }
    }

    function _store_records() as Void {
        var key_name = "counter_" + self._sensor_calls.toString();
        Application.Storage.setValue(key_name, self._records_array);
        self._current_idx = 0;
        // Add array deleting functionality
    }

    function _insert_record(record_idx as Number, record_value as Float) as Void {
        if (record_idx >= RecordIndexes.NUM_OF_INDEXES) {
            // Todo: return error value
            System.println("too big");
            System.println("idx " + record_idx);
            return;
        }
        if (!(record_value instanceof Number) || !(record_value instanceof Float)) {
            // Todo: return error value
            System.println("record_value: " + record_value);
            return;
        }

        // Insert the value into the record
        self._records_array[self._current_idx + record_idx] = record_value;

        // Point to next record
        if (self._current_idx < RECORDS_COUNT) {
            self._current_idx += RecordIndexes.NUM_OF_INDEXES;
            System.println("Record index " + self._current_idx);
        } else {
            self._current_idx = 0;
            System.println("Record Array Cycled!");
        }
    }

    function _add_records(sensorInfo) as Void {
        if (sensorInfo == null || self._records_array == null) {
            // Todo: return error value
            System.println("Given Null");
            return;
        }
        self._insert_record(RecordIndexes.HEART_RATE, sensorInfo.heartRate);
        self._insert_record(RecordIndexes.ALTITUDE, sensorInfo.altitude);
        self._insert_record(RecordIndexes.HEADING, sensorInfo.heading);
        self._insert_record(RecordIndexes.OXY_SAT, sensorInfo.oxygenSaturation);
        self._insert_record(RecordIndexes.PRESSURE, sensorInfo.pressure);
        self._insert_record(RecordIndexes.SPEED, sensorInfo.speed);
        self._insert_record(RecordIndexes.TEMP, sensorInfo.temperature);
        if (sensorInfo.accel != null) {
            self._insert_record(RecordIndexes.ACCEL_X, sensorInfo.accel[0]);
            self._insert_record(RecordIndexes.ACCEL_Y, sensorInfo.accel[1]);
            self._insert_record(RecordIndexes.ACCEL_Z, sensorInfo.accel[2]);
        }
        if (sensorInfo.mag != null) {
            self._insert_record(RecordIndexes.MAG_X, sensorInfo.mag[0]);
            self._insert_record(RecordIndexes.MAG_Y, sensorInfo.mag[1]);
            self._insert_record(RecordIndexes.MAG_Z, sensorInfo.mag[2]);
        }
    }

    function monitor() as Void {
        self._sampling_timer.start(method(:onSensor), 500, true); // A half second timer
    }

    function stop() as Void {
        self._sampling_timer.stop();
        self._store_records();
    }

}

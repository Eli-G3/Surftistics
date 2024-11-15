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
    private var _record_insertions = 0;
    private var _needs_storing = false;

    function initialize() {
        Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE] );
        // Sensor.enableSensorEvents( method( :onSensor ) );
        self._sampling_timer = new Timer.Timer();
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
        try {
            self._add_records(sensorInfo);
        }
        catch (e instanceof Lang.Exception) {
            System.println(e.getErrorMessage());
            // Todo: Maybe after error save what you have if there is what to save.
            return;
        }

        self._record_insertions++;
        self._needs_storing = true;
        if (self._record_insertions >= RECORDS_COUNT) {
            self._store_records();
            self._record_insertions = 0;
            self._needs_storing = false;
        }
    }

    function _store_records() as Void {
        // Todo: Add storage name changer to catagorize values into result (Caught, missed, padding, etc...)
        var key_name = "counter_" + self._record_insertions.toString();
        Application.Storage.setValue(key_name, self._records_array);
        self._current_idx = 0;
        // Re-initialize the array with null values. The old array will be freed because it's ref-count drops to 0.
        self._records_array = new Array<Float>[RECORDS_SIZE];
    }

    function _insert_record(record_idx as Number, record_value as Float) as Void {
        if (record_idx >= RecordIndexes.NUM_OF_INDEXES) {
            throw new Lang.ValueOutOfBoundsException("Index should be no more than " + RecordIndexes.NUM_OF_INDEXES + " but was " + record_idx);
        }
        if (!(record_value instanceof Number) && !(record_value instanceof Float)) {
            throw new Lang.InvalidValueException(record_value + " should be float or int");
        }
        // Insert the value into the record
        self._records_array[self._current_idx + record_idx] = record_value;
    }

    function _add_records(sensorInfo) as Void {
        if (sensorInfo == null || self._records_array == null) {
            throw new Lang.InvalidValueException("Bad params: SensorInfo: " + sensorInfo + ", Records: " + self._records_array);
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

        // Point to next record
        if (self._current_idx < RECORDS_COUNT) {
            self._current_idx += RecordIndexes.NUM_OF_INDEXES;
            System.println("Record index " + self._current_idx);
        } else {
            self._current_idx = 0;
            System.println("Record Array Cycled!");
        }
    }

    function monitor() as Void {
        self._sampling_timer.start(method(:onSensor), 500, true); // A half second timer
    }

    function stop() as Void {
        self._sampling_timer.stop();
        System.println("needs storing: " + self._needs_storing);
        if (self._needs_storing) {
            self._store_records();
            self._needs_storing = false;
        }
    }

}

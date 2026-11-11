-- Metadata framework for the ridership lakehouse (admin_ops schema).
-- Control table drives every Bronze, Silver and Gold job; the other tables hold run logs and DQ results.
-- Statements are in the order they were applied. Fictionalized: no environment names or IDs.

-- ======================================================================
-- Control table
-- ======================================================================
CREATE SCHEMA IF NOT EXISTS admin_ops;
CREATE TABLE IF NOT EXISTS admin_ops.admin_load_control

(

    ROW_ID                  INT,

    TRANSFER_TYPE           STRING,

    SOURCE_SYSTEM           STRING,
 
    SOURCE_SCHEMA           STRING,

    SOURCE_TABLE_NAME       STRING,

    SOURCE_FILE_NAME        STRING,
 
    DESTINATION_SCHEMA      STRING,

    DESTINATION_TABLE_NAME  STRING,
 
    LOAD_TYPE               STRING,

    PRIMARY_KEY             STRING,

    INCREMENTAL_COLUMN      STRING,
 
    EXECUTION_ORDER         INT,

    JOB_DEPENDENCIES        STRING,
 
    RUN_ACTIVE_FLAG         INT,
 
    PARAM_1                 STRING,

    PARAM_2                 STRING,
 
    INSERT_TS               TIMESTAMP,

    UPDATE_TS               TIMESTAMP

);

-- ======================================================================
-- Archive columns
-- ======================================================================
ALTER TABLE admin_ops.admin_load_control
ADD COLUMNS
(
    ARCHIVE_CONTAINER STRING,
    ARCHIVE_FOLDER    STRING
);

-- ======================================================================
-- Logging table
-- ======================================================================
CREATE TABLE IF NOT EXISTS admin_ops.admin_logging_data
(
    ROW_ID              BIGINT,
    EXECUTION_ID        STRING,
    JOB_NAME            STRING,
    JOB_START_TS        TIMESTAMP,
    JOB_END_TS          TIMESTAMP,
    DURATION_SEC        BIGINT,
    JOB_STATUS          STRING,
    INFORMATION         STRING,
    TOTAL_ROWS          BIGINT,
    ERROR_ID            STRING,
    ERROR_MESSAGE       STRING,
    SOURCE_TABLE        STRING,
    DESTINATION_TABLE   STRING,
    PULL_FROM_DATE      TIMESTAMP,
    PULL_TO_DATE        TIMESTAMP,
    PROCESSED_CONDITION STRING,
    FLAG                STRING,
    INSERT_TS           TIMESTAMP
)
USING DELTA;

-- ======================================================================
-- Processing log
-- ======================================================================
CREATE TABLE IF NOT EXISTS admin_ops.admin_processing_log
(
    ROW_ID              BIGINT,
    EXECUTION_ID        STRING,
    JOB_NAME            STRING,
    JOB_START_TS        TIMESTAMP,
    JOB_END_TS          TIMESTAMP,
    DURATION_SEC        BIGINT,
    JOB_STATUS          STRING,
    INFORMATION         STRING,
    TOTAL_ROWS          BIGINT,
    ERROR_ID            STRING,
    ERROR_MESSAGE       STRING,
    SOURCE_TABLE        STRING,
    DESTINATION_TABLE   STRING,
    PULL_FROM_DATE      TIMESTAMP,
    PULL_TO_DATE        TIMESTAMP,
    PROCESSED_CONDITION STRING,
    FLAG                STRING,
    INSERT_TS           TIMESTAMP
)
USING DELTA;

-- ======================================================================
-- Data quality results
-- ======================================================================
CREATE TABLE IF NOT EXISTS admin_ops.admin_dq_results
(
    DQ_RESULT_ID        BIGINT,
    EXECUTION_ID        STRING,
    LAYER_NAME          STRING,
    TARGET_TABLE        STRING,
    SOURCE_TABLES       STRING,
    RULE_NAME           STRING,
    RULE_TYPE           STRING,
    RULE_DESCRIPTION    STRING,
    SEVERITY            STRING,
    RULE_STATUS         STRING,
    TOTAL_ROW_COUNT     BIGINT,
    FAILED_ROW_COUNT    BIGINT,
    FAILED_PCT          DOUBLE,
    SAMPLE_DETAILS      STRING,
    CHECK_TS            TIMESTAMP,
    INSERT_TS           TIMESTAMP
)
USING DELTA;

-- ======================================================================
-- Seed: file -> Bronze sources
-- ======================================================================
INSERT INTO admin_ops.admin_load_control
(
    ROW_ID,
    TRANSFER_TYPE,
    SOURCE_SYSTEM,
    SOURCE_SCHEMA,
    SOURCE_TABLE_NAME,
    SOURCE_FILE_NAME,
    DESTINATION_SCHEMA,
    DESTINATION_TABLE_NAME,
    LOAD_TYPE,
    PRIMARY_KEY,
    INCREMENTAL_COLUMN,
    EXECUTION_ORDER,
    JOB_DEPENDENCIES,
    RUN_ACTIVE_FLAG,
    PARAM_1,
    PARAM_2,
    INSERT_TS,
    UPDATE_TS
)
VALUES
 
-- 1. Schedule
(
    1,
    'FILE_TO_BRZ',
    'CSV_UPLOAD',
    NULL,
    'schedule',
    'Schedule.csv',
    'bronze',
    'bronze_schedule',
    'FULL',
    'SCHEDULE_ID',
    NULL,
    10,
    NULL,
    1,
    NULL,
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
),
 
-- 2. Route
(
    2,
    'FILE_TO_BRZ',
    'CSV_UPLOAD',
    NULL,
    'route',
    'Route.csv',
    'bronze',
    'bronze_route',
    'FULL',
    'ROUTE_ID',
    NULL,
    20,
    NULL,
    1,
    NULL,
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
),
 
-- 3. Stops
(
    3,
    'FILE_TO_BRZ',
    'CSV_UPLOAD',
    NULL,
    'stops',
    'Stops.csv',
    'bronze',
    'bronze_stop',
    'FULL',
    'STOP_ID',
    NULL,
    30,
    NULL,
    1,
    NULL,
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
),
 
-- 4. Media Type
(
    4,
    'FILE_TO_BRZ',
    'CSV_UPLOAD',
    NULL,
    'media_type',
    'Media_Type.csv',
    'bronze',
    'bronze_media_type',
    'FULL',
    'MEDIA_TYPE_ID',
    NULL,
    40,
    NULL,
    1,
    NULL,
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
),
 
-- 5. Direction
(
    5,
    'FILE_TO_BRZ',
    'CSV_UPLOAD',
    NULL,
    'direction',
    'Direction.csv',
    'bronze',
    'bronze_direction',
    'FULL',
    'DIRECTION_ID',
    NULL,
    50,
    NULL,
    1,
    NULL,
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
),
 
-- 6. Blocks
(
    6,
    'FILE_TO_BRZ',
    'CSV_UPLOAD',
    NULL,
    'blocks',
    'Blocks.csv',
    'bronze',
    'bronze_block',
    'FULL',
    'BLOCK_ID',
    NULL,
    60,
    'schedule',
    1,
    NULL,
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
),
 
-- 7. Trips
(
    7,
    'FILE_TO_BRZ',
    'CSV_UPLOAD',
    NULL,
    'trips',
    'Trips.csv',
    'bronze',
    'bronze_trip',
    'FULL',
    'TRIP_ID',
    NULL,
    70,
    'schedule',
    1,
    NULL,
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
),
 
-- 8. Scheduled Trip
(
    8,
    'FILE_TO_BRZ',
    'CSV_UPLOAD',
    NULL,
    'scheduled_trip',
    'Scheduled_Trip.csv',
    'bronze',
    'bronze_scheduled_trip',
    'FULL',
    'TRIP_ID,STOP_SEQUENCE',
    NULL,
    80,
    'route,stops,schedule',
    1,
    NULL,
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
),
 
-- 9. Stop Activity
(
    9,
    'FILE_TO_BRZ',
    'CSV_UPLOAD',
    NULL,
    'stop_activity',
    'Stop_Activity.csv',
    'bronze',
    'bronze_stop_activity',
    'INCREMENTAL',
    'STOP_ID,STOP_SEQ_ID,TRIP_ID,TRIP_DATE',
    'TRIP_DATE',
    90,
    'scheduled_trip',
    1,
    NULL,
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
),
 
-- 10. Vehicle API
(
    10,
    'API_TO_BRZ',
    'API',
    NULL,
    'vehicle',
    NULL,
    'bronze',
    'bronze_vehicle',
    'FULL',
    'VEHICLE_ID',
    NULL,
    100,
    NULL,
    1,
    NULL,
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
);

-- ======================================================================
-- Seed: landing folders
-- ======================================================================
UPDATE admin_ops.admin_load_control
SET
    PARAM_1 = 'landing',
    PARAM_2 =
        CASE LOWER(SOURCE_TABLE_NAME)
            WHEN 'schedule'       THEN 'files/schedule'
            WHEN 'route'          THEN 'files/route'
            WHEN 'stops'          THEN 'files/stops'
            WHEN 'media_type'     THEN 'files/media_type'
            WHEN 'direction'      THEN 'files/direction'
            WHEN 'blocks'         THEN 'files/blocks'
            WHEN 'trips'          THEN 'files/trips'
            WHEN 'scheduled_trip' THEN 'files/scheduled_trip'
            WHEN 'stop_activity'  THEN 'files/stop_activity'
            ELSE PARAM_2
        END,
    UPDATE_TS = CURRENT_TIMESTAMP()
WHERE TRANSFER_TYPE = 'FILE_TO_BRZ';

-- ======================================================================
-- Seed: Bronze -> Silver jobs
-- ======================================================================
INSERT INTO admin_ops.admin_load_control
(
    ROW_ID,
    TRANSFER_TYPE,
    SOURCE_SYSTEM,
    SOURCE_SCHEMA,
    SOURCE_TABLE_NAME,
    SOURCE_FILE_NAME,
    DESTINATION_SCHEMA,
    DESTINATION_TABLE_NAME,
    LOAD_TYPE,
    PRIMARY_KEY,
    INCREMENTAL_COLUMN,
    EXECUTION_ORDER,
    JOB_DEPENDENCIES,
    RUN_ACTIVE_FLAG,
    PARAM_1,
    PARAM_2,
    INSERT_TS,
    UPDATE_TS
)
VALUES
 
(
    11, 'BRZ_TO_SIL', 'TRANSIT',
    'bronze', 'BRONZE_SCHEDULE', NULL,
    'silver', 'SILVER_DIM_SCHEDULE',
    'MERGE', 'SCHEDULE_ID', NULL,
    110, NULL, 1,
    'load_dim_schedule', NULL,
    CURRENT_TIMESTAMP(), NULL
),
 
(
    12, 'BRZ_TO_SIL', 'TRANSIT',
    'bronze', 'BRONZE_STOP', NULL,
    'silver', 'SILVER_DIM_STOP',
    'MERGE', 'STOP_ID', NULL,
    120, NULL, 1,
    'load_dim_stop', NULL,
    CURRENT_TIMESTAMP(), NULL
),
 
(
    13, 'BRZ_TO_SIL', 'TRANSIT',
    'bronze', 'BRONZE_MEDIA_TYPE', NULL,
    'silver', 'SILVER_DIM_MEDIA_TYPE',
    'MERGE', 'MEDIA_TYPE_ID', NULL,
    130, NULL, 1,
    'load_dim_media_type', NULL,
    CURRENT_TIMESTAMP(), NULL
),
 
(
    14, 'BRZ_TO_SIL', 'TRANSIT',
    'bronze', 'BRONZE_DIRECTION', NULL,
    'silver', 'SILVER_DIM_DIRECTION',
    'MERGE', 'DIRECTION_ID', NULL,
    140, NULL, 1,
    'load_dim_direction', NULL,
    CURRENT_TIMESTAMP(), NULL
),
 
(
    15, 'BRZ_TO_SIL', 'TRANSIT',
    'bronze', 'BRONZE_BLOCK', NULL,
    'silver', 'SILVER_DIM_BLOCK',
    'MERGE', 'BLOCK_ID', NULL,
    150, NULL, 1,
    'load_dim_block', NULL,
    CURRENT_TIMESTAMP(), NULL
),
 
(
    16, 'BRZ_TO_SIL', 'TRANSIT',
    'bronze', 'BRONZE_VEHICLE', NULL,
    'silver', 'SILVER_DIM_VEHICLE',
    'MERGE', 'VEHICLE_ID', NULL,
    160, NULL, 1,
    'load_dim_vehicle', NULL,
    CURRENT_TIMESTAMP(), NULL
),
 
(
    17, 'BRZ_TO_SIL', 'TRANSIT',
    'bronze', 'BRONZE_STOP_ACTIVITY', NULL,
    'silver', 'SILVER_DIM_RIDERSHIP_VALIDATION',
    'MERGE', 'RIDERSHIP_VALIDATION_ID', NULL,
    170, NULL, 1,
    'load_dim_ridership_validation', NULL,
    CURRENT_TIMESTAMP(), NULL
),
 
(
    18, 'BRZ_TO_SIL', 'TRANSIT',
    'bronze',
    'BRONZE_ROUTE,BRONZE_SCHEDULED_TRIP',
    NULL,
    'silver', 'SILVER_DIM_ROUTE',
    'MERGE', 'ROUTE_SCHEDULE_ID', NULL,
    180, NULL, 1,
    'load_dim_route', NULL,
    CURRENT_TIMESTAMP(), NULL
),
 
(
    19, 'BRZ_TO_SIL', 'TRANSIT',
    'bronze',
    'BRONZE_TRIP,BRONZE_SCHEDULED_TRIP',
    NULL,
    'silver', 'SILVER_DIM_TRIP',
    'MERGE', 'TRIP_ID', NULL,
    190, NULL, 1,
    'load_dim_trip', NULL,
    CURRENT_TIMESTAMP(), NULL
),
 
(
    20, 'BRZ_TO_SIL', 'TRANSIT',
    'bronze', 'BRONZE_STOP_ACTIVITY', NULL,
    'silver', 'SILVER_DIM_DATE',
    'MERGE', 'SERVICE_DATE', NULL,
    200, NULL, 1,
    'load_dim_date', NULL,
    CURRENT_TIMESTAMP(), NULL
),
 
(
    21, 'BRZ_TO_SIL', 'TRANSIT',
    'bronze', 'BRONZE_STOP_ACTIVITY', NULL,
    'silver', 'SILVER_FACT_RIDERSHIP',
    'MERGE', 'FACT_RIDERSHIP_ID', NULL,
    210,
    'SILVER_DIM_SCHEDULE,SILVER_DIM_STOP,SILVER_DIM_MEDIA_TYPE,SILVER_DIM_DIRECTION,SILVER_DIM_BLOCK,SILVER_DIM_VEHICLE,SILVER_DIM_RIDERSHIP_VALIDATION,SILVER_DIM_ROUTE,SILVER_DIM_TRIP,SILVER_DIM_DATE',
    1,
    'load_fact_ridership', NULL,
    CURRENT_TIMESTAMP(), NULL
);

-- ======================================================================
-- Seed: Silver -> Gold jobs
-- ======================================================================
INSERT INTO admin_ops.admin_load_control
(
    ROW_ID,
    TRANSFER_TYPE,
    SOURCE_SYSTEM,
    SOURCE_SCHEMA,
    SOURCE_TABLE_NAME,
    SOURCE_FILE_NAME,
    DESTINATION_SCHEMA,
    DESTINATION_TABLE_NAME,
    LOAD_TYPE,
    PRIMARY_KEY,
    INCREMENTAL_COLUMN,
    EXECUTION_ORDER,
    JOB_DEPENDENCIES,
    RUN_ACTIVE_FLAG,
    PARAM_1,
    PARAM_2,
    INSERT_TS,
    UPDATE_TS
)
VALUES
 
(
    22,
    'SIL_TO_GOLD',
    'TRANSIT',
    'silver',
    'SILVER_FACT_RIDERSHIP',
    NULL,
    'gold',
    'VW_SCHEDULED_RIDERSHIP',
    'VIEW',
    NULL,
    NULL,
    310,
    'SILVER_FACT_RIDERSHIP',
    1,
    'create_vw_scheduled_ridership',
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
),
 
(
    23,
    'SIL_TO_GOLD',
    'TRANSIT',
    'silver',
    'SILVER_FACT_RIDERSHIP',
    NULL,
    'gold',
    'VW_RIDERSHIP_OVERALL',
    'VIEW',
    NULL,
    NULL,
    320,
    'SILVER_FACT_RIDERSHIP',
    1,
    'create_vw_ridership_overall',
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
),
 
(
    24,
    'SIL_TO_GOLD',
    'TRANSIT',
    'silver',
    'SILVER_FACT_RIDERSHIP',
    NULL,
    'gold',
    'VW_RIDERSHIP_DETAIL',
    'VIEW',
    NULL,
    NULL,
    330,
    'SILVER_FACT_RIDERSHIP',
    1,
    'create_vw_ridership_detail',
    NULL,
    CURRENT_TIMESTAMP(),
    NULL
);

-- ======================================================================
-- Gold job loaders
-- ======================================================================
UPDATE admin_ops.admin_load_control
SET
    DESTINATION_TABLE_NAME = 'GOLD_SCHEDULED_RIDERSHIP',
    LOAD_TYPE = 'TABLE',
    PARAM_1 = 'create_gold_scheduled_ridership',
    UPDATE_TS = CURRENT_TIMESTAMP()
WHERE ROW_ID = 22;
 
UPDATE admin_ops.admin_load_control
SET
    DESTINATION_TABLE_NAME = 'GOLD_RIDERSHIP_OVERALL',
    LOAD_TYPE = 'TABLE',
    PARAM_1 = 'create_gold_ridership_overall',
    UPDATE_TS = CURRENT_TIMESTAMP()
WHERE ROW_ID = 23;
 
UPDATE admin_ops.admin_load_control
SET
    DESTINATION_TABLE_NAME = 'GOLD_RIDERSHIP_DETAIL',
    LOAD_TYPE = 'TABLE',
    PARAM_1 = 'create_gold_ridership_detail',
    UPDATE_TS = CURRENT_TIMESTAMP()
WHERE ROW_ID = 24;

-- ======================================================================
-- Seed: archive folders
-- ======================================================================
UPDATE admin_ops.admin_load_control
SET
    ARCHIVE_CONTAINER = 'archive',
    ARCHIVE_FOLDER =
        CASE LOWER(SOURCE_TABLE_NAME)

            WHEN 'schedule'
                THEN 'files/schedule'

            WHEN 'route'
                THEN 'files/route'

            WHEN 'stops'
                THEN 'files/stops'

            WHEN 'media_type'
                THEN 'files/media_type'

            WHEN 'direction'
                THEN 'files/direction'

            WHEN 'blocks'
                THEN 'files/blocks'

            WHEN 'trips'
                THEN 'files/trips'

            WHEN 'scheduled_trip'
                THEN 'files/scheduled_trip'

            WHEN 'stop_activity'
                THEN 'files/stop_activity'

            ELSE NULL

        END,
    UPDATE_TS = CURRENT_TIMESTAMP()

WHERE TRANSFER_TYPE = 'FILE_TO_BRZ';

-- ======================================================================
-- Seed: additional jobs
-- ======================================================================
INSERT INTO admin_ops.admin_load_control
(
    ROW_ID,
    TRANSFER_TYPE,
    SOURCE_SYSTEM,
    SOURCE_SCHEMA,
    SOURCE_TABLE_NAME,
    SOURCE_FILE_NAME,
    DESTINATION_SCHEMA,
    DESTINATION_TABLE_NAME,
    LOAD_TYPE,
    PRIMARY_KEY,
    INCREMENTAL_COLUMN,
    EXECUTION_ORDER,
    JOB_DEPENDENCIES,
    RUN_ACTIVE_FLAG,
    PARAM_1,
    PARAM_2,
    INSERT_TS,
    UPDATE_TS,
    ARCHIVE_CONTAINER,
    ARCHIVE_FOLDER
)
VALUES
(
    25,
    'FILE_TO_BRZ',
    'DMA',
    NULL,
    'unscheduled_trip',
    'Unscheduled_Trips.xlsx',

    'bronze',
    'bronze_unscheduled_trip',

    'FULL',
    NULL,
    NULL,

    95,
    NULL,
    1,

    'dma',                       -- PARAM_1 = SOURCE CONTAINER
    'Unschedule_Trips_Current',  -- PARAM_2 = SOURCE FOLDER

    CURRENT_TIMESTAMP(),
    NULL,

    'archive',
    'files/unscheduled_trip'
);

-- ======================================================================
-- Gold: scheduled ridership as table
-- ======================================================================
UPDATE admin_ops.admin_load_control
SET
    DESTINATION_TABLE_NAME = 'VW_SCHEDULED_RIDERSHIP',
    LOAD_TYPE = 'VIEW',
    PARAM_1 = 'create_vw_scheduled_ridership',
    UPDATE_TS = CURRENT_TIMESTAMP()
WHERE TRANSFER_TYPE = 'SIL_TO_GOLD'
  AND DESTINATION_TABLE_NAME = 'GOLD_SCHEDULED_RIDERSHIP';

-- ======================================================================
-- Unscheduled trips source
-- ======================================================================
UPDATE admin_ops.admin_load_control
SET
    SOURCE_FILE_NAME = 'Unscheduled_Trips.xlsx',

    PARAM_1 = 'dma',
    PARAM_2 = 'Unschedule_Trips_Current',

    DESTINATION_SCHEMA = 'dma',
    DESTINATION_TABLE_NAME = 'unscheduled_trip',

    ARCHIVE_CONTAINER = 'archive',
    ARCHIVE_FOLDER = 'files/unscheduled_trip',

    RUN_ACTIVE_FLAG = 1,
    UPDATE_TS = CURRENT_TIMESTAMP()

WHERE LOWER(SOURCE_TABLE_NAME) = 'unscheduled_trip'
  AND TRANSFER_TYPE = 'FILE_TO_BRZ';

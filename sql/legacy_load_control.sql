-- Earlier control table (admin_sch.load_control), read by the event-driven pipeline pl_adls_to_bronze_v3.
CREATE SCHEMA IF NOT EXISTS admin_sch;

CREATE TABLE IF NOT EXISTS admin_sch.load_control
(
    source_key          STRING,
    source_type         STRING,
    source_system       STRING,
    source_name         STRING,

    source_container    STRING,
    source_folder       STRING,
    source_file_pattern STRING,
    file_format         STRING,

    destination_schema  STRING,
    destination_table   STRING,

    load_type           STRING,
    primary_key         STRING,
    incremental_column  STRING,
    dependency          STRING,

    active_flag         BOOLEAN,

    insert_ts           TIMESTAMP,
    update_ts           TIMESTAMP
)
USING DELTA;

ALTER TABLE admin_sch.load_control
ADD COLUMNS (
    source_file_name STRING,
    layer STRING,
    job_name STRING,
    silver_loader STRING,
    job_dependency STRING
);

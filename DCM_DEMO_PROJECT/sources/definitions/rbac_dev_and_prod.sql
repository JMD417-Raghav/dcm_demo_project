--Define a sufficient dev role to access database,schema,warehouse,table
DEFINE ROLE dbt_{{env_suffix}}_role;
GRANT CREATE TABLE ON SCHEMA DCM_LEARNING.{{schema_name}} TO ROLE dbt_{{env_suffix}}_role;
GRANT USAGE ON DATABASE DCM_LEARNING TO ROLE dbt_{{env_suffix}}_role;
GRANT USAGE ON SCHEMA DCM_LEARNING.{{schema_name}} TO ROLE dbt_{{env_suffix}}_role;
GRANT SELECT, INSERT ON TABLE DCM_LEARNING.{{schema_name}}.ORDERS_RAW TO ROLE dbt_{{env_suffix}}_role;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE dbt_{{env_suffix}}_role;
GRANT CREATE VIEW ON SCHEMA DCM_LEARNING.{{schema_name}} TO ROLE dbt_{{env_suffix}}_role;
--Define a sufficient prod role to access database,schema,warehouse,table
DEFINE ROLE dbt_prod_role
    COMMENT = 'Least-privilege role for dbt PROD runs';

GRANT USAGE ON DATABASE DCM_LEARNING TO ROLE dbt_prod_role;
GRANT USAGE ON SCHEMA DCM_LEARNING.PROD TO ROLE dbt_prod_role;
GRANT SELECT, INSERT ON TABLE DCM_LEARNING.PROD.ORDERS_RAW TO ROLE dbt_prod_role;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE dbt_prod_role;
GRANT CREATE VIEW ON SCHEMA DCM_LEARNING.PROD TO ROLE dbt_prod_role;
GRANT CREATE TABLE ON SCHEMA DCM_LEARNING.PROD TO ROLE dbt_prod_role;
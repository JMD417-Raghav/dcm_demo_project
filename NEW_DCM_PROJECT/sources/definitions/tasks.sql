
DEFINE SCHEMA DCM_LEARNING.rbac_lab{{env_suffix}};
DEFINE TASK DCM_LEARNING.rbac_lab{{env_suffix}}.root_task
    WAREHOUSE = 'dcm_lab_wh{{env_suffix}}'
    SCHEDULE = '60 MINUTE'
    COMMENT = 'Root task for hands-on task graph'
    STARTED
AS
    SELECT SYSTEM$WAIT(2);

DEFINE TASK DCM_LEARNING.rbac_lab{{env_suffix}}.child_task
    WAREHOUSE = 'dcm_lab_wh{{env_suffix}}'
    COMMENT = 'Simple child task'
    AFTER DCM_LEARNING.rbac_lab{{env_suffix}}.root_task
    STARTED
AS
    SELECT SYSTEM$WAIT(1);

DEFINE TASK DCM_LEARNING.rbac_lab{{env_suffix}}.decision_task
    WAREHOUSE = 'dcm_lab_wh{{env_suffix}}'
    COMMENT = 'Randomly decides pass or fail, to demonstrate branching'
    AFTER DCM_LEARNING.rbac_lab{{env_suffix}}.root_task
    STARTED
AS
    DECLARE
        outcome STRING;
    BEGIN
        outcome := (SELECT CASE WHEN UNIFORM(0,1,RANDOM()) = 1 THEN 'passed' ELSE 'failed' END);
        IF (outcome = 'passed') THEN
            CALL SYSTEM$SET_RETURN_VALUE('passed');
        ELSE
            CALL SYSTEM$SET_RETURN_VALUE('failed');
        END IF;
    END;

DEFINE TASK DCM_LEARNING.rbac_lab{{env_suffix}}.on_pass
    WAREHOUSE = 'dcm_lab_wh{{env_suffix}}'
    COMMENT = 'Only runs when decision_task returned passed'
    AFTER DCM_LEARNING.rbac_lab{{env_suffix}}.decision_task
    WHEN SYSTEM$GET_PREDECESSOR_RETURN_VALUE() = 'passed'
    STARTED
AS
    SELECT 'Handling the pass path';

DEFINE TASK DCM_LEARNING.rbac_lab{{env_suffix}}.on_fail
    WAREHOUSE = 'dcm_lab_wh{{env_suffix}}'
    COMMENT = 'Only runs when decision_task returned failed'
    AFTER DCM_LEARNING.rbac_lab{{env_suffix}}.decision_task
    WHEN SYSTEM$GET_PREDECESSOR_RETURN_VALUE() = 'failed'
    STARTED
AS
    SELECT 'Handling the fail path';

DEFINE TASK DCM_LEARNING.rbac_lab{{env_suffix}}.demo_finalizer
    WAREHOUSE = 'dcm_lab_wh{{env_suffix}}'
    FINALIZE = DCM_LEARNING.rbac_lab{{env_suffix}}.root_task
    COMMENT = 'Always runs last, regardless of success or failure'
    STARTED
AS
    CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
        SNOWFLAKE.NOTIFICATION.TEXT_PLAIN('Task graph run complete'),
        SNOWFLAKE.NOTIFICATION.EMAIL_INTEGRATION_CONFIG(
            'dcm_demo_email_notifications',
            'DCM Hands-on Graph Run',
            ARRAY_CONSTRUCT('raghav.v@jmangroup.com'),
            NULL, NULL));
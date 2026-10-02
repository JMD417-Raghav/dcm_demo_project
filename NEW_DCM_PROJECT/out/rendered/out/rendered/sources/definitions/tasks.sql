
DEFINE SCHEMA DCM_LEARNING.rbac_lab_NEW_DCM_PROJECT;
DEFINE TASK DCM_LEARNING.rbac_lab_NEW_DCM_PROJECT.root_task
    WAREHOUSE = 'dcm_lab_wh_NEW_DCM_PROJECT'
    SCHEDULE = '60 MINUTE'
    COMMENT = 'Root task for hands-on task graph'
    STARTED
AS
    SELECT SYSTEM$WAIT(2);

DEFINE TASK DCM_LEARNING.rbac_lab_NEW_DCM_PROJECT.child_task
    WAREHOUSE = 'dcm_lab_wh_NEW_DCM_PROJECT'
    COMMENT = 'Simple child task'
    AFTER DCM_LEARNING.rbac_lab_NEW_DCM_PROJECT.root_task
    STARTED
AS
    SELECT SYSTEM$WAIT(1);

DEFINE TASK DCM_LEARNING.rbac_lab_NEW_DCM_PROJECT.decision_task
    WAREHOUSE = 'dcm_lab_wh_NEW_DCM_PROJECT'
    COMMENT = 'Randomly decides pass or fail, to demonstrate branching'
    AFTER DCM_LEARNING.rbac_lab_NEW_DCM_PROJECT.root_task
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

DEFINE TASK DCM_LEARNING.rbac_lab_NEW_DCM_PROJECT.on_pass
    WAREHOUSE = 'dcm_lab_wh_NEW_DCM_PROJECT'
    COMMENT = 'Only runs when decision_task returned passed'
    AFTER DCM_LEARNING.rbac_lab_NEW_DCM_PROJECT.decision_task
    WHEN SYSTEM$GET_PREDECESSOR_RETURN_VALUE() = 'passed'
    STARTED
AS
    SELECT 'Handling the pass path';

DEFINE TASK DCM_LEARNING.rbac_lab_NEW_DCM_PROJECT.on_fail
    WAREHOUSE = 'dcm_lab_wh_NEW_DCM_PROJECT'
    COMMENT = 'Only runs when decision_task returned failed'
    AFTER DCM_LEARNING.rbac_lab_NEW_DCM_PROJECT.decision_task
    WHEN SYSTEM$GET_PREDECESSOR_RETURN_VALUE() = 'failed'
    STARTED
AS
    SELECT 'Handling the fail path';

DEFINE TASK DCM_LEARNING.rbac_lab_NEW_DCM_PROJECT.demo_finalizer
    WAREHOUSE = 'dcm_lab_wh_NEW_DCM_PROJECT'
    FINALIZE = DCM_LEARNING.rbac_lab_NEW_DCM_PROJECT.root_task
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
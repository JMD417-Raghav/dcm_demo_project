-- --Update the table definition with a schedule
DEFINE TABLE DCM_LEARNING.Rbac_lab.project_data (
    project_id   NUMBER,
    project_name VARCHAR,
    budget       NUMBER(12,2)
)
    DATA_METRIC_SCHEDULE = TRIGGER_ON_CHANGES
;

-- -- Attach a built-in DMF with a real expectation

ATTACH DATA METRIC FUNCTION SNOWFLAKE.CORE.MIN
    TO TABLE DCM_LEARNING.Rbac_lab.project_data ON (budget)
    EXPECTATION BUDGET_NOT_NEGATIVE (VALUE >= 0);

-- -- Define and attach a governance tag
DEFINE TAG DCM_LEARNING.rbac_lab.cost_center_tag
    COMMENT = 'Tracks which team owns the budget/cost for this data';


-- --Deploy it and to test the Pipeline Gate is running properly or not
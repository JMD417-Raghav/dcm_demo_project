-- Insert test data (plain worksheet, not in the DEFINE file)
INSERT INTO DCM_LEARNING.rbac_lab.project_data VALUES
    (1, 'Website Revamp', 5000.00),
    (2, 'Broken Test Row', -200.00);

-- Run the quality gate
EXECUTE DCM PROJECT DCM_DEMO.PROJECTS.DCM_PROJECT_DEV TEST ALL;

-- (Test All is not running due to Standard edition of Snowflake)
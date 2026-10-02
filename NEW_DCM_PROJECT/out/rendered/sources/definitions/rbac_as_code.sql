DEFINE SCHEMA DCM_LEARNING.Rbac_lab
COMMENT = 'RBAC-as-code hands-on lab';

-- DEFINE TABLE DCM_LEARNING.Rbac_lab.project_data (
    -- project_id   NUMBER,
    -- project_name VARCHAR,
    -- budget       NUMBER(12,2)
-- );
-- Define two roles: a reader, and a delegated admin
DEFINE ROLE rbac_lab_reader
    COMMENT = 'Read-only access to rbac_lab'  ;
    
DEFINE ROLE rbac_lab_admin
    COMMENT = 'Can manage grants within rbac_lab only, without SECURITYADMIN';

GRANT USAGE ON DATABASE DCM_LEARNING TO ROLE rbac_lab_reader;

GRANT USAGE ON SCHEMA DCM_LEARNING.rbac_lab TO ROLE rbac_lab_reader;
GRANT SELECT ON TABLE DCM_LEARNING.rbac_lab.project_data TO ROLE rbac_lab_reader;





--GRANT MANAGE GRANTS ON DATABASE DCM_LEARNING TO ROLE rbac_lab_admin;
GRANT USAGE ON DATABASE DCM_LEARNING TO ROLE rbac_lab_admin;

-- Prove the access boundary
GRANT ROLE rbac_lab_reader TO USER RAGHAVNEW;

-- Prove MANAGE GRANTS delegation actually works
GRANT ROLE rbac_lab_admin TO USER RAGHAVNEW;
--Deliberately revoke  GRANT access (Go to worksheet sql)

--Next to prove one owner one grant conflict Copy paste the same grant code to some other dcm project it will fail taking the same line number 17 grant command


--Next to prove dcm is unaware of the grant access outside at the worksheet run that and do the plan


--owner lockout protection is not tested properly
USE ROLE RBAC_LAB_READER;

-- Switch active role → rbac_lab_reader 
SELECT * FROM rbac_lab.project_data; -- (should work) 
-- try selecting from test.legacy_products (should fail — no grant there).
SELECT * FROM test.orders;







--Manage Grants Delegation
USE ROLE RBAC_LAB_ADMIN;

GRANT TRUNCATE ON TABLE rbac_lab.project_data TO ROLE rbac_lab_reader;

--Deliberately revoke  GRANT access to know PLAN is doing drifting correctly by adding the select on table there

REVOKE SELECT ON TABLE rbac_lab.project_data FROM ROLE rbac_lab_reader;


--DCM is blind to grants made outside it
GRANT INSERT ON TABLE rbac_lab.project_data TO ROLE rbac_lab_reader;
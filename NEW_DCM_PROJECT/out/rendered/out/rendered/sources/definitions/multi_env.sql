-- -- Add a new manifest.yml containing two set of target
-- --Create a new dcm project for prod in a worksheet
-- -- Update your DEFINE file to actually use the Jinja variable
DEFINE WAREHOUSE dcm_lab_wh_NEW_DCM_PROJECT
    WAREHOUSE_SIZE = 'SMALL'
    COMMENT = 'Multi-environment promotion test warehouse';

-- --When I run for dev it works fine Because my previous sql files own the role called rbac_lab_reader it belong to dev environment.But when I change to prod their roles are also dependent to the environemnt.

-- --So after this 

-- --We will change to some other extension to check its correctness.
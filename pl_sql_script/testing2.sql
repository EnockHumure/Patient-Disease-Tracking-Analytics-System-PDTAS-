-- Testing get_patient_treatments
-- Normal Case – Patient exists, all treatments
SET SERVEROUTPUT ON;

BEGIN
    hospital_pkg.get_patient_treatments(p_patient_id => 1);
END;
/

--Normal Case – Patient exists, filter by disease
-- Expected: Outputs only Malaria treatment for patient 1.
BEGIN
    hospital_pkg.get_patient_treatments(p_patient_id => 1, p_disease_name => 'Malaria');
END;
/

-- Edge Case – Patient exists, but no treatments

BEGIN
    hospital_pkg.get_patient_treatments(p_patient_id => 9999);
END;
/

--Expected:

-- DBMS_OUTPUT prints “ERROR: Patient 9999 does not exist.”

-- Error is logged in error_logs table.

SELECT * FROM error_logs ORDER BY log_id DESC FETCH FIRST 5 ROWS ONLY;

-- Edge Case – Invalid disease name

BEGIN
    hospital_pkg.get_patient_treatments(p_patient_id => 1, p_disease_name => 'Cholera');
END;
/

-- Testing analytics_window_functions
-- Normal case

BEGIN
    hospital_pkg.analytics_window_functions;
END;
/
-- Edge case – Empty reception table

-- Backup your data first
DELETE FROM reception;

BEGIN
    hospital_pkg.analytics_window_functions;
END;
/

-- Verify error logging


SELECT * FROM error_logs ORDER BY log_id DESC FETCH FIRST 10 ROWS ONLY;

-- Performance check

BEGIN
    hospital_pkg.analytics_window_functions;
END;
/





-- ===========================================================
-- TEST SCRIPT FOR HOSPITAL_PKG PACKAGE
-- Includes: get_patient_treatments & analytics_window_functions
-- Author: Coach Enock
-- ===========================================================

-- Enable DBMS_OUTPUT to see printed results
SET SERVEROUTPUT ON;

-- ===========================================================
-- 1️⃣ Test get_patient_treatments
-- ===========================================================

-- a) Normal case: patient exists, all treatments
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Test 1a: All treatments for patient_id = 1 ---');
    hospital_pkg.get_patient_treatments(p_patient_id => 1);
END;
/

-- b) Normal case: filter by disease
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Test 1b: Filter treatments for patient_id = 1, disease = Malaria ---');
    hospital_pkg.get_patient_treatments(p_patient_id => 1, p_disease_name => 'Malaria');
END;
/

-- c) Edge case: patient does not exist
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Test 1c: Patient does not exist (patient_id = 9999) ---');
    hospital_pkg.get_patient_treatments(p_patient_id => 9999);
END;
/

-- d) Edge case: patient exists but no treatments for disease
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Test 1d: Patient exists but disease not treated (patient_id = 1, disease = Cholera) ---');
    hospital_pkg.get_patient_treatments(p_patient_id => 1, p_disease_name => 'Cholera');
END;
/

-- ===========================================================
-- 2️⃣ Test analytics_window_functions
-- ===========================================================

-- a) Normal case: data exists in reception table
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Test 2a: Analytics report with existing data ---');
    hospital_pkg.analytics_window_functions;
END;
/

-- b) Edge case: reception table is empty
-- Uncomment only if you want to test empty table scenario
-- Backup your data first!
/*
DELETE FROM reception;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Test 2b: Analytics report with empty reception table ---');
    hospital_pkg.analytics_window_functions;
END;
/

-- Restore sample data after test
-- Use your INSERT statements for reception table here
*/

-- ===========================================================
-- 3️⃣ Verify error logging
-- ===========================================================
-- Show last 10 error logs
SELECT *
FROM error_logs
ORDER BY log_id DESC
FETCH FIRST 10 ROWS ONLY;

-- ===========================================================
-- 4️⃣ Performance notes
-- ===========================================================
-- For large tables, check execution time of analytics_window_functions
-- Simply run:
-- BEGIN
--    hospital_pkg.analytics_window_functions;
-- END;
-- /

-- ===========================================================
-- END OF TEST SCRIPT
-- ===========================================================


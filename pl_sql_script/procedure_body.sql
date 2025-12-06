--Custom exception: 
CREATE OR REPLACE PACKAGE BODY hospital_pkg AS

/* -------------------------------------------
   PROCEDURE: log_error
   Logs errors to a table called error_logs
--------------------------------------------*/
PROCEDURE log_error(
    p_proc_name IN VARCHAR2,
    p_error_msg IN VARCHAR2
) IS
BEGIN
    INSERT INTO error_logs(proc_name, error_message, error_time)
    VALUES (p_proc_name, p_error_msg, SYSDATE);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Fallback if logging fails
        DBMS_OUTPUT.PUT_LINE('Error logging failed in ' || p_proc_name || ': ' || SQLERRM);
END log_error;

/* -------------------------------------------
   PROCEDURE: get_patient_treatments
   Shows all treatments for a patient
   Optional disease filter
--------------------------------------------*/
PROCEDURE get_patient_treatments(
    p_patient_id   IN NUMBER,
    p_disease_name IN VARCHAR2 DEFAULT NULL
) IS
    v_exists NUMBER;
BEGIN
    -- Check if patient exists
    SELECT COUNT(*) INTO v_exists
    FROM reception
    WHERE patient_id = p_patient_id;

    IF v_exists = 0 THEN
        RAISE e_patient_not_found;
    END IF;

    -- Cursor loop to fetch treatments
    FOR rec IN (
        SELECT treatment_id,
               disease_name,
               medication,
               dosage,
               treatment_start_date,
               treatment_end_date,
               pharmacist_name
        FROM treatment
        WHERE patient_id = p_patient_id
          AND (p_disease_name IS NULL OR disease_name = p_disease_name)
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Treatment ID: ' || rec.treatment_id ||
            ' | Disease: ' || rec.disease_name ||
            ' | Medication: ' || rec.medication ||
            ' | Dosage: ' || rec.dosage ||
            ' | Start: ' || rec.treatment_start_date ||
            ' | End: ' || NVL(TO_CHAR(rec.treatment_end_date,'YYYY-MM-DD'),'N/A') ||
            ' | Pharmacist: ' || rec.pharmacist_name
        );
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No treatments found for patient ' || p_patient_id);
        log_error('get_patient_treatments', 'No treatments found');

    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected multiple rows for patient ' || p_patient_id);
        log_error('get_patient_treatments', 'Too many rows returned');

    WHEN e_patient_not_found THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Patient ' || p_patient_id || ' does not exist.');
        log_error('get_patient_treatments', 'Patient not found');

    WHEN OTHERS THEN
        log_error('get_patient_treatments', SQLERRM);
        -- Recovery mechanism: skip and continue
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred. Check error_logs.');
END get_patient_treatments;

/* -------------------------------------------
   PROCEDURE: analytics_window_functions
   Shows window function analytics on reception table
--------------------------------------------*/
PROCEDURE analytics_window_functions IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Window Analytics Report ---');

    FOR rec IN (
        SELECT patient_id,
               first_name,
               last_name,
               disease_name,
               ROW_NUMBER() OVER (PARTITION BY disease_name ORDER BY patient_id) AS rn,
               RANK()       OVER (PARTITION BY disease_name ORDER BY visit_date) AS rank_no,
               DENSE_RANK() OVER (PARTITION BY disease_name ORDER BY visit_date) AS dense_rank_no,
               LAG(visit_date)  OVER (PARTITION BY disease_name ORDER BY visit_date) AS previous_visit,
               LEAD(visit_date) OVER (PARTITION BY disease_name ORDER BY visit_date) AS next_visit
        FROM reception
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Patient ID: ' || rec.patient_id ||
            ' | Name: ' || rec.first_name || ' ' || rec.last_name ||
            ' | Disease: ' || rec.disease_name ||
            ' | Row#: ' || rec.rn ||
            ' | Rank: ' || rec.rank_no ||
            ' | DenseRank: ' || rec.dense_rank_no ||
            ' | PrevVisit: ' || rec.previous_visit ||
            ' | NextVisit: ' || rec.next_visit
        );
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No records found in reception table.');
        log_error('analytics_window_functions', 'No data found');

    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected multiple rows error.');
        log_error('analytics_window_functions', 'Too many rows');

    WHEN OTHERS THEN
        log_error('analytics_window_functions', SQLERRM);
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred. Check error_logs.');
END analytics_window_functions;

END hospital_pkg;
/

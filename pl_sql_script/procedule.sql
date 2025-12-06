/* ============================================================
   PATIENT PROCEDURES
   Phase VI – Stored Procedures Implementation
 
   ============================================================ */

/* ------------------------------------------------------------
   1) PROCEDURE: register_patient
      Inserts a new patient into reception table
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE register_patient (
    p_first_name    IN reception.first_name%TYPE,
    p_last_name     IN reception.last_name%TYPE,
    p_gender        IN reception.gender%TYPE,
    p_dob           IN reception.date_of_birth%TYPE,
    p_phone         IN reception.phone%TYPE,
    p_address       IN reception.address%TYPE,
    p_patient_id    OUT reception.patient_id%TYPE
) AS
BEGIN
    INSERT INTO reception (first_name, last_name, gender, date_of_birth, phone, address)
    VALUES (p_first_name, p_last_name, p_gender, p_dob, p_phone, p_address)
    RETURNING patient_id INTO p_patient_id;

    DBMS_OUTPUT.PUT_LINE('Patient registered successfully. ID: ' || p_patient_id);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error registering patient: ' || SQLERRM);
END;
/
 

/* ------------------------------------------------------------
   2) PROCEDURE: update_patient_info
      Updates patient demographic details
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE update_patient_info (
    p_patient_id    IN reception.patient_id%TYPE,
    p_phone         IN reception.phone_number%TYPE,
    p_address       IN reception.address%TYPE
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM reception
    WHERE patient_id = p_patient_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Patient ID does not exist.');
    END IF;

    UPDATE reception
    SET phone_number = p_phone,
        address = p_address
    WHERE patient_id = p_patient_id;

    DBMS_OUTPUT.PUT_LINE('Patient info updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error updating patient info: ' || SQLERRM);
END;
/
/* ------------------------------------------------------------
   3) PROCEDURE: delete_patient
      Safely deletes a patient if no dependencies exist
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE delete_patient (
    p_patient_id IN reception.patient_id%TYPE
) AS
    v_ref NUMBER;
BEGIN
    -- Check FK references (doctor, lab, treatment, stats)
    SELECT (
        (SELECT COUNT(*) FROM doctor WHERE patient_id = p_patient_id) +
        (SELECT COUNT(*) FROM lab_technician WHERE patient_id = p_patient_id) +
        (SELECT COUNT(*) FROM treatment WHERE patient_id = p_patient_id) +
        (SELECT COUNT(*) FROM disease_stats WHERE patient_id = p_patient_id)
    )
    INTO v_ref
    FROM dual;

    IF v_ref > 0 THEN
        RAISE_APPLICATION_ERROR(-20004,
            'Cannot delete patient: dependent records exist.');
    END IF;

    DELETE FROM reception WHERE patient_id = p_patient_id;

    DBMS_OUTPUT.PUT_LINE('Patient deleted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20005, 'Error deleting patient: ' || SQLERRM);
END;
/





/* ============================================================
   DOCTOR PROCEDURES
   Phase VI – Stored Procedures Implementation
============================================================ */

/* ------------------------------------------------------------
   1) PROCEDURE: add_doctor
      Inserts a new doctor into the doctor table
------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE add_doctor (
    p_first_name    IN doctor.first_name%TYPE,
    p_last_name     IN doctor.last_name%TYPE,
    p_gender        IN doctor.gender%TYPE,
    p_phone         IN doctor.phone_number%TYPE,
    p_specialization IN doctor.specialization%TYPE,
    p_doctor_id     OUT doctor.doctor_id%TYPE
) AS
BEGIN
    INSERT INTO doctor (first_name, last_name, gender, phone_number, specialization)
    VALUES (p_first_name, p_last_name, p_gender, p_phone, p_specialization)
    RETURNING doctor_id INTO p_doctor_id;

    DBMS_OUTPUT.PUT_LINE('Doctor added successfully. ID: ' || p_doctor_id);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-21001, 'Error adding doctor: ' || SQLERRM);
END;
/

  
/* ------------------------------------------------------------
   2) PROCEDURE: update_doctor_info
      Updates doctor contact or specialization
------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE update_doctor_info (
    p_doctor_id      IN doctor.doctor_id%TYPE,
    p_phone          IN doctor.phone_number%TYPE,
    p_specialization IN doctor.specialization%TYPE
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM doctor
    WHERE doctor_id = p_doctor_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-21002, 'Doctor ID does not exist.');
    END IF;

    UPDATE doctor
    SET phone_number = p_phone,
        specialization = p_specialization
    WHERE doctor_id = p_doctor_id;

    DBMS_OUTPUT.PUT_LINE('Doctor info updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-21003, 'Error updating doctor info: ' || SQLERRM);
END;
/


/* ------------------------------------------------------------
   3) PROCEDURE: assign_doctor_to_patient
      Links a doctor to a patient in the reception table
------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE assign_doctor_to_patient (
    p_patient_id IN reception.patient_id%TYPE,
    p_doctor_id  IN doctor.doctor_id%TYPE
) AS
    v_count NUMBER;
BEGIN
    -- Ensure patient exists
    SELECT COUNT(*) INTO v_count FROM reception WHERE patient_id = p_patient_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-21004, 'Patient ID does not exist.');
    END IF;

    -- Ensure doctor exists
    SELECT COUNT(*) INTO v_count FROM doctor WHERE doctor_id = p_doctor_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-21005, 'Doctor ID does not exist.');
    END IF;

    -- Assign doctor
    UPDATE reception
    SET doctor_id = p_doctor_id
    WHERE patient_id = p_patient_id;

    DBMS_OUTPUT.PUT_LINE('Doctor assigned to patient successfully.');
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-21006, 'Error assigning doctor: ' || SQLERRM);
END;
/





/* ============================================================
   LAB PROCEDURES
   Phase VI – Stored Procedures Implementation
============================================================ */

CREATE OR REPLACE PROCEDURE add_lab_test (
    p_patient_id       IN reception.patient_id%TYPE,
    p_test_type        IN lab_technician.test_type%TYPE,
    p_test_result      IN lab_technician.test_result%TYPE,
    p_lab_technician   IN lab_technician.lab_technician_name%TYPE,
    p_lab_department   IN lab_technician.lab_department%TYPE,
    p_test_status      IN lab_technician.test_status%TYPE DEFAULT 'Completed',
    p_remarks          IN lab_technician.remarks%TYPE
) AS
    v_count NUMBER;
BEGIN
    -- Check if patient exists
    SELECT COUNT(*) INTO v_count
    FROM reception
    WHERE patient_id = p_patient_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-22001, 'Patient ID does not exist.');
    END IF;

    -- Insert lab test
    INSERT INTO lab_technician (patient_id, test_type, test_result, lab_technician_name, lab_department, test_status, remarks)
    VALUES (p_patient_id, p_test_type, p_test_result, p_lab_technician, p_lab_department, p_test_status, p_remarks);

    DBMS_OUTPUT.PUT_LINE('Lab test added successfully for patient ID: ' || p_patient_id);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-22002, 'Error adding lab test: ' || SQLERRM);
END;
/


/* ------------------------------------------------------------
   2) PROCEDURE: update_lab_result
      Updates the result or status of an existing lab test
------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE update_lab_result (
    p_lab_test_id   IN lab_technician.lab_test_id%TYPE,
    p_test_result   IN lab_technician.test_result%TYPE,
    p_test_status   IN lab_technician.test_status%TYPE
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM lab_technician
    WHERE lab_test_id = p_lab_test_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-22003, 'Lab test ID does not exist.');
    END IF;

    UPDATE lab_technician
    SET test_result = p_test_result,
        test_status = p_test_status
    WHERE lab_test_id = p_lab_test_id;

    DBMS_OUTPUT.PUT_LINE('Lab test updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-22004, 'Error updating lab test: ' || SQLERRM);
END;
/







/* ============================================================
   ANALYTICS PROCEDURES
   Phase VI – Stored Procedures Implementation
============================================================ */

/* ------------------------------------------------------------
   1) PROCEDURE: record_daily_disease_stats
      Inserts or updates disease counts per day
------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE record_daily_disease_stats (
    p_disease_name      IN disease_stats.disease_name%TYPE,
    p_patient_count     IN NUMBER,
    p_hospital_location IN disease_stats.hospital_location%TYPE
) AS
    v_count NUMBER;
BEGIN
    -- Check if record exists for today
    SELECT COUNT(*) INTO v_count
    FROM disease_stats
    WHERE disease_name = p_disease_name
      AND record_date = TRUNC(SYSDATE)
      AND hospital_location = p_hospital_location;

    IF v_count > 0 THEN
        -- Update existing record
        UPDATE disease_stats
        SET patient_count = patient_count + p_patient_count
        WHERE disease_name = p_disease_name
          AND record_date = TRUNC(SYSDATE)
          AND hospital_location = p_hospital_location;
    ELSE
        -- Insert new record
        INSERT INTO disease_stats (disease_name, patient_count, record_date, hospital_location)
        VALUES (p_disease_name, p_patient_count, TRUNC(SYSDATE), p_hospital_location);
    END IF;

    DBMS_OUTPUT.PUT_LINE('Daily stats recorded for disease: ' || p_disease_name);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-23001, 'Error recording daily stats: ' || SQLERRM);
END;
/

/* ------------------------------------------------------------
   2) PROCEDURE: reset_monthly_disease_stats
      Resets disease counts for monthly reporting
------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE reset_monthly_disease_stats (
    p_month IN NUMBER,
    p_year  IN NUMBER
) AS
BEGIN
    DELETE FROM disease_stats
    WHERE EXTRACT(MONTH FROM record_date) = p_month
      AND EXTRACT(YEAR FROM record_date) = p_year;

    DBMS_OUTPUT.PUT_LINE('Monthly disease stats reset for month: ' || p_month || ', year: ' || p_year);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-23002, 'Error resetting monthly stats: ' || SQLERRM);
END;
/

/* ------------------------------------------------------------
   3) PROCEDURE: calculate_disease_trend
      Summarizes disease counts over a period
------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE calculate_disease_trend (
    p_start_date IN DATE,
    p_end_date   IN DATE
) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Disease trends from ' || TO_CHAR(p_start_date,'DD-MON-YYYY') ||
                         ' to ' || TO_CHAR(p_end_date,'DD-MON-YYYY') || ':');

    FOR rec IN (
        SELECT disease_name, SUM(patient_count) AS total_cases
        FROM disease_stats
        WHERE record_date BETWEEN p_start_date AND p_end_date
        GROUP BY disease_name
        ORDER BY total_cases DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(rec.disease_name || ': ' || rec.total_cases || ' cases');
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-23003, 'Error calculating disease trend: ' || SQLERRM);
END;
/







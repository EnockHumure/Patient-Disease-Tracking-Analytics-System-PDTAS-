/* ============================================================
   Cursor: c_patients_by_disease
   Purpose: Retrieve all patients diagnosed with a specific main disease
============================================================ */
/* ============================================================
   Cursor with Parameter: Get all patients for a specific disease
============================================================ */
CREATE OR REPLACE PROCEDURE get_patients_by_disease(
    p_disease_name IN VARCHAR2
) IS
BEGIN
    FOR rec IN (
        SELECT patient_id, first_name, last_name, disease_name
        FROM reception
        WHERE disease_name = p_disease_name
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Patient ID: ' || rec.patient_id ||
                             ' | Name: ' || rec.first_name || ' ' || rec.last_name ||
                             ' | Disease: ' || rec.disease_name);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-21020, 'Error fetching patients: ' || SQLERRM);
END;
/


/* ============================================================
   Cursor FOR Loop: Mark pending lab tests as Completed (optional patient filter)
============================================================ */
CREATE OR REPLACE PROCEDURE mark_pending_lab_tests(p_patient_id IN NUMBER DEFAULT NULL) IS
BEGIN
    FOR rec IN (
        SELECT lab_test_id
        FROM lab_technician
        WHERE test_status = 'Pending'
        AND (p_patient_id IS NULL OR patient_id = p_patient_id)
    )
    LOOP
        UPDATE lab_technician
        SET test_status = 'Completed'
        WHERE lab_test_id = rec.lab_test_id;

        DBMS_OUTPUT.PUT_LINE('Updated Lab Test ID: ' || rec.lab_test_id || ' to Completed');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-21011, 'Error updating lab tests: ' || SQLERRM);
END;
/


/* ============================================================
   Cursor with Parameters: Get all treatments for a specific patient
   Optional filter by disease
============================================================ */
CREATE OR REPLACE PROCEDURE get_patient_treatments(
    p_patient_id   IN NUMBER,
    p_disease_name IN VARCHAR2 DEFAULT NULL
) IS
BEGIN
    FOR rec IN (
        SELECT treatment_id, disease_name, medication, dosage
        FROM treatment
        WHERE patient_id = p_patient_id
        AND (p_disease_name IS NULL OR disease_name = p_disease_name)
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Treatment ID: ' || rec.treatment_id ||
                             ' | Disease: ' || rec.disease_name ||
                             ' | Medication: ' || rec.medication ||
                             ' | Dosage: ' || rec.dosage);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-21012, 'Error fetching treatments: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE get_patients_by_disease_explicit(
    p_disease_name IN VARCHAR2
) IS
    TYPE t_patient_tab IS TABLE OF reception%ROWTYPE;
    v_patients t_patient_tab;

    CURSOR c_patients IS
        SELECT patient_id, first_name, last_name, disease_name
        FROM reception
        WHERE disease_name = p_disease_name;
BEGIN
    OPEN c_patients;
    FETCH c_patients BULK COLLECT INTO v_patients;
    CLOSE c_patients;

    FOR i IN 1 .. v_patients.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Patient ID: ' || v_patients(i).patient_id ||
                             ' | Name: ' || v_patients(i).first_name || ' ' || v_patients(i).last_name ||
                             ' | Disease: ' || v_patients(i).disease_name);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-21050, 'Error fetching patients: ' || SQLERRM);
END;
/




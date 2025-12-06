
CREATE OR REPLACE FUNCTION fn_calculate_age (
    p_dob IN DATE
) RETURN NUMBER IS
    v_age NUMBER;
BEGIN
    -- Calculate age in years
    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, p_dob) / 12);
    RETURN v_age;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-23001, 'Error calculating age: ' || SQLERRM);
END;
/
--example of prove
SELECT fn_calculate_age(TO_DATE('1990-05-12','YYYY-MM-DD')) AS patient_age FROM dual;


CREATE OR REPLACE FUNCTION fn_disease_category (
    p_disease_name IN VARCHAR2
) RETURN VARCHAR2 IS
    v_count NUMBER;
    v_category VARCHAR2(20);
BEGIN
    -- Check if disease exists in main_diseases
    SELECT COUNT(*) INTO v_count
    FROM main_diseases
    WHERE disease_name = p_disease_name;

    IF v_count > 0 THEN
        v_category := 'Main Disease';
    ELSE
        v_category := 'Other Disease';
    END IF;

    RETURN v_category;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-23002, 'Error determining disease category: ' || SQLERRM);
END;
/



SELECT fn_disease_category('Malaria') AS disease_type FROM dual;
-- Returns: Main Disease

SELECT fn_disease_category('Cholera') AS disease_type FROM dual;
-- Returns: Other Disease


/* ============================================================
   FUNCTION: fn_monthly_cases
   Returns the total patient count for a disease in a given month and year
============================================================ */
CREATE OR REPLACE FUNCTION fn_monthly_cases (
    p_disease_name IN VARCHAR2,
    p_month        IN NUMBER,
    p_year         IN NUMBER
) RETURN NUMBER IS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(patient_count), 0)
    INTO v_total
    FROM disease_stats
    WHERE disease_name = p_disease_name
      AND EXTRACT(MONTH FROM record_date) = p_month
      AND EXTRACT(YEAR FROM record_date) = p_year;

    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-23003, 'Error calculating monthly cases: ' || SQLERRM);
END;
/





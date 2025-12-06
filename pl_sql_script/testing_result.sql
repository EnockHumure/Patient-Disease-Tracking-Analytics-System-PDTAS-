--------------------------------------------------------------------------------
-- testing_queries.sql
-- Purpose: Demonstrate database functionality after Phase V implementation
-- Includes: SELECT *, JOINS, AGGREGATIONS, SUBQUERIES, WINDOW FUNCTIONS
--------------------------------------------------------------------------------


/******************************************************************************
1. BASIC RETRIEVAL QUERIES (SELECT *)
******************************************************************************/

-- Get all patient registrations
SELECT * FROM reception;

-- Get all lab tests
SELECT * FROM lab_technician;

-- Get all treatments
SELECT * FROM treatment;

-- Get the disease statistics table
SELECT * FROM disease_stats;



/******************************************************************************
2. JOIN QUERIES (FOR MULTI-TABLE REPORTING)
******************************************************************************/

-- Show patients + their lab test results
SELECT 
    r.patient_id,
    r.first_name,
    r.last_name,
    l.test_type,
    l.test_result,
    l.test_date
FROM reception r
JOIN lab_technician l ON r.patient_id = l.patient_id;


-- Show patients + treatment details + doctor information
SELECT
    r.first_name || ' ' || r.last_name AS patient_name,
    t.medication,
    t.treatment_date,
    d.doctor_name,
    d.specialization
FROM treatment t
JOIN reception r ON t.patient_id = r.patient_id
JOIN doctor d ON t.doctor_id = d.doctor_id;


-- Show disease spread by province (example analytics)
SELECT 
    r.disease_name,
    COUNT(*) AS total_cases
FROM reception r
GROUP BY r.disease_name;



/******************************************************************************
3. AGGREGATION QUERIES (GROUP BY / ANALYTICS)
******************************************************************************/

-- Count patients per disease
SELECT 
    disease_name,
    COUNT(*) AS num_patients
FROM reception
GROUP BY disease_name;

-- Number of lab tests performed per test type
SELECT 
    test_type,
    COUNT(*) AS total_tests
FROM lab_technician
GROUP BY test_type;

-- Monthly disease trend (from disease_stats)
SELECT 
    disease_name,
    month,
    SUM(case_count) AS total_monthly_cases
FROM disease_stats
GROUP BY disease_name, month
ORDER BY disease_name, month;



/******************************************************************************
4. SUBQUERY TESTING (NESTED QUERIES)
******************************************************************************/

-- Get patients who tested positive for ANY disease
SELECT 
    first_name, 
    last_name, 
    phone_number
FROM reception
WHERE patient_id IN (
    SELECT patient_id 
    FROM lab_technician
    WHERE test_result = 'Positive'
);

-- Get top 1 most common disease
SELECT disease_name
FROM (
    SELECT disease_name, COUNT(*) AS total_cases
    FROM reception
    GROUP BY disease_name
    ORDER BY total_cases DESC
)
WHERE ROWNUM = 1;



/******************************************************************************
5. WINDOW FUNCTION TESTS (BI ANALYTICS LEVEL)
******************************************************************************/

-- Rank diseases by number of cases
SELECT 
    disease_name,
    COUNT(*) AS total_cases,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_by_cases
FROM reception
GROUP BY disease_name;

-- Running total of cases over time for each disease
SELECT 
    disease_name,
    month,
    case_count,
    SUM(case_count) OVER (PARTITION BY disease_name ORDER BY month) AS running_total
FROM disease_stats
ORDER BY disease_name, month;

-- Lead/Lag example: Compare current month vs previous month
SELECT
    disease_name,
    month,
    case_count,
    LAG(case_count, 1) OVER (PARTITION BY disease_name ORDER BY month) AS previous_month,
    LEAD(case_count, 1) OVER (PARTITION BY disease_name ORDER BY month) AS next_month
FROM disease_stats
ORDER BY disease_name, month;



/******************************************************************************
6. EDGE CASE TESTING
******************************************************************************/

-- Check for unknown diseases (should be zero or rare)
SELECT * 
FROM reception
WHERE disease_name NOT IN (SELECT disease_name FROM main_diseases);

-- Patients without lab tests
SELECT *
FROM reception
WHERE patient_id NOT IN (SELECT patient_id FROM lab_technician);

-- Lab tests without treatment
SELECT *
FROM lab_technician
WHERE patient_id NOT IN (SELECT patient_id FROM treatment);

--------------------------------------------------------------------------------
-- END OF FILE
--------------------------------------------------------------------------------

/* ============================================================
   1) ROW_NUMBER(): Assign a unique number to patients per disease
============================================================ */
SELECT patient_id,
       first_name,
       last_name,
       disease_name,
       ROW_NUMBER() OVER (PARTITION BY disease_name ORDER BY patient_id) AS rn
FROM reception;

/* ============================================================
   2) RANK(): Rank patients by number of treatments per disease
============================================================ */
SELECT disease_name,
       patient_id,
       COUNT(treatment_id) AS treatment_count,
       RANK() OVER (PARTITION BY disease_name ORDER BY COUNT(treatment_id) DESC) AS patient_rank
FROM treatment
GROUP BY disease_name, patient_id;

/* ============================================================
   3) DENSE_RANK(): Rank patients by number of lab tests (no gaps)
============================================================ */
SELECT patient_id,
       COUNT(lab_test_id) AS total_tests,
       DENSE_RANK() OVER (ORDER BY COUNT(lab_test_id) DESC) AS test_rank
FROM lab_technician
GROUP BY patient_id;

/* ============================================================
   4) LAG(): Show previous lab test result for each patient
============================================================ */
SELECT patient_id,
       lab_test_id,
       test_result,
       LAG(test_result) OVER (PARTITION BY patient_id ORDER BY lab_test_id) AS previous_result
FROM lab_technician;

/* ============================================================
   5) LEAD(): Show next lab test result for each patient
============================================================ */
SELECT patient_id,
       lab_test_id,
       test_result,
       LEAD(test_result) OVER (PARTITION BY patient_id ORDER BY lab_test_id) AS next_result
FROM lab_technician;

/* ============================================================
   6) Aggregate with OVER(): Count total patients per disease
============================================================ */
SELECT patient_id,
       first_name,
       last_name,
       disease_name,
       COUNT(*) OVER (PARTITION BY disease_name) AS total_patients_per_disease
FROM reception;

/* ============================================================
   7) Aggregate with OVER() + ORDER BY: Cumulative lab tests per patient
============================================================ */
SELECT patient_id,
       lab_test_id,
       COUNT(*) OVER (PARTITION BY patient_id ORDER BY lab_test_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_tests
FROM lab_technician;

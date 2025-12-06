-- ======================================================
-- Phase V: Table Implementation & Data Verification
-- PDTAS (Patient Disease Tracking & Analytics System)
-- Validation Script for GitHub Submission
-- ======================================================

-- ======================================================
-- 1️⃣ Table Existence Verification
-- ======================================================
SELECT table_name 
FROM user_tables
WHERE table_name IN (
    'MAIN_DISEASES',
    'OTHER_DISEASES',
    'RECEPTION',
    'DOCTOR',
    'LAB_TECHNICIAN',
    'TREATMENT',
    'DISEASE_STATS'
);

-- ======================================================
-- 2️⃣ Column & Data Type Verification (Example: RECEPTION)
-- ======================================================
SELECT column_name, data_type, nullable
FROM user_tab_columns
WHERE table_name = 'RECEPTION';

-- ======================================================
-- 3️⃣ Primary Key & Foreign Key Constraints
-- ======================================================
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE table_name IN (
    'RECEPTION',
    'LAB_TECHNICIAN',
    'TREATMENT',
    'DOCTOR',
    'DISEASE_STATS'
);

-- ======================================================
-- 4️⃣ Row Count Verification
-- ======================================================
SELECT COUNT(*) AS main_diseases_count FROM main_diseases;
SELECT COUNT(*) AS other_diseases_count FROM other_diseases;
SELECT COUNT(*) AS reception_count FROM reception;
SELECT COUNT(*) AS doctor_count FROM doctor;
SELECT COUNT(*) AS lab_technician_count FROM lab_technician;
SELECT COUNT(*) AS treatment_count FROM treatment;
SELECT COUNT(*) AS disease_stats_count FROM disease_stats;

-- ======================================================
-- 5️⃣ Foreign Key Relationship Verification
-- ======================================================
-- Check lab_technician FK
SELECT *
FROM lab_technician l
WHERE NOT EXISTS (
    SELECT 1 FROM reception r WHERE r.patient_id = l.patient_id
);

-- Check treatment FK
SELECT *
FROM treatment t
WHERE NOT EXISTS (
    SELECT 1 FROM reception r WHERE r.patient_id = t.patient_id
);

-- ======================================================
-- 6️⃣ Basic Data Retrieval Queries
-- ======================================================
-- Retrieve all patients
SELECT * FROM reception;

-- Join lab tests with patients
SELECT r.first_name, r.last_name, l.test_type, l.test_result, l.lab_technician_name
FROM reception r
JOIN lab_technician l ON r.patient_id = l.patient_id;

-- Join treatments with patients
SELECT r.first_name, r.last_name, t.medication, t.dosage, t.pharmacist_name
FROM reception r
JOIN treatment t ON r.patient_id = t.patient_id;

-- ======================================================
-- 7️⃣ Aggregation & Analytics
-- ======================================================
-- Number of patients per disease
SELECT disease_name, COUNT(*) AS patient_count
FROM reception
GROUP BY disease_name;

-- Disease stats per hospital
SELECT hospital_location, disease_name, SUM(patient_count) AS total_patients
FROM disease_stats
GROUP BY hospital_location, disease_name;

-- ======================================================
-- 8️⃣ Subqueries & Edge Cases
-- ======================================================
-- Patients who have treatment but no lab test yet
SELECT first_name, last_name
FROM reception r
WHERE patient_id IN (SELECT patient_id FROM treatment)
  AND patient_id NOT IN (SELECT patient_id FROM lab_technician);

-- Patients with diseases not in main_diseases
SELECT r.first_name, r.last_name, r.disease_name
FROM reception r
WHERE r.disease_name NOT IN (SELECT disease_name FROM main_diseases);

-- ======================================================
-- 9️⃣ Dashboard / Top Disease Example
-- ======================================================
-- Top 5 diseases by patient count
SELECT disease_name, COUNT(*) AS patient_count
FROM reception
GROUP BY disease_name
ORDER BY patient_count DESC;

-- ======================================================
-- End of Phase V Validation Script
-- ======================================================
COMMIT;

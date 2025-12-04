# Patient-Disease-Tracking-Analytics-System-PDTAS-
healthcare data management and analytics system designed to monitor disease spread, treatment, and diagnostic activities across healthcare facilities.
🔵 Personal Information

Name: Humure Enock
Student ID: 27394
Program: Information Systems — Adventist University of Central Africa (AUCA)
Country: Rwanda
Role in Project: Database Designer, PL/SQL Developer, System Analyst
Project Title: Patient Disease Tracking & Analytics System (PDTAS)
Repository Scope: Phases I – V completed, Phase VI coming next.

🏥 Project Overview

The Patient Disease Tracking & Analytics System (PDTAS) is a healthcare database solution built with Oracle SQL & PL/SQL to help hospitals efficiently track:

Patient demographics

Disease diagnosis

Laboratory test outcomes

Treatment/medication history

Disease patterns and statistical trends

The project is designed following the official PL/SQL Capstone structure, ensuring proper modeling and strong BI (Business Intelligence) features for analytics and reporting.

🩺 Project Problem Statement

Many healthcare centers across Rwanda face challenges in:

Tracking patient disease history

Monitoring disease prevalence across time

Ensuring doctor and lab records align

Managing medical data spread across papers or unstructured systems

Extracting analytical insights for management and government reporting

This leads to:

Slow decision-making

Weak disease monitoring

Inaccurate medical statistics

Poor resource allocation

Difficulty supporting national health analytics

🎯 Key Objectives

The PDTAS project addresses these challenges through:

1️⃣ Centralized Medical Data Storage

Store all patient, diagnosis, lab, and treatment data in one structured Oracle database.

2️⃣ Consistent Disease Tracking

Record major diseases such as:
Malaria, HIV/AIDS, Stunting, Respiratory Infections, Diarrheal Diseases

classify other diseases automatically.

3️⃣ Enhanced BI & Reporting

Enable management to view:

Spread diseases

Trends over time

Patient categories

Testing frequency

Medication distribution

4️⃣ High Data Integrity

Enforce strict PKs, FKs, CHECK constraints, and validation logic.

5️⃣ PL/SQL Automation

Prepare for Phase VI (procedures, functions, packages, error handling, etc.)

💡 Key Innovation
✔ Automatic Disease Classification

If a patient reports a disease not found in main diseases, the system auto-moves it to other_diseases table, ensuring data accuracy and clean analytics.

✔ Analytics-Ready Schema

disease_stats acts as a fact table, while entities like reception, doctor, treatment, etc., act as dimensions—a BI-optimized design.

✔ Fully Normalized 3NF Database

No redundancy, no duplication, no anomalies.

✔ Realistic Rwandan Sample Data

Names and records reflect real demographic patterns.

🗂 Database Schema Summary
Core Tables
Table	Purpose
reception	Stores patient demographic information
doctor	Doctor diagnosis and medical notes
lab_technician	Lab tests and results
treatment	Medication, dosage, and treatment history
main_diseases	List of top critical diseases
other_diseases	Diseases not included in main diseases
disease_stats	Fact table for disease metrics and BI

📊 Entity Relationship Summary

One patient can have many diagnoses

One diagnosis can require multiple lab tests

Each patient can have multiple treatments

Diseases classified into main or other

disease_stats aggregates cross-department data

📁 Project Phases Completed
Phase	Deliverable
Phase I	Problem Statement + PPT
Phase II	BPMN Diagram + One-Page Documentation
Phase III	ERD + Data Dictionary + Assumptions
Phase IV	Oracle PDB + Tablespaces + User Setup
Phase V	Table Implementation + Inserts + Validation + Testing Queries

📌 Phase VI will be added next (procedures, functions, packages, and transactions).
# Phase I – Problem Identification

## 🎯 Objective
Identify a real-world healthcare problem requiring an Oracle PL/SQL solution with BI capabilities.

## 🩺 Problem Summary
Many hospitals struggle with tracking how diseases spread, how patients are diagnosed,
and what treatments are administered. The lack of centralized medical data leads to:

- Poor disease trend visibility
- Delayed treatment decisions
- Ineffective resource allocation
- Weak monitoring of critical diseases (Malaria, HIV/AIDS, etc.)

## 📌 Project Concept
The **Patient Disease Tracking & Analytics System (PDTAS)** stores:
- Reception/patient information
- Doctor diagnosis
- Lab test results
- Treatment/medication details
- Disease statistics over time

## 🎯 BI Potential
- Daily/weekly/monthly/yearly dashboards
- Heatmaps of most common diseases
- Lab results analytics
- Treatment performance insights

## 📄 Deliverable
- 4-slide PPT summarizing the project

  


# Phase II – Business Process Modeling

## 🎯 Objective
Model the flow of hospital activities from patient registration to treatment and analytics.

## 📌 Scope Identified
Includes:
- Reception registration
- Doctor diagnosis
- Laboratory testing
- Treatment & pharmacy
- Disease statistics generation

## 👥 Key Actors
- Receptionist
- Doctor
- Lab Technician
- Pharmacist
- Hospital Management

## 🧩 BPMN Features
- Swimlanes for departments
- Decision points (e.g., test requested? treatment required?)
- Data flow from one actor to another
- Start and end clearly marked

## 📄 Deliverables
- BPMN_Diagram.png
- One-page process explanation

# Phase III – Logical Database Design

## 🎯 Objective
Design a fully normalized (3NF) logical model for the system.

## 🏥 Entities Identified
- reception (patient info)
- doctor (diagnosis)
- lab_technician (lab tests)
- treatment (medication)
- main_diseases
- other_diseases
- disease_stats

## 🔐 Constraints
- PKs: Identity columns
- FKs: Proper relationships between patient, lab, doctor, and treatment
- UNIQUE: disease names
- CHECK: gender allowed values

## 🧬 Normalization
- All tables passed:
  - **1NF**: No repeating groups
  - **2NF**: All non-key attributes fully depend on PK
  - **3NF**: Removed transitive dependencies

## 📊 BI Considerations
Fact Table → disease_stats  
Dimensions → reception, main_diseases, doctor, treatment, lab_technician

## 📄 Deliverables
- ERD.png  
- Data dictionary
- Assumptions list

# Phase IV – Oracle Database Creation

## 🎯 Objective
Create a fully configured Oracle PDB for the PDTAS system.

## 🛠 Database Created
Name:
WED_27394_ENOCK_PDTAS_DB

Admin user:
patient_track

## 📁 Configuration Completed
- pdta_data tablespace
- pdta_temp temporary tablespace
- autoextend enabled
- archive log mode
- memory configurations reviewed

## 📄 Deliverables
- create_pdb.sql
- tablespace_config.sql
- create_admin_user.sql
- Phase summary documentation
# Phase V – Table Implementation & Data Insertion

## 🎯 Objective
Build the physical structure and populate it with realistic data.

## 📁 Tables Implemented
- reception
- doctor
- lab_technician
- treatment
- main_diseases
- other_diseases
- disease_stats

## 🔐 Constraints Enforced
- Primary keys
- Foreign keys
- NOT NULL constraints
- UNIQUE disease names
- CHECK constraints (gender)
- DEFAULT values

## 🧪 Data Inserted
- Rwandan realistic sample patient names
- Doctor & lab technician entries
- Disease statistics for reporting
- Main diseases populated
- Automatic handling for unknown diseases

## 🧩 Validation Completed
- PK & FK checks
- JOIN queries
- GROUP BY aggregations
- Subqueries
- Disease classification logic tested

## 📄 Deliverables
- create_tables.sql
- insert_data.sql
- validation_queries.sql
- testing_queries.sql

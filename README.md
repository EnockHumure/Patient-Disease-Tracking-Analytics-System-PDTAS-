# Patient-Disease-Tracking-Analytics-System-PDTAS-
healthcare data management and analytics system designed to monitor disease spread, treatment, and diagnostic activities across healthcare facilities.

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

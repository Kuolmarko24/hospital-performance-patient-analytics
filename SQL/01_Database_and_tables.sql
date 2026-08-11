USE HospitalAnalytics;
GO

-- =============================================
-- DATABASE AND SOURCE TABLE INSPECTION
-- =============================================

-- Inspect source tables
SELECT TOP 5 * FROM patients;
SELECT TOP 5 * FROM doctors;
SELECT TOP 5 * FROM appointments;
SELECT TOP 5 * FROM treatments;
SELECT TOP 5 * FROM billing;

-- Record counts
SELECT COUNT(*) AS TotalPatients
FROM patients;

SELECT COUNT(*) AS TotalDoctors
FROM doctors;

SELECT COUNT(*) AS TotalAppointments
FROM appointments;

SELECT COUNT(*) AS TotalTreatments
FROM treatments;

SELECT COUNT(*) AS TotalBills
FROM billing;


-- =============================================
-- CREATE CLEANED/BACKUP TABLES
-- =============================================

SELECT *
INTO patients_cleaned
FROM patients;

SELECT *
INTO doctors_cleaned
FROM doctors;

SELECT *
INTO appointments_cleaned
FROM appointments;

SELECT *
INTO treatment_cleaned
FROM treatments;

SELECT *
INTO billing_cleaned
FROM billing;
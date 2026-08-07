USE HospitalAnalytics

SELECT TOP 5 * FROM patients;
SELECT TOP 5 * FROM doctors;
SELECT TOP 5 * FROM appointments;
SELECT TOP 5 * FROM treatments
SELECT TOP 5 * FROM billing;

SELECT COUNT(*) FROM patients;
SELECT * FROM patients;
SELECT patient_id, COUNT(*) AS Total FROM patients
GROUP BY patient_id

-- DATA CLEANING FOR PATIENT_CLEANED TABLE ----
-- When performing Data Cleaning Process,
-- First Create backup tables e.g. patients_cleaned, doctors_cleaned, appointments_cleaned and billing_cleaned 
SELECT * INTO patients_cleaned FROM patients;
SELECT * INTO doctors_cleaned FROM doctors;
SELECT * INTO appointments_cleaned FROM appointments;
SELECT * INTO treatment_cleaned FROM treatments;
SELECT * INTO billing_cleaned FROM billing;

-- Confirm how many rows exist
SELECT COUNT(*) AS TotalPatients from patients_cleaned;
SELECT COUNT(*) AS TotalDoctors from doctors_cleaned;
SELECT COUNT(*) AS TotalAppointments from appointments;
SELECT COUNT(*) AS TotalTreatments from treatment_cleaned;
SELECT COUNT(*) AS Totalbilling from billing_cleaned;

-- Inspect the data 
SELECT TOP 10 * FROM patients_cleaned;

-- Check Data Types
EXEC sp_help patients_cleaned;

-- Check duplicate primary keys
SELECT patient_id, COUNT(*) AS Total FROM patients_cleaned
GROUP BY patient_id
HAVING COUNT(*)>1;

-- check missing values
SELECT 
	COUNT(CASE WHEN patient_id is NULL THEN 1 END) AS MissingPatientID,
	COUNT(CASE WHEN first_name is NULL THEN 1 END) AS MissingFirstName,
	COUNT(CASE WHEN last_name is NULL THEN 1 END) AS MissingLastName,
	COUNT(CASE WHEN gender is NULL THEN 1 END) AS MissingGender,
	COUNT(CASE WHEN date_of_birth is NULL THEN 1 END) AS MissingDateofBirth,
	COUNT(CASE WHEN contact_number is NULL THEN 1 END) AS MissingContactNumber,
	COUNT(CASE WHEN registration_date is NULL THEN 1 END) AS MissingRegistrationDate,
	COUNT(CASE WHEN insurance_provider is NULL THEN 1 END) AS MissingInsuranceProvider,
	COUNT(CASE WHEN insurance_number is NULL THEN 1 END) AS MissingInsuranceNumber,
	COUNT(CASE WHEN email is NULL THEN 1 END) AS MissingEmail
FROM patients_cleaned;

-- NB: when you execute the above code all values return 0, then that is a good sign

-- Check for blank spaces
SELECT * FROM patients
WHERE 
	TRIM(first_name) = ''
	OR TRIM(last_name) = ''
	OR TRIM(gender) = ''
	OR TRIM(insurance_provider) ='';

-- Check for duplicate emails
SELECT email, COUNT(*) AS Total
FROM patients_cleaned
GROUP BY email
HAVING COUNT(*) > 1;

-- Standardize gender
SELECT DISTINCT gender
FROM patients_cleaned


UPDATE patients_cleaned 
SET gender =
CASE 
	WHEN UPPER(gender)='M' THEN 'Male'
	WHEN UPPER(gender)='F' THEN 'Female'
	ELSE gender
END;

/*UPDATE patients_cleaned 
SET gender = 'Male'
WHERE patient_id = 'P001';*/

-- Validate dates, no patient should register before they are born
SELECT * FROM patients
WHERE registration_date < date_of_birth;

-- No patient should have a future registration
SELECT * FROM patients
WHERE registration_date > GETDATE();

-- Calculate patient age
SELECT * FROM patients_cleaned;
SELECT 
patient_id,
first_name,
last_name,
DATEDIFF(YEAR, date_of_birth, GETDATE()) AS Age
FROM patients_cleaned;

-- Check for duplicate phone numbers
SELECT * FROM patients_cleaned;
SELECT 
	contact_number, 
	COUNT(*) AS Total
FROM patients_cleaned
GROUP BY contact_number
HAVING COUNT(*)>1

-- Check the length
SELECT
	patient_id,
	contact_number,
	LEN(contact_number) AS PhoneLength
FROM patients_cleaned;

-- Check Insurance providers
SELECT distinct insurance_provider
FROM patients_cleaned;

-- Validate email format
SELECT * FROM patients_cleaned
WHERE email NOT LIKE '%@%.%'

SELECT
    patient_id,
    first_name,
    last_name,
    gender,
    date_of_birth,
    email
FROM patients_cleaned
WHERE email IN
(
    SELECT email
    FROM patients_cleaned
    GROUP BY email
    HAVING COUNT(*) > 1
)
ORDER BY email;

-- ensure there are no impossible ages 
SELECT
    patient_id,
    first_name,
    last_name,
    date_of_birth,
    DATEDIFF(YEAR, date_of_birth, GETDATE()) AS Age
FROM patients_cleaned
ORDER BY Age DESC;


-- duplicate emails
SELECT
    patient_id,
    first_name,
    last_name,
    date_of_birth,
    email
FROM patients_cleaned
WHERE email IN
(
    SELECT email
    FROM patients_cleaned
    GROUP BY email
    HAVING COUNT(*) > 1
)
ORDER BY email, date_of_birth;

-- referential integrity
SELECT a.patient_id
FROM appointments_cleaned a
LEFT JOIN patients_cleaned p
    ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;
--- END OF PATIENT_CLEANED ---

--- DATA CLEANING FOR DOCTOR'S TABLE ---
-- Total number of doctors
SELECT COUNT(*) AS TotalDoctors
FROM doctors_cleaned;

-- checking for duplicate IDs
SELECT 
doctor_id,
COUNT(*) AS Total
FROM doctors_cleaned
GROUP BY doctor_id
HAVING COUNT(*)>1;

-- Checking for Missing values
SELECT * FROM doctors_cleaned;
SELECT 
	COUNT(CASE WHEN doctor_id IS NULL THEN 1 END) AS MissingDoctorID,
	COUNT(CASE WHEN first_name IS NULL THEN 1 END) AS MissingFirstName,
	COUNT(CASE WHEN last_name IS NULL THEN 1 END) AS MissingLastName,
	COUNT(CASE WHEN specialization IS NULL THEN 1 END) AS MissingSpecialisation,
	COUNT(CASE WHEN phone_number IS NULL THEN 1 END) AS MissingPhone,
	COUNT(CASE WHEN years_experience IS NULL THEN 1 END) AS MissingYearsExperience,
	COUNT(CASE WHEN hospital_branch IS NULL THEN 1 END) AS MissingHospitalbranch,
	COUNT(CASE WHEN email IS NULL THEN 1 END) AS MissingEmail
FROM doctors_cleaned;

-- checking for duplicate emails
SELECT 
	email,
	COUNT(*) AS Total
FROM doctors_cleaned
GROUP BY email
HAVING COUNT(*)>1;

-- checking for duplicate phone numbers
SELECT * FROM doctors_cleaned;
SELECT 
	phone_number,
	COUNT(*) AS Total
FROM doctors_cleaned
GROUP BY phone_number
HAVING COUNT(*)>1;

-- Specialisations
SELECT DISTINCT specialization 
FROM doctors_cleaned;

-- hospital branch
SELECT DISTINCT hospital_branch 
FROM doctors_cleaned;

-- Years of experience
SELECT 
	doctor_id,
	first_name,
	last_name,
	years_experience
FROM doctors_cleaned
ORDER BY years_experience DESC;

/*
We need to confirm that every doctor assigned to an
appointment actually exists in the doctors table.
*/

SELECT a.doctor_id
FROM appointments_cleaned a
LEFT JOIN doctors_cleaned d
ON a.doctor_id = d.doctor_id
WHERE d.doctor_id IS NULL;

-- how doctors are distributed by specialisation
SELECT
specialization,
COUNT(*) AS TotalDoctors
FROM doctors_cleaned
GROUP BY specialization;

--- END OF DATA CLEANING FOR DOCTOR'S TABLE ---

-- DATA CLEANING FOR APPOINTMENTS_CLEANED -- 

-- Record Count
SELECT 
	COUNT(*) AS TotalAppointments 
FROM appointments_cleaned;

-- duplicate appointments IDs
SELECT 
appointment_id,
COUNT(*) AS Total
FROM appointments_cleaned
GROUP BY appointment_id
HAVING COUNT(*)>1;

-- missing values
SELECT
COUNT(CASE WHEN appointment_id IS NULL THEN 1 END) AS MissingAppointmentID,
COUNT(CASE WHEN patient_id IS NULL THEN 1 END) AS MissingPatientID,
COUNT(CASE WHEN doctor_id IS NULL THEN 1 END) AS MissingDoctorID,
COUNT(CASE WHEN appointment_date IS NULL THEN 1 END) AS MissingDate,
COUNT(CASE WHEN appointment_time IS NULL THEN 1 END) AS MissingTime,
COUNT(CASE WHEN reason_for_visit IS NULL THEN 1 END) AS MissingReason,
COUNT(CASE WHEN status IS NULL THEN 1 END) AS MissingStatus
FROM appointments_cleaned;

-- Appointment Status
SELECT
status,
COUNT(*) AS Total
FROM appointments_cleaned
GROUP BY status;

-- reasons for visit
SELECT 
	reason_for_visit,
	COUNT(*) AS Total 
FROM appointments_cleaned
GROUP BY reason_for_visit
ORDER BY Total DESC

-- Check for future appointments relative to today's date
SELECT * 
FROM appointments_cleaned
WHERE appointment_date>GETDATE();

-- Appointment times: Let's understand the operating hours 
SELECT
CAST(ROUND(MIN(appointment_time),2) AS DECIMAL(10,2)) AS EarliestAppointment,
CAST(ROUND(MAX(appointment_time),2) AS DECIMAL(10,2)) AS LatestAppointment
FROM appointments_cleaned;

/*
Referential Integrity: 
Even though we already verified patients and doctors separately, 
we'll document both checks as part of the appointments table cleaning:
*/
-- Patient check
SELECT a.patient_id
FROM appointments_cleaned a
LEFT JOIN patients_cleaned p
ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

-- Doctor check
SELECT a.doctor_id
FROM appointments_cleaned a
LEFT JOIN doctors_cleaned d
ON a.doctor_id = d.doctor_id
WHERE d.doctor_id IS NULL;
-- END OF DATA CLEANING FOR APPOINTMENTS_CLEANED -- 


-- DATA CLEANING FOR TREATMENT_CLEANED TABLE --

-- Record Count 
SELECT COUNT(*) AS TotalTreatments 
FROM treatment_cleaned;

-- Duplicate treatment IDs
SELECT 
	treatment_id,
	COUNT(*) AS Total
FROM treatment_cleaned
GROUP BY treatment_id
HAVING COUNT(*)>1;

-- Missing values
SELECT
COUNT(CASE WHEN treatment_id IS NULL THEN 1 END) AS MissingTreatmentID,
COUNT(CASE WHEN appointment_id IS NULL THEN 1 END) AS MissingAppointmentID,
COUNT(CASE WHEN treatment_type IS NULL THEN 1 END) AS MissingTreatmentType,
COUNT(CASE WHEN description IS NULL THEN 1 END) AS MissingDescription,
COUNT(CASE WHEN cost IS NULL THEN 1 END) AS MissingCost,
COUNT(CASE WHEN treatment_date IS NULL THEN 1 END) AS MissingTreatmentDate
FROM treatment_cleaned;

-- Treatment types
SELECT 
	treatment_type,
	COUNT(*) AS Total 
FROM treatment_cleaned
GROUP BY treatment_type
ORDER BY Total DESC;

-- Treatment descriptions
SELECT
description,
COUNT(*) AS Total
FROM treatment_cleaned
GROUP BY description;

-- Cost validation
SELECT
    CAST(ROUND(MIN(cost),2) AS DECIMAL(10,2)) AS MinimumCost,
    CAST(ROUND(MAX(cost),2) AS DECIMAL(10,2)) AS MaximumCost,
    CAST(ROUND(AVG(cost),2) AS DECIMAL(10,2)) AS AverageCost
FROM treatment_cleaned;

-- check for invalid values
SELECT *
FROM treatment_cleaned
WHERE cost <= 0;

-- treatment dates
SELECT *
FROM treatment_cleaned
WHERE treatment_date > GETDATE();

-- referential integrity
SELECT t.appointment_id
FROM treatment_cleaned t
LEFT JOIN appointments_cleaned a
ON t.appointment_id = a.appointment_id
WHERE a.appointment_id IS NULL;

-- END OF DATA CLEANING FOR TREATMENT_CLEANED TABLE --

-- DATA CLEANING FOR BILLING_CLEANED TABLE --
-- Record Count
SELECT COUNT(*) AS TotalBills
FROM billing_cleaned;

-- Checking for Duplicate bills IDs
SELECT 
bill_id,
COUNT(*) AS Total 
FROM billing_cleaned
GROUP BY bill_id
HAVING COUNT(*)>1

-- Checking for missing values
SELECT
	COUNT(CASE WHEN bill_id IS NULL THEN 1 END) AS MissingBillID,
	COUNT(CASE WHEN patient_id IS NULL THEN 1 END) AS MissingPatientID,
	COUNT(CASE WHEN treatment_id IS NULL THEN 1 END) AS MissingTreatmentID,
	COUNT(CASE WHEN bill_date IS NULL THEN 1 END) AS MissingBillDate,
	COUNT(CASE WHEN amount IS NULL THEN 1 END) AS MissingAmount,
	COUNT(CASE WHEN payment_method IS NULL THEN 1 END) AS MissingPaymentMethod,
	COUNT(CASE WHEN payment_status IS NULL THEN 1 END) AS MissingPaymentStatus
FROM billing_cleaned;

-- Payment methods
SELECT
payment_method,
COUNT(*) AS Total
FROM billing_cleaned
GROUP BY payment_method;

-- payment status
SELECT
payment_status,
COUNT(*) AS Total
FROM billing_cleaned
GROUP BY payment_status;

-- billing amount validation
SELECT
	CAST(ROUND(MIN(amount),2) AS DECIMAL(10,2)) AS MinimumBill,
	CAST(ROUND(MAX(amount),2) AS DECIMAL(10,2)) AS MaximumBill,
	CAST(ROUND(AVG(amount),2) AS DECIMAL(10,2)) AS AverageBill
FROM billing_cleaned;

-- invalid billing amounts
SELECT *
FROM billing_cleaned
WHERE amount <= 0;

-- future bill dates
SELECT *
FROM billing_cleaned
WHERE bill_date > GETDATE();

-- referential integrity
SELECT b.treatment_id
FROM billing_cleaned b
LEFT JOIN treatment_cleaned t
ON b.treatment_id = t.treatment_id
WHERE t.treatment_id IS NULL;

-- verify if every billed patient exists
SELECT b.patient_id
FROM billing_cleaned b
LEFT JOIN patients_cleaned p
ON b.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

-- END OF DATA CLEANING FOR BILLING_CLEANED TABLE --

-- PHASE 2: EXPLORATORY DATA ANALYSIS --
-- Section 1: Executive Overview

-- Total Patients
SELECT COUNT(*) AS TotalPatients
FROM patients_cleaned;

-- Total Doctors
SELECT COUNT(*) AS TotalDoctors
FROM doctors_cleaned;

-- Total Appointments
SELECT COUNT(*) AS TotalAppointments
FROM appointments_cleaned;

-- Total Treatments
SELECT COUNT(*) AS TotalTreatments
FROM treatment_cleaned;

-- Total Revenue
SELECT CAST(ROUND(SUM(amount),2) AS DECIMAL(10,2)) AS TotalRevenue
FROM billing_cleaned;

-- Average Bill
SELECT  CAST(ROUND(AVG(amount),2) AS DECIMAL(10,2)) as AverageBill
FROM billing_cleaned;

-- 
-- END OF EXPLORATORY DATA ANALYSIS --

-- Patient's Analytics
-- Who are the Hospital's patients?
-- Gender distribution
SELECT 
	gender,
	COUNT(*) AS TotalPatients
FROM patients_cleaned
GROUP BY gender;

-- patients by insurance provider
SELECT 
	insurance_provider,
	COUNT(*) AS TotalPatients
FROM patients_cleaned
GROUP BY insurance_provider
ORDER BY TotalPatients DESC;

-- Patient Age Groups
SELECT
CASE
    WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 30 THEN 'Under 30'
    WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 30 AND 39 THEN '30-39'
    WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 40 AND 49 THEN '40-49'
    WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 50 AND 59 THEN '50-59'
    ELSE '60+'
END AS AgeGroup,
COUNT(*) AS TotalPatients
FROM patients_cleaned
GROUP BY
CASE
    WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 30 THEN 'Under 30'
    WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 30 AND 39 THEN '30-39'
    WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 40 AND 49 THEN '40-49'
    WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 50 AND 59 THEN '50-59'
    ELSE '60+'
END
ORDER BY AgeGroup;

-- Doctor Performance Analytics
-- WHich Doctors and hospital departments are handling the most work?

-- Appointments per doctor
SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.specialization,
    COUNT(a.appointment_id) AS TotalAppointments
FROM doctors_cleaned d
LEFT JOIN appointments_cleaned a
    ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.specialization
ORDER BY TotalAppointments DESC;

-- Appointments by specialisation
SELECT
    d.specialization,
    COUNT(a.appointment_id) AS TotalAppointments
FROM doctors_cleaned d
JOIN appointments_cleaned a
    ON d.doctor_id = a.doctor_id
GROUP BY d.specialization
ORDER BY TotalAppointments DESC;

-- Appointments by Hospital branch
SELECT
    d.hospital_branch,
    COUNT(a.appointment_id) AS TotalAppointments
FROM doctors_cleaned d
JOIN appointments_cleaned a
    ON d.doctor_id = a.doctor_id
GROUP BY d.hospital_branch
ORDER BY TotalAppointments DESC;


-- Appointment Analytics
-- Appointment status distribution
SELECT
    status,
    COUNT(*) AS TotalAppointments,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),2) AS DECIMAL(10,2)) AS Percentage
FROM appointments_cleaned
GROUP BY status
ORDER BY TotalAppointments DESC;

-- Most common reasons for visit
SELECT
    reason_for_visit,
    COUNT(*) AS TotalAppointments,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),2) AS DECIMAL(10,2)) AS Percentage
FROM appointments_cleaned
GROUP BY reason_for_visit
ORDER BY TotalAppointments DESC;

-- Monthly appointment trend
SELECT
    DATENAME(MONTH, appointment_date) AS MonthName,
    MONTH(appointment_date) AS MonthNumber,
    COUNT(*) AS TotalAppointments
FROM appointments_cleaned
GROUP BY
    DATENAME(MONTH, appointment_date),
    MONTH(appointment_date)
ORDER BY MonthNumber;

-- busiest day of the week
SELECT
    DATENAME(WEEKDAY, appointment_date) AS WeekDay,
    COUNT(*) AS TotalAppointments
FROM appointments_cleaned
GROUP BY DATENAME(WEEKDAY, appointment_date)
ORDER BY TotalAppointments DESC;

-- peak appointment hours
SELECT
    DATEPART(HOUR, appointment_time) AS AppointmentHour,
    COUNT(*) AS TotalAppointments
FROM appointments_cleaned
GROUP BY DATEPART(HOUR, appointment_time)
ORDER BY AppointmentHour;

-- Doctor no show analysis
SELECT
    d.first_name + ' ' + d.last_name AS Doctor,
    COUNT(*) AS NoShows
FROM appointments_cleaned a
JOIN doctors_cleaned d
    ON a.doctor_id = d.doctor_id
WHERE status = 'No-show'
GROUP BY
    d.first_name,
    d.last_name
ORDER BY NoShows DESC;

-- Cancellation analysis
SELECT
    d.specialization,
    COUNT(*) AS CancelledAppointments
FROM appointments_cleaned a
JOIN doctors_cleaned d
ON a.doctor_id = d.doctor_id
WHERE status='Cancelled'
GROUP BY d.specialization
ORDER BY CancelledAppointments DESC;

-- Treatment and Revenue Aanalytics
-- Revenue by treatment type
SELECT
    t.treatment_type,
    COUNT(*) AS TotalTreatments,
    CAST(ROUND(SUM(b.amount),2) AS DECIMAL(10,2)) AS TotalRevenue,
    CAST(ROUND(AVG(b.amount),2) AS DECIMAL(10,2)) AS AverageRevenue
FROM treatment_cleaned t
JOIN billing_cleaned b
ON t.treatment_id = b.treatment_id
GROUP BY t.treatment_type
ORDER BY TotalRevenue DESC;

-- Average cost by treatment type 
SELECT
    treatment_type,
    COUNT(*) AS TotalTreatments,
    CAST(ROUND(AVG(cost),2) AS DECIMAL(10,2)) AS AverageCost,
    CAST(ROUND(MIN(cost),2) AS DECIMAL(10,2)) AS MinimumCost,
    CAST(ROUND(MAX(cost),2) AS DECIMAL(10,2)) AS MaximumCost
FROM treatment_cleaned
GROUP BY treatment_type
ORDER BY AverageCost DESC;

-- Revenue by doctor
SELECT
    d.first_name + ' ' + d.last_name AS Doctor,
    d.specialization,
    COUNT(DISTINCT a.appointment_id) AS TotalAppointments,
    CAST(ROUND(SUM(b.amount),2) AS DECIMAL(10,2)) AS TotalRevenue
FROM doctors_cleaned d
JOIN appointments_cleaned a
    ON d.doctor_id = a.doctor_id
JOIN treatment_cleaned t
    ON a.appointment_id = t.appointment_id
JOIN billing_cleaned b
    ON t.treatment_id = b.treatment_id
GROUP BY
    d.first_name,
    d.last_name,
    d.specialization
ORDER BY TotalRevenue DESC;

-- Revenue by specialisation 
SELECT
    d.specialization,
    COUNT(*) AS TotalTreatments,
    CAST(ROUND(SUM(b.amount),2) AS DECIMAL(10,2)) AS TotalRevenue,
    CAST(ROUND(AVG(b.amount),2) AS DECIMAL(10,2)) AS AverageRevenue
FROM doctors_cleaned d
JOIN appointments_cleaned a
ON d.doctor_id = a.doctor_id
JOIN treatment_cleaned t
ON a.appointment_id = t.appointment_id
JOIN billing_cleaned b
ON t.treatment_id = b.treatment_id
GROUP BY d.specialization
ORDER BY TotalRevenue DESC;

-- Revenue by Hospital branch
SELECT
    d.hospital_branch,
    COUNT(*) AS TotalTreatments,
    CAST(ROUND(SUM(b.amount),2) AS DECIMAL(10,2)) AS TotalRevenue
FROM doctors_cleaned d
JOIN appointments_cleaned a
ON d.doctor_id = a.doctor_id
JOIN treatment_cleaned t
ON a.appointment_id = t.appointment_id
JOIN billing_cleaned b
ON t.treatment_id = b.treatment_id
GROUP BY d.hospital_branch
ORDER BY TotalRevenue DESC;

-- Revenue by payment method
SELECT
    payment_method,
    COUNT(*) AS TotalBills,
    CAST(ROUND(SUM(amount),2) AS DECIMAL(10,2)) AS TotalRevenue,
    CAST(ROUND(AVG(amount),2) AS DECIMAL(10,2)) AS AverageBill
FROM billing_cleaned
GROUP BY payment_method
ORDER BY TotalRevenue DESC;

-- Revenue by insurance provider
SELECT
    p.insurance_provider,
    COUNT(*) AS TotalBills,
    CAST(ROUND(SUM(b.amount),2) AS DECIMAL(10,2)) AS TotalRevenue,
    CAST(ROUND(AVG(b.amount),2) AS DECIMAL(10,2)) AS AverageBill
FROM patients_cleaned p
JOIN billing_cleaned b
ON p.patient_id = b.patient_id
GROUP BY p.insurance_provider
ORDER BY TotalRevenue DESC;

-- Highest revenue treatments
SELECT TOP 10
    t.treatment_type,
    b.amount
FROM treatment_cleaned t
JOIN billing_cleaned b
ON t.treatment_id = b.treatment_id
ORDER BY b.amount DESC;

-- Executive analytics
-- which doctor generates the highest revenue per appointment?
SELECT
    d.first_name + ' ' + d.last_name AS Doctor,
    d.specialization,
    COUNT(DISTINCT a.appointment_id) AS TotalAppointments,
    CAST(ROUND(SUM(b.amount),2) AS DECIMAL(12,2)) AS TotalRevenue,
    CAST(ROUND(SUM(b.amount) * 1.0 /
        COUNT(DISTINCT a.appointment_id),2) AS DECIMAL(10,2))
        AS RevenuePerAppointment
FROM doctors_cleaned d
JOIN appointments_cleaned a
    ON d.doctor_id = a.doctor_id
JOIN treatment_cleaned t
    ON a.appointment_id = t.appointment_id
JOIN billing_cleaned b
    ON t.treatment_id = b.treatment_id
GROUP BY
    d.first_name,
    d.last_name,
    d.specialization
ORDER BY RevenuePerAppointment DESC;

-- appointment completion rate by specialisation
SELECT
    d.specialization,
    COUNT(*) AS TotalAppointments,
    SUM(CASE
            WHEN a.status='Completed'
            THEN 1 ELSE 0
        END) AS CompletedAppointments,
    CAST(
        ROUND(
            100.0 *
            SUM(CASE WHEN a.status='Completed'
                THEN 1 ELSE 0 END)
            / COUNT(*),2)
        AS DECIMAL(5,2))
        AS CompletionRate
FROM appointments_cleaned a
JOIN doctors_cleaned d
ON a.doctor_id=d.doctor_id
GROUP BY d.specialization
ORDER BY CompletionRate DESC;

-- No show rate by doctor
-- which doctors experience the highest patient no show rate?
SELECT
    d.first_name + ' ' + d.last_name AS Doctor,
    COUNT(*) AS TotalAppointments,
    SUM(CASE
        WHEN status='No-show'
        THEN 1 ELSE 0 END) AS NoShows,
    CAST(
        ROUND(
        100.0*
        SUM(CASE
        WHEN status='No-show'
        THEN 1 ELSE 0 END)
        /COUNT(*),2)
        AS DECIMAL(5,2))
        AS NoShowRate
FROM doctors_cleaned d
JOIN appointments_cleaned a
ON d.doctor_id=a.doctor_id
GROUP BY
d.first_name,
d.last_name
ORDER BY NoShowRate DESC;

-- Average Revenue by insurance provider
-- Which insurance provider contributes the highest value patients?
SELECT
    p.insurance_provider,
    COUNT(*) AS Bills,
    CAST(ROUND(SUM(b.amount),2) AS DECIMAL(12,2))
        AS TotalRevenue,
    CAST(ROUND(AVG(b.amount),2) AS DECIMAL(10,2))
        AS AverageBill
FROM patients_cleaned p
JOIN billing_cleaned b
ON p.patient_id=b.patient_id
GROUP BY p.insurance_provider
ORDER BY AverageBill DESC;

-- Monthly revenue trend
-- which month generates the highest revenue?
SELECT
    DATENAME(MONTH,b.bill_date) AS MonthName,
    MONTH(b.bill_date) AS MonthNumber,
    CAST(ROUND(SUM(b.amount),2) AS DECIMAL(12,2))
        AS Revenue
FROM billing_cleaned b
GROUP BY
DATENAME(MONTH,b.bill_date),
MONTH(b.bill_date)
ORDER BY MonthNumber;

-- branch efficiency
-- which branch generates the highest revenue per appointment?
SELECT
    d.hospital_branch,
    COUNT(DISTINCT a.appointment_id) AS Appointments,
    CAST(ROUND(SUM(b.amount),2) AS DECIMAL(12,2))
        AS Revenue,
    CAST(
        ROUND(
        SUM(b.amount)
        /
        COUNT(DISTINCT a.appointment_id),2)
        AS DECIMAL(10,2))
        AS RevenuePerAppointment
FROM doctors_cleaned d
JOIN appointments_cleaned a
ON d.doctor_id=a.doctor_id
JOIN treatment_cleaned t
ON a.appointment_id=t.appointment_id
JOIN billing_cleaned b
ON t.treatment_id=b.treatment_id
GROUP BY d.hospital_branch
ORDER BY RevenuePerAppointment DESC;


-- Highest value patients
-- which patients contribute the most revenue?
SELECT TOP 5
    p.patient_id,
    p.first_name,
    p.last_name,
    p.insurance_provider,
    COUNT(b.bill_id) AS TotalBills,
    CAST(ROUND(SUM(b.amount),2) AS DECIMAL(12,2))
        AS LifetimeRevenue
FROM patients_cleaned p
JOIN billing_cleaned b
ON p.patient_id=b.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name,
    p.insurance_provider
ORDER BY LifetimeRevenue DESC;

-- Ranking doctors using a window function
SELECT
    d.first_name + ' ' + d.last_name AS Doctor,
    d.specialization,
    CAST(ROUND(SUM(b.amount),2) AS DECIMAL(12,2))
        AS Revenue,
    RANK() OVER(
        ORDER BY SUM(b.amount) DESC
    ) AS RevenueRank
FROM doctors_cleaned d
JOIN appointments_cleaned a
ON d.doctor_id=a.doctor_id
JOIN treatment_cleaned t
ON a.appointment_id=t.appointment_id
JOIN billing_cleaned b
ON t.treatment_id=b.treatment_id
GROUP BY
d.first_name,
d.last_name,
d.specialization;

-- views --
-- view for the patient
CREATE VIEW vw_patient_demographics AS 
SELECT
	patient_id,
	first_name,
	last_name,
	gender,
	date_of_birth,
	insurance_provider
FROM patients_cleaned;

ALTER VIEW vw_patient_demographics AS
SELECT
    patient_id,
    first_name,
    last_name,
    gender,
    date_of_birth,

    DATEDIFF(YEAR, date_of_birth, GETDATE()) AS Age,

    CASE
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 30 THEN 'Under 30'
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 40 THEN '30-39'
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 50 THEN '40-49'
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 60 THEN '50-59'
        ELSE '60+'
    END AS Age_Group,

    CASE
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 30 THEN 1
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 40 THEN 2
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 50 THEN 3
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 60 THEN 4
        ELSE 5
    END AS Age_Group_Sort,

    registration_date,
    insurance_provider,
    insurance_number,
    contact_number,
    address,
    email
FROM patients_cleaned;

SELECT TOP 5 *
FROM vw_patient_demographics;

-- view for the doctor
CREATE VIEW vw_doctor_information AS
SELECT 
doctor_id,
first_name,
last_name,
specialization,
years_experience,
hospital_branch,
phone_number,
email
FROM doctors_cleaned;

-- view for appointment
CREATE VIEW vw_appointment_details AS
SELECT
    a.appointment_id,
    a.patient_id,
    p.first_name + ' ' + p.last_name AS PatientName,
    a.doctor_id,
    d.first_name + ' ' + d.last_name AS DoctorName,
    d.specialization,
    d.hospital_branch,
    a.appointment_date,
    a.appointment_time,
    a.reason_for_visit,
    a.status
FROM appointments_cleaned a
INNER JOIN patients_cleaned p
    ON a.patient_id = p.patient_id
INNER JOIN doctors_cleaned d
    ON a.doctor_id = d.doctor_id;

-- treatment analytics view --
CREATE VIEW vw_treatment_analytics AS
SELECT
    t.treatment_id,
    t.appointment_id,
    a.patient_id,
    p.first_name + ' ' + p.last_name AS PatientName,
    a.doctor_id,
    d.first_name + ' ' + d.last_name AS DoctorName,
    d.specialization,
    d.hospital_branch,
    t.treatment_type,
    t.description,
    t.cost,
    t.treatment_date
FROM treatment_cleaned t
INNER JOIN appointments_cleaned a
    ON t.appointment_id = a.appointment_id
INNER JOIN patients_cleaned p
    ON a.patient_id = p.patient_id
INNER JOIN doctors_cleaned d
    ON a.doctor_id = d.doctor_id;

-- billing and revenue view --
CREATE VIEW vw_billing_revenue AS
SELECT
    b.bill_id,
    b.patient_id,
    p.first_name + ' ' + p.last_name AS PatientName,
    p.insurance_provider,
    b.treatment_id,
    t.treatment_type,
    b.bill_date,
    b.amount,
    b.payment_method,
    b.payment_status
FROM billing_cleaned b
INNER JOIN patients_cleaned p
    ON b.patient_id = p.patient_id
INNER JOIN treatment_cleaned t
    ON b.treatment_id = t.treatment_id;

-- executive dashboard View --
CREATE VIEW vw_executive_dashboard AS
SELECT
    p.patient_id,
    p.first_name + ' ' + p.last_name AS PatientName,
    p.gender,
    p.insurance_provider,

    d.doctor_id,
    d.first_name + ' ' + d.last_name AS DoctorName,
    d.specialization,
    d.hospital_branch,
    d.years_experience,

    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    a.reason_for_visit,
    a.status,

    t.treatment_id,
    t.treatment_type,
    t.description,
    t.cost,

    b.bill_id,
    b.amount,
    b.payment_method,
    b.payment_status

FROM patients_cleaned p
INNER JOIN appointments_cleaned a
    ON p.patient_id = a.patient_id
INNER JOIN doctors_cleaned d
    ON a.doctor_id = d.doctor_id
INNER JOIN treatment_cleaned t
    ON a.appointment_id = t.appointment_id
INNER JOIN billing_cleaned b
    ON t.treatment_id = b.treatment_id;

-- end of views --
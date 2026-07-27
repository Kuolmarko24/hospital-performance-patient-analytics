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


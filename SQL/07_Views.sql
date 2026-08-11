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
ALTER VIEW vw_executive_dashboard AS
SELECT
    -- =========================
    -- PATIENT INFORMATION
    -- =========================
    p.patient_id,
    p.first_name + ' ' + p.last_name AS PatientName,
    p.gender,
    p.insurance_provider,

    -- =========================
    -- DOCTOR INFORMATION
    -- =========================
    d.doctor_id,
    d.first_name + ' ' + d.last_name AS DoctorName,
    d.specialization,
    d.hospital_branch,
    d.years_experience,

    -- =========================
    -- APPOINTMENT INFORMATION
    -- =========================
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    a.reason_for_visit,
    a.status,

    -- Appointment date attributes
    YEAR(a.appointment_date) AS Appointment_Year,
    DATEPART(QUARTER, a.appointment_date) AS Appointment_Quarter,
    DATENAME(MONTH, a.appointment_date) AS Appointment_Month,
    MONTH(a.appointment_date) AS Appointment_Month_Number,
    DATENAME(WEEKDAY, a.appointment_date) AS Appointment_Day,
    DATEPART(WEEKDAY, a.appointment_date) AS Appointment_Day_Number,

    -- Appointment hour
    DATEPART(HOUR, a.appointment_time) AS Appointment_Hour,

    -- =========================
    -- TREATMENT INFORMATION
    -- =========================
    t.treatment_id,
    t.treatment_type,
    t.description,
    t.cost,
    t.treatment_date,

    -- Treatment date attributes
    YEAR(t.treatment_date) AS Treatment_Year,
    DATEPART(QUARTER, t.treatment_date) AS Treatment_Quarter,
    DATENAME(MONTH, t.treatment_date) AS Treatment_Month,
    MONTH(t.treatment_date) AS Treatment_Month_Number,

    -- =========================
    -- BILLING INFORMATION
    -- =========================
    b.bill_id,
    b.bill_date,
    b.amount,
    b.payment_method,
    b.payment_status,

    -- Billing date attributes
    YEAR(b.bill_date) AS Bill_Year,
    DATEPART(QUARTER, b.bill_date) AS Bill_Quarter,
    DATENAME(MONTH, b.bill_date) AS Bill_Month,
    MONTH(b.bill_date) AS Bill_Month_Number

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
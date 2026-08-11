USE HospitalAnalytics;
GO

-- =============================================
-- PATIENT & CLINICAL ANALYTICS
-- =============================================

-- Patient's Analytics
-- Who are the Hospital's patients?

-- Gender distribution
SELECT 
    gender,
    COUNT(*) AS TotalPatients
FROM patients_cleaned
GROUP BY gender;


-- Patients by insurance provider
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


-- =============================================
-- DOCTOR PERFORMANCE ANALYTICS
-- =============================================

-- Which Doctors and hospital departments are handling the most work?

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
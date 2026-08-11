USE HospitalAnalytics;
GO

-- =============================================
-- EXECUTIVE ANALYTICS
-- =============================================

-- Which doctor generates the highest revenue per appointment?
SELECT
    d.first_name + ' ' + d.last_name AS Doctor,
    d.specialization,
    COUNT(DISTINCT a.appointment_id) AS TotalAppointments,
    CAST(
        ROUND(SUM(b.amount),2)
        AS DECIMAL(12,2)
    ) AS TotalRevenue,
    CAST(
        ROUND(
            SUM(b.amount) * 1.0 /
            COUNT(DISTINCT a.appointment_id),
            2
        ) AS DECIMAL(10,2)
    ) AS RevenuePerAppointment
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


-- Appointment completion rate by specialisation
SELECT
    d.specialization,
    COUNT(*) AS TotalAppointments,
    SUM(
        CASE
            WHEN a.status = 'Completed'
            THEN 1
            ELSE 0
        END
    ) AS CompletedAppointments,
    CAST(
        ROUND(
            100.0 *
            SUM(
                CASE
                    WHEN a.status = 'Completed'
                    THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS DECIMAL(5,2)
    ) AS CompletionRate
FROM appointments_cleaned a
JOIN doctors_cleaned d
    ON a.doctor_id = d.doctor_id
GROUP BY d.specialization
ORDER BY CompletionRate DESC;


-- No-show rate by doctor
-- Which doctors experience the highest patient no-show rate?
SELECT
    d.first_name + ' ' + d.last_name AS Doctor,
    COUNT(*) AS TotalAppointments,
    SUM(
        CASE
            WHEN status = 'No-show'
            THEN 1
            ELSE 0
        END
    ) AS NoShows,
    CAST(
        ROUND(
            100.0 *
            SUM(
                CASE
                    WHEN status = 'No-show'
                    THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS DECIMAL(5,2)
    ) AS NoShowRate
FROM doctors_cleaned d
JOIN appointments_cleaned a
    ON d.doctor_id = a.doctor_id
GROUP BY
    d.first_name,
    d.last_name
ORDER BY NoShowRate DESC;


-- Average Revenue by insurance provider
-- Which insurance provider contributes the highest value patients?
SELECT
    p.insurance_provider,
    COUNT(*) AS Bills,
    CAST(
        ROUND(SUM(b.amount),2)
        AS DECIMAL(12,2)
    ) AS TotalRevenue,
    CAST(
        ROUND(AVG(b.amount),2)
        AS DECIMAL(10,2)
    ) AS AverageBill
FROM patients_cleaned p
JOIN billing_cleaned b
    ON p.patient_id = b.patient_id
GROUP BY p.insurance_provider
ORDER BY AverageBill DESC;


-- Monthly revenue trend
-- Which month generates the highest revenue?
SELECT
    DATENAME(MONTH, b.bill_date) AS MonthName,
    MONTH(b.bill_date) AS MonthNumber,
    CAST(
        ROUND(SUM(b.amount),2)
        AS DECIMAL(12,2)
    ) AS Revenue
FROM billing_cleaned b
GROUP BY
    DATENAME(MONTH, b.bill_date),
    MONTH(b.bill_date)
ORDER BY MonthNumber;


-- Branch efficiency
-- Which branch generates the highest revenue per appointment?
SELECT
    d.hospital_branch,
    COUNT(DISTINCT a.appointment_id) AS Appointments,
    CAST(
        ROUND(SUM(b.amount),2)
        AS DECIMAL(12,2)
    ) AS Revenue,
    CAST(
        ROUND(
            SUM(b.amount) /
            COUNT(DISTINCT a.appointment_id),
            2
        ) AS DECIMAL(10,2)
    ) AS RevenuePerAppointment
FROM doctors_cleaned d
JOIN appointments_cleaned a
    ON d.doctor_id = a.doctor_id
JOIN treatment_cleaned t
    ON a.appointment_id = t.appointment_id
JOIN billing_cleaned b
    ON t.treatment_id = b.treatment_id
GROUP BY d.hospital_branch
ORDER BY RevenuePerAppointment DESC;


-- Highest value patients
-- Which patients contribute the most revenue?
SELECT TOP 5
    p.patient_id,
    p.first_name,
    p.last_name,
    p.insurance_provider,
    COUNT(b.bill_id) AS TotalBills,
    CAST(
        ROUND(SUM(b.amount),2)
        AS DECIMAL(12,2)
    ) AS LifetimeRevenue
FROM patients_cleaned p
JOIN billing_cleaned b
    ON p.patient_id = b.patient_id
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
    CAST(
        ROUND(SUM(b.amount),2)
        AS DECIMAL(12,2)
    ) AS Revenue,
    RANK() OVER(
        ORDER BY SUM(b.amount) DESC
    ) AS RevenueRank
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
    d.specialization;
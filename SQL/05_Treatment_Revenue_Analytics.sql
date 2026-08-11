USE HospitalAnalytics;
GO

-- =============================================
-- TREATMENT & REVENUE ANALYTICS
-- =============================================

-- Revenue by treatment type
SELECT
    t.treatment_type,
    COUNT(*) AS TotalTreatments,
    CAST(
        ROUND(SUM(b.amount),2)
        AS DECIMAL(10,2)
    ) AS TotalRevenue,
    CAST(
        ROUND(AVG(b.amount),2)
        AS DECIMAL(10,2)
    ) AS AverageRevenue
FROM treatment_cleaned t
JOIN billing_cleaned b
    ON t.treatment_id = b.treatment_id
GROUP BY t.treatment_type
ORDER BY TotalRevenue DESC;


-- Average cost by treatment type
SELECT
    treatment_type,
    COUNT(*) AS TotalTreatments,
    CAST(
        ROUND(AVG(cost),2)
        AS DECIMAL(10,2)
    ) AS AverageCost,
    CAST(
        ROUND(MIN(cost),2)
        AS DECIMAL(10,2)
    ) AS MinimumCost,
    CAST(
        ROUND(MAX(cost),2)
        AS DECIMAL(10,2)
    ) AS MaximumCost
FROM treatment_cleaned
GROUP BY treatment_type
ORDER BY AverageCost DESC;


-- Revenue by doctor
SELECT
    d.first_name + ' ' + d.last_name AS Doctor,
    d.specialization,
    COUNT(DISTINCT a.appointment_id) AS TotalAppointments,
    CAST(
        ROUND(SUM(b.amount),2)
        AS DECIMAL(10,2)
    ) AS TotalRevenue
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
    CAST(
        ROUND(SUM(b.amount),2)
        AS DECIMAL(10,2)
    ) AS TotalRevenue,
    CAST(
        ROUND(AVG(b.amount),2)
        AS DECIMAL(10,2)
    ) AS AverageRevenue
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
    CAST(
        ROUND(SUM(b.amount),2)
        AS DECIMAL(10,2)
    ) AS TotalRevenue
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
    CAST(
        ROUND(SUM(amount),2)
        AS DECIMAL(10,2)
    ) AS TotalRevenue,
    CAST(
        ROUND(AVG(amount),2)
        AS DECIMAL(10,2)
    ) AS AverageBill
FROM billing_cleaned
GROUP BY payment_method
ORDER BY TotalRevenue DESC;


-- Revenue by insurance provider
SELECT
    p.insurance_provider,
    COUNT(*) AS TotalBills,
    CAST(
        ROUND(SUM(b.amount),2)
        AS DECIMAL(10,2)
    ) AS TotalRevenue,
    CAST(
        ROUND(AVG(b.amount),2)
        AS DECIMAL(10,2)
    ) AS AverageBill
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
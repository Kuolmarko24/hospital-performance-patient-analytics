USE HospitalAnalytics;
GO

-- =============================================
-- APPOINTMENT & OPERATIONAL ANALYTICS
-- =============================================

-- Appointment Analytics

-- Appointment status distribution
SELECT
    status,
    COUNT(*) AS TotalAppointments,
    CAST(
        ROUND(
            COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),
            2
        ) AS DECIMAL(10,2)
    ) AS Percentage
FROM appointments_cleaned
GROUP BY status
ORDER BY TotalAppointments DESC;


-- Most common reasons for visit
SELECT
    reason_for_visit,
    COUNT(*) AS TotalAppointments,
    CAST(
        ROUND(
            COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),
            2
        ) AS DECIMAL(10,2)
    ) AS Percentage
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


-- Busiest day of the week
SELECT
    DATENAME(WEEKDAY, appointment_date) AS WeekDay,
    COUNT(*) AS TotalAppointments
FROM appointments_cleaned
GROUP BY DATENAME(WEEKDAY, appointment_date)
ORDER BY TotalAppointments DESC;


-- Peak appointment hours
SELECT
    DATEPART(HOUR, appointment_time) AS AppointmentHour,
    COUNT(*) AS TotalAppointments
FROM appointments_cleaned
GROUP BY DATEPART(HOUR, appointment_time)
ORDER BY AppointmentHour;


-- Doctor no-show analysis
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
WHERE status = 'Cancelled'
GROUP BY d.specialization
ORDER BY CancelledAppointments DESC;
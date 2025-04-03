-- How does the volume of new appointments compare to 
-- follow-up appointments on a monthly basis?

SELECT
    appt_month,
    COUNT(CASE WHEN new_follow_up = 'new' THEN 1 END) AS new_appt_count,
    COUNT(CASE WHEN new_follow_up = 'f/u' THEN 1 END) AS followup_appt_count,
    ROUND(
        COUNT(CASE WHEN new_follow_up = 'new' THEN 1 END)::numeric /
        NULLIF(COUNT(CASE WHEN new_follow_up = 'f/u' THEN 1 END), 0),
        2
    ) AS new_to_followup_ratio
FROM
    medical_appointments
GROUP BY
    appt_month
ORDER BY
    appt_month;




-- When appointments are canceled or missed, 
-- how often are they rescheduled — and does that depend 
-- on the reason for cancellation?

SELECT
    cancellation,
    COUNT(*) FILTER (WHERE reschedule_made != 'Not Made') AS rescheduled_count,
    COUNT(*) AS total_cancellations,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE reschedule_made != 'Not Made') / COUNT(*),
        1
    ) AS reschedule_rate_percent
FROM
    medical_appointments
WHERE
    cancellation IN ('No Show', 'Cancelled by Patient', 'Cancelled by Clinician')
GROUP BY
    cancellation
ORDER BY
    total_cancellations DESC;
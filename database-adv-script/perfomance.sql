-- performance.sql
-- Optimized version
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    p.property_id,
    p.name AS property_name,
    p.location,
    py.amount,
    py.payment_method
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id
INNER JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments py ON b.booking_id = py.booking_id
WHERE 
    b.start_date >= CURRENT_DATE - INTERVAL '6 months'
ORDER BY 
    b.start_date DESC
LIMIT 1000;


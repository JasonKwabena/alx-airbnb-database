SELECT 
    p.property_id,
    p.name,
    p.location,
    p.price_per_night,
    avg_rating.average_rating
FROM 
    properties p
JOIN (
    SELECT 
        property_id,
        AVG(rating) AS average_rating
    FROM 
        reviews
    GROUP BY 
        property_id
    HAVING 
        AVG(rating) > 4.0
) avg_rating ON p.property_id = avg_rating.property_id
ORDER BY 
    avg_rating.average_rating DESC;


SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM 
    users u
WHERE 
    (
        SELECT COUNT(*)
        FROM bookings b
        WHERE b.user_id = u.user_id
    ) > 3;


SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS booking_count
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
HAVING 
    COUNT(b.booking_id) > 3;

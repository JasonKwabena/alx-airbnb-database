SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
ORDER BY 
    total_bookings DESC;


SELECT 
    p.property_id,
    p.name,
    p.location,
    COUNT(b.booking_id) AS booking_count,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS popularity_rank,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_popularity_rank,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_num
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.location
ORDER BY 
    booking_count DESC;


CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_bookings_property ON bookings(property_id);


WITH ranked_properties AS (
    SELECT 
        property_id,
        RANK() OVER (ORDER BY COUNT(booking_id) DESC) AS rank
    FROM bookings
    GROUP BY property_id
)
SELECT * FROM ranked_properties WHERE rank <= 5;

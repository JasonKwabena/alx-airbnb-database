Database Index Optimization

High-Usage Columns Analysis
User Table

    user_id (Primary Key, JOINs)

    email (WHERE clauses for login)

    role (WHERE clauses for authorization)

Booking Table

    booking_id (Primary Key)

    user_id (JOINs to User)

    property_id (JOINs to Property)

    start_date/end_date (WHERE clauses for availability)

    status (WHERE clauses for filtering)

Property Table

    property_id (Primary Key)

    host_id (JOINs to User)

    location (WHERE clauses for search)

    price_per_night (WHERE/ORDER BY for filtering)

Index Creation Script

-- database_index.sql

-- User Table Indexes
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_user_role ON users(role);

-- Booking Table Indexes
CREATE INDEX idx_booking_user ON bookings(user_id);
CREATE INDEX idx_booking_property ON bookings(property_id);
CREATE INDEX idx_booking_dates ON bookings(start_date, end_date);
CREATE INDEX idx_booking_status ON bookings(status);

-- Property Table Indexes
CREATE INDEX idx_property_host ON properties(host_id);
CREATE INDEX idx_property_location ON properties(location);
CREATE INDEX idx_property_price ON properties(price_per_night);

-- Composite Index for Common Search Patterns
CREATE INDEX idx_property_search ON properties(location, price_per_night);


Performance Measurement

EXPLAIN ANALYZE
SELECT p.name, p.location, AVG(r.rating) as avg_rating
FROM properties p
JOIN reviews r ON p.property_id = r.property_id
WHERE p.location LIKE 'New York%'
AND p.price_per_night BETWEEN 100 AND 300
GROUP BY p.property_id
ORDER BY avg_rating DESC
LIMIT 10;

After Indexes

EXPLAIN ANALYZE
SELECT p.name, p.location, AVG(r.rating) as avg_rating
FROM properties p
JOIN reviews r ON p.property_id = r.property_id
WHERE p.location LIKE 'New York%'
AND p.price_per_night BETWEEN 100 AND 300
GROUP BY p.property_id
ORDER BY avg_rating DESC
LIMIT 10;

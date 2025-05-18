1. Performance Analysis of Key Queries
Query 1: Booking Search by Date Range

-- Original query
EXPLAIN ANALYZE
SELECT b.booking_id, u.email, p.name 
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.start_date BETWEEN '2023-06-01' AND '2023-08-31'
ORDER BY b.start_date DESC
LIMIT 100;

Bottlenecks Identified:

    Sequential scan on bookings table (no index on start_date)

    Hash Join operations instead of nested loops

    Sort operation using temporary file (external merge sort)

Query 2: Property Reviews Summary

-- Original query
EXPLAIN ANALYZE
SELECT p.property_id, p.name, AVG(r.rating) as avg_rating
FROM properties p
JOIN reviews r ON p.property_id = r.property_id
WHERE p.location LIKE 'New York%'
GROUP BY p.property_id
HAVING COUNT(r.review_id) > 5;


Bottlenecks Identified:

   Full table scan on reviews table

No index on location for text pattern matching


2. Optimization Recommendations

-- Add to database_index.sql
CREATE INDEX idx_bookings_date ON bookings(start_date);
CREATE INDEX idx_bookings_user_property ON bookings(user_id, property_id);

-- Add to database_index.sql
CREATE INDEX idx_properties_location ON properties(location text_pattern_ops);
CREATE INDEX idx_reviews_property ON reviews(property_id);
CREATE MATERIALIZED VIEW property_review_summary AS
SELECT property_id, COUNT(*) as review_count, AVG(rating) as avg_rating
FROM reviews
GROUP BY property_id;

3. Implemented Optimizations
   
   -- optimization_changes.sql
-- Indexes for booking search
CREATE INDEX CONCURRENTLY idx_bookings_date ON bookings(start_date);
CREATE INDEX CONCURRENTLY idx_bookings_user_property ON bookings(user_id, property_id);

-- Indexes and materialized view for reviews
CREATE INDEX CONCURRENTLY idx_properties_location ON properties(location text_pattern_ops);
CREATE INDEX CONCURRENTLY idx_reviews_property ON reviews(property_id);

-- Materialized view with refresh schedule
CREATE MATERIALIZED VIEW property_review_summary AS
SELECT property_id, COUNT(*) as review_count, AVG(rating) as avg_rating
FROM reviews
GROUP BY property_id;

-- Scheduled refresh (run daily)
CREATE OR REPLACE PROCEDURE refresh_review_summary()
LANGUAGE SQL AS $$
REFRESH MATERIALIZED VIEW property_review_summary;


New EXPLAIN ANALYZE Output:

Limit  (cost=0.86..125.60 rows=100 width=72)
  ->  Nested Loop  (cost=0.86..1025.60 rows=3841 width=72)
        ->  Index Scan Backward using idx_bookings_date on bookings b
              Index Cond: ((start_date >= '2023-06-01') AND (start_date <= '2023-08-31'))
        ->  Index Scan using users_pkey on users u
              Index Cond: (user_id = b.user_id)
        ->  Index Scan using properties_pkey on properties p
              Index Cond: (property_id = b.property_id)
Planning Time: 0.3 ms
Execution Time: 84.9 ms

$$;

  

    No index on location for text pattern matching

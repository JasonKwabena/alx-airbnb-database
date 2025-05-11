# Database Sample Data Documentation

# Key Relationships
1. Host-Property**: Each host owns 2 properties
   - Sarah: Malibu Villa + NYC Penthouse
   - Michael: Aspen Cabin + Tahoe Cottage

2. Guest Activity**:
   - Emma: 2 confirmed bookings, left 2 reviews
   - James: 1 pending + 1 confirmed booking, left 2 reviews

3. Financials:
   - Payment amounts = (end_date - start_date) × price_per_night
   - Multiple payment methods represented

# Sample Queries
```sql
-- Find all properties with average rating ≥ 4
SELECT p.name, AVG(r.rating) as avg_rating
FROM properties p
JOIN reviews r ON p.property_id = r.property_id
GROUP BY p.property_id
HAVING AVG(r.rating) >= 4;

-- Calculate host earnings
SELECT u.first_name, SUM(py.amount) as total_earnings
FROM users u
JOIN properties p ON u.user_id = p.host_id
JOIN bookings b ON p.property_id = b.property_id
JOIN payments py ON b.booking_id = py.booking_id
WHERE u.role = 'host'
GROUP BY u.user_id;

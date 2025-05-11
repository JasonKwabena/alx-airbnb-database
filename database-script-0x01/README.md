 Database Schema Documentation

# Overview
This schema implements a property booking system (Airbnb-like) with 6 main tables:
1. `users` - Stores user accounts with roles
2. `properties` - Contains property listings
3. `bookings` - Manages reservation records
4. `payments` - Tracks payment transactions
5. `reviews` - Stores property reviews
6. `messages` - Handles user messaging

# Key Features
- UUID Primary Keys: All tables use UUIDs for secure, distributed ID generation
- Referential Integrity: Proper foreign key constraints with ON DELETE CASCADE
- Data Validation: ENUM types and CHECK constraints ensure data quality
- Performance Optimization: Strategic indexes on frequently queried columns
- 3NF Compliant**: Normalized to eliminate redundancy

# Usage
1. Execute `schema.sql` to create the database structure
2. The schema includes all necessary indexes for optimal performance
3. Timestamps (`created_at`, `updated_at`) are automatically managed

# Notes
- For PostgreSQL, uncomment the UUID extension line
- For MySQL, ensure ENUM support is available
- Application should calculate `total_price` dynamically (normalized design)

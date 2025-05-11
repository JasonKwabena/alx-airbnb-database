-- seed.sql

-- Insert Users (using sequential UUID patterns for readability)
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role) VALUES
-- Admin
('00000000-0000-0000-0000-000000000001', 'Admin', 'System', 'admin@airbnbclone.com', '$2a$10$B7z7GZ.exampleAdminHash', '+10000000001', 'admin'),

-- Hosts
('00000000-0000-0000-0000-000000000101', 'Sarah', 'Johnson', 'sarah.j@example.com', '$2a$10$hG9jK8.hostHash1', '+10000000101', 'host'),
('00000000-0000-0000-0000-000000000102', 'Michael', 'Chen', 'michael.c@example.com', '$2a$10$pQ2rS5.hostHash2', '+10000000102', 'host'),

-- Guests
('00000000-0000-0000-0000-000000000201', 'Emma', 'Williams', 'emma.w@example.com', '$2a$10$kL8nM3.guestHash1', '+10000000201', 'guest'),
('00000000-0000-0000-0000-000000000202', 'James', 'Rodriguez', 'james.r@example.com', '$2a$10$tR6vY9.guestHash2', '+10000000202', 'guest');

-- Insert Properties (grouped by host)
INSERT INTO properties (property_id, host_id, name, description, location, price_per_night) VALUES
-- Sarah's properties
('00000000-0000-0000-0001-000000000101', '00000000-0000-0000-0000-000000000101', 
 'Oceanview Villa', 'Luxury 3BR villa with private beach', 'Malibu, CA', 450.00),
('00000000-0000-0000-0001-000000000102', '00000000-0000-0000-0000-000000000101', 
 'Downtown Penthouse', 'Modern 2BR with city skyline views', 'New York, NY', 375.00),

-- Michael's properties
('00000000-0000-0000-0002-000000000101', '00000000-0000-0000-0000-000000000102', 
 'Mountain Retreat', 'Cozy A-frame cabin with hot tub', 'Aspen, CO', 275.00),
('00000000-0000-0000-0002-000000000102', '00000000-0000-0000-0000-000000000102', 
 'Lakeside Cottage', 'Charming 2BR with dock and canoe', 'Lake Tahoe, CA', 325.00);

-- Insert Bookings (with realistic date ranges)
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, status) VALUES
-- Emma's bookings
('00000000-0000-0001-0000-000000000201', '00000000-0000-0000-0001-000000000101', 
 '00000000-0000-0000-0000-000000000201', '2023-06-15', '2023-06-22', 'confirmed'),
('00000000-0000-0001-0000-000000000202', '00000000-0000-0000-0002-000000000101', 
 '00000000-0000-0000-0000-000000000201', '2023-08-01', '2023-08-07', 'confirmed'),

-- James' bookings
('00000000-0000-0002-0000-000000000201', '00000000-0000-0000-0001-000000000102', 
 '00000000-0000-0000-0000-000000000202', '2023-07-10', '2023-07-15', 'pending'),
('00000000-0000-0002-0000-000000000202', '00000000-0000-0000-0002-000000000102', 
 '00000000-0000-0000-0000-000000000202', '2023-09-05', '2023-09-12', 'confirmed');

-- Insert Payments (calculated as nights × price)
INSERT INTO payments (payment_id, booking_id, amount, payment_method) VALUES
('00000000-0001-0000-0000-000000000001', '00000000-0000-0001-0000-000000000201', 
 3150.00, 'credit_card'),  -- 7 nights × $450
('00000000-0001-0000-0000-000000000002', '00000000-0000-0001-0000-000000000202', 
 1650.00, 'stripe'),      -- 6 nights × $275
('00000000-0001-0000-0000-000000000003', '00000000-0000-0002-0000-000000000202', 
 2275.00, 'paypal');      -- 7 nights × $325

-- Insert Reviews (with varied ratings)
INSERT INTO reviews (review_id, property_id, user_id, rating, comment) VALUES
-- Reviews for Sarah's properties
('00000000-0002-0000-0000-000000000001', '00000000-0000-0000-0001-000000000101', 
 '00000000-0000-0000-0000-000000000201', 5, 'The villa exceeded all expectations! Stunning sunsets every evening.'),
('00000000-0002-0000-0000-000000000002', '00000000-0000-0000-0001-000000000102', 
 '00000000-0000-0000-0000-000000000202', 4, 'Great location but street noise was noticeable at night.'),

-- Reviews for Michael's properties
('00000000-0002-0000-0000-000000000003', '00000000-0000-0000-0002-000000000101', 
 '00000000-0000-0000-0000-000000000201', 5, 'Perfect mountain getaway! The hot tub was amazing after skiing.'),
('00000000-0002-0000-0000-000000000004', '00000000-0000-0000-0002-000000000102', 
 '00000000-0000-0000-0000-000000000202', 3, 'Cute cottage but the kitchen appliances need updating.');

-- Insert Messages (with natural conversation flow)
INSERT INTO messages (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
-- Emma ↔ Sarah
('00000000-0003-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 
 '00000000-0000-0000-0000-000000000101', 'Hi Sarah, is there a grocery store near the villa?', '2023-05-20 14:32:00'),
('00000000-0003-0000-0000-000000000002', '00000000-0000-0000-0000-000000000101', 
 '00000000-0000-0000-0000-000000000201', 'Yes Emma, Whole Foods is just 5 minutes away!', '2023-05-20 15:15:00'),

-- James ↔ Michael
('00000000-0003-0000-0000-000000000003', '00000000-0000-0000-0000-000000000202', 
 '00000000-0000-0000-0000-000000000102', 'Is the lake warm enough for swimming in September?', '2023-08-28 09:45:00'),
('00000000-0003-0000-0000-000000000004', '00000000-0000-0000-0000-000000000102', 
 '00000000-0000-0000-0000-000000000202', 'Absolutely! Average water temp is 72°F that time of year.', '2023-08-28 11:20:00');

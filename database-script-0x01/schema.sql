-- schema.sql
-- Database schema for ALX Airbnb Clone project
-- Users table
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('guest', 'host', 'admin') NOT NULL DEFAULT 'guest',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Properties table
CREATE TABLE properties (
    property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_property_host
        FOREIGN KEY (host_id) 
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- Bookings table
CREATE TABLE bookings (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_booking_property
        FOREIGN KEY (property_id) 
        REFERENCES properties(property_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_booking_user
        FOREIGN KEY (user_id) 
        REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_dates CHECK (end_date > start_date)
);

-- Payments table
CREATE TABLE payments (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    CONSTRAINT fk_payment_booking
        FOREIGN KEY (booking_id) 
        REFERENCES bookings(booking_id)
        ON DELETE CASCADE
);

-- Reviews table
CREATE TABLE reviews (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_property
        FOREIGN KEY (property_id) 
        REFERENCES properties(property_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_review_user
        FOREIGN KEY (user_id) 
        REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5)
);

-- Messages table
CREATE TABLE messages (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_message_sender
        FOREIGN KEY (sender_id) 
        REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_message_recipient
        FOREIGN KEY (recipient_id) 
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- Create indexes for performance optimization
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_property_host ON properties(host_id);
CREATE INDEX idx_property_location ON properties(location);
CREATE INDEX idx_booking_property ON bookings(property_id);
CREATE INDEX idx_booking_user ON bookings(user_id);
CREATE INDEX idx_booking_dates ON bookings(start_date, end_date);
CREATE INDEX idx_payment_booking ON payments(booking_id);
CREATE INDEX idx_review_property ON reviews(property_id);
CREATE INDEX idx_message_participants ON messages(sender_id, recipient_id);

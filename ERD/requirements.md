1. Entities & Attributes

Entity	Attributes	PK/FK

User	user_id (PK), first_name, last_name, email, password_hash, phone_number, role, created_at	user_id (PK)
Property	property_id (PK), host_id (FK), name, description, location, pricepernight, created_at, updated_at	property_id (PK), host_id (FK→User)
Booking	booking_id (PK), property_id (FK), user_id (FK), start_date, end_date, total_price, status, created_at	booking_id (PK), property_id (FK→Property), user_id (FK→User)
Payment	payment_id (PK), booking_id (FK), amount, payment_date, payment_method	payment_id (PK), booking_id (FK→Booking)
Review	review_id (PK), property_id (FK), user_id (FK), rating, comment, created_at	review_id (PK), property_id (FK→Property), user_id (FK→User)
Message	message_id (PK), sender_id (FK), recipient_id (FK), message_body, sent_at	message_id (PK), sender_id/recipient_id (FK→User)

2. Relationships
Relationship	Cardinality	Description

User → Property	One-to-Many	One host (User) can list many Properties
User → Booking	One-to-Many	One guest (User) can make many Bookings
Property → Booking	One-to-Many	One Property can have many Bookings
Booking → Payment	One-to-One	Each Booking has exactly one Payment
User → Review	One-to-Many	One User can write many Reviews
Property → Review	One-to-Many	One Property can receive many Reviews
User → Message (Sender)	One-to-Many	One User can send many Messages
User → Message (Recipient)	One-to-Many	One User can receive many Messages

![ER Diagram drawio](https://github.com/user-attachments/assets/c852479e-47ca-483f-b83c-e319cfe85c4f)

# Database Normalization Review & Optimization 
Schema: Property Booking System  
Current Normal Form: 1NF (Partial 2NF)  
Target Normal Form: 3NF  

---

# 1. Identified Redundancies & Violations  

# 1.1 Partial Key Dependencies (2NF Violation)  
- Issue: `total_price` in `Booking` can be derived from `Property.pricepernight` and date range (`end_date - start_date`), violating 2NF (non-prime attribute dependent on part of a composite key).  
- Example: 
  ```sql
  -- Redundant calculation
  SELECT (end_date - start_date) * pricepernight AS total_price 
  FROM Booking JOIN Property ON Booking.property_id = Property.property_id;
  ```

# 1.2 Transitive Dependencies (3NF Violation)  
- Issue: `Property.host_id` → `User.role` implies `host_id` determines `role` (transitive dependency if `role` is derivable from `host_id`).  
- Example:  
  ```sql
  -- Redundant if role="host" is enforced via application logic
  SELECT role FROM User WHERE user_id = [host_id];
  ```

# 1.3 Data Duplication  
- Issue:`User` details (e.g., `email`, `phone_number`) are repeated in `Booking`, `Review`, and `Message` tables via `user_id` foreign keys, but this is acceptable in 3NF (FKs are not redundancies).  

---

# 2. Normalization Steps to Achieve 3NF  

# 2.1 Remove Derived Attributes (2NF Compliance) 
- Action: Drop `total_price` from `Booking`. Calculate dynamically in queries or application logic.  
- Before:  
  ```sql
  CREATE TABLE Booking (
    ...
    total_price DECIMAL NOT NULL  -- Redundant
  );
  ```
- After:  
  ```sql
  CREATE TABLE Booking (
    ...
    -- total_price removed
  );
  ```

# 2.2 Enforce Role Consistency (3NF Compliance)**  
- Action: Ensure `role="host"` is validated at application level when creating `Property`, avoiding transitive dependency.  
- Example Trigger (Optional): 
  ```sql
  CREATE TRIGGER validate_host_role
  BEFORE INSERT ON Property
  FOR EACH ROW
  BEGIN
    IF (SELECT role FROM User WHERE user_id = NEW.host_id) != 'host' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only hosts can list properties';
    END IF;
  END;
  ```

#2.3 Atomicity Checks (1NF Compliance)  
- **Verified:** All attributes are atomic (e.g., no CSV lists in `location` or `payment_method`).  

---

# 3. Optimized Schema (3NF-Compliant) 


# Key Improvements  
1. No Redundant Calculations: `total_price` derived at runtime.  
2. No Transitive Dependencies: `role` logic handled externally.  
3. FK Relationships Preserved: All joins remain efficient.  

---

# 4. Trade-offs  
- Pros: 
  - Eliminates update anomalies (e.g., `total_price` mismatches).  
  - Reduces storage overhead.  
- Cons: 
  - Application must compute `total_price` dynamically.  

---

# 5. Final Verification  
3NF Confirmed If: 
1. All non-prime attributes depend only on the PK.  
2. No transitive dependencies exist.  

Example Query Post-Optimization: 
```sql
-- Dynamically calculate total_price
SELECT 
  b.booking_id,
  (DATEDIFF(b.end_date, b.start_date) * p.pricepernight AS total_price
FROM Booking b
JOIN Property p ON b.property_id = p.property_id;
```

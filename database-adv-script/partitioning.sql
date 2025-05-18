-- partitioning.sql (continued)
-- Monthly maintenance procedure
CREATE OR REPLACE PROCEDURE create_next_booking_partition()
LANGUAGE plpgsql AS $$
DECLARE
    next_month TEXT;
    next_month_start DATE;
    next_month_end DATE;
    partition_exists BOOLEAN;
BEGIN
    -- Calculate next month values
    next_month := to_char(CURRENT_DATE + INTERVAL '1 month', 'y"y"m"m"');
    next_month_start := date_trunc('month', CURRENT_DATE + INTERVAL '1 month');
    next_month_end := date_trunc('month', CURRENT_DATE + INTERVAL '2 months');
    
    -- Check if partition already exists
    SELECT EXISTS (
        SELECT 1 
        FROM information_schema.table_partitions
        WHERE table_name = 'bookings' 
        AND partition_name = 'bookings_' || next_month
    ) INTO partition_exists;
    
    -- Create partition if needed
    IF NOT partition_exists THEN
        EXECUTE format('
            CREATE TABLE bookings_%s PARTITION OF bookings
            FOR VALUES FROM (%L) TO (%L)',
            next_month, next_month_start, next_month_end);
        
        RAISE NOTICE 'Created partition bookings_%', next_month;
    ELSE
        RAISE NOTICE 'Partition bookings_% already exists', next_month;
    END IF;
END;
$$;

-- Schedule with cron or pg_cron:
-- CALL create_next_booking_partition();

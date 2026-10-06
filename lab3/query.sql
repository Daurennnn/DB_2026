-- Inserts 200 rows into every table (PostgreSQL).
-- Assumes the tables are empty so SERIAL ids run 1..200.
-- Insert order respects foreign keys.

BEGIN;

-- 1. Airline
INSERT INTO Airline (airline_code, airline_name, airline_country, created_at, updated_at, airline_info)
SELECT
    'AL' || lpad(g::text, 3, '0'),
    'Airline ' || g,
    (ARRAY['USA','UK','Germany','France','Japan','Kazakhstan','UAE','Turkey','Canada','Brazil'])[1 + g % 10],
    now() - (g || ' days')::interval,
    now(),
    'Carrier #' || g
FROM generate_series(1, 200) AS g;

-- 2. Airport
INSERT INTO Airport (airport_name, country, state_name, city, created_at, updated_at)
SELECT
    'Airport ' || g,
    (ARRAY['USA','UK','Germany','France','Japan','Kazakhstan','UAE','Turkey','Canada','Brazil'])[1 + g % 10],
    'State ' || (1 + g % 25),
    'City ' || g,
    now() - (g || ' days')::interval,
    now()
FROM generate_series(1, 200) AS g;

-- 3. Passengers
INSERT INTO Passengers (first_name, last_name, date_of_birth, gender, country_of_citizenship,
                        country_of_residence, passport_number, created_at, updated_at)
SELECT
    (ARRAY['Alex','Maria','John','Aigerim','Chen','Fatima','Lucas','Olga','Omar','Sofia'])[1 + g % 10],
    (ARRAY['Smith','Garcia','Ivanov','Nurlan','Wang','Khan','Muller','Rossi','Sato','Silva'])[1 + (g / 10) % 10],
    date '1950-01-01' + (random() * 20000)::int,
    (ARRAY['Male','Female','Other'])[1 + g % 3],
    (ARRAY['USA','UK','Germany','France','Japan','Kazakhstan','UAE','Turkey','Canada','Brazil'])[1 + g % 10],
    (ARRAY['USA','UK','Germany','France','Japan','Kazakhstan','UAE','Turkey','Canada','Brazil'])[1 + (g + 3) % 10],
    'P' || lpad(g::text, 8, '0'),
    now() - (g || ' days')::interval,
    now()
FROM generate_series(1, 200) AS g;

-- 4. flights
INSERT INTO flights (sch_departure_time, sch_arrival_time, departing_airport_id, arriving_airport_id,
                     departing_gate, arriving_gate, airline_id,
                     actual_departure_time, actual_arrival_time, created_at, updated_at)
SELECT
    d.dep,
    d.dep + ((2 + g % 9) || ' hours')::interval,
    g,                                   -- departing airport 1..200
    1 + ((g + 6) % 200),                 -- arriving airport, always different
    'A' || (1 + g % 30),
    'B' || (1 + g % 30),
    1 + ((g * 7) % 200),
    d.dep + ((g % 45) || ' minutes')::interval,
    d.dep + ((2 + g % 9) || ' hours')::interval + ((g % 45) || ' minutes')::interval,
    now() - interval '60 days',
    now()
FROM generate_series(1, 200) AS g
CROSS JOIN LATERAL (SELECT timestamp '2026-01-01 06:00' + (g * 7 || ' hours')::interval AS dep) AS d;

-- 5. booking
INSERT INTO booking (flight_id, passenger_id, booking_platform, created_at, updated_at, status, ticket_price)
SELECT
    g,
    1 + ((g * 7) % 200),
    (ARRAY['Website','Mobile App','Travel Agency','Call Center'])[1 + g % 4],
    now() - (g || ' hours')::interval,
    now(),
    (ARRAY['Confirmed','Pending','Cancelled','Checked-in'])[1 + g % 4],
    round((50 + random() * 1950)::numeric, 2)
FROM generate_series(1, 200) AS g;

-- 6. Booking_flight
INSERT INTO Booking_flight (booking_id, flight_id, created_at, updated_at)
SELECT b.booking_id, b.flight_id, now(), now()
FROM booking b;

-- 7. Boarding_pass
INSERT INTO Boarding_pass (booking_id, seat, boarding_time, created_at, updated_at)
SELECT
    b.booking_id,
    (1 + b.booking_id % 40) || chr(65 + b.booking_id % 6),
    f.sch_departure_time - interval '45 minutes',
    now(),
    now()
FROM booking b
JOIN flights f ON f.flight_id = b.flight_id;

-- 8. Baggage
INSERT INTO Baggage (weight_in_kg, created_at, updated_at, booking_id)
SELECT
    round((2 + random() * 30)::numeric, 2),   -- fits DECIMAL(4,2)
    now(),
    now(),
    g
FROM generate_series(1, 200) AS g;

-- 9. Baggage_check
INSERT INTO Baggage_check (check_result, created_at, updated_at, booking_id, passenger_id)
SELECT
    (ARRAY['Passed','Failed','Needs Inspection'])[1 + b.booking_id % 3],
    now(),
    now(),
    b.booking_id,
    b.passenger_id
FROM booking b;

-- 10. Security_check
INSERT INTO Security_check (check_result, created_at, updated_at, passenger_id)
SELECT
    (ARRAY['Passed','Failed','Secondary Screening'])[1 + g % 3],
    now(),
    now(),
    g
FROM generate_series(1, 200) AS g;

COMMIT;

-- Sanity check
SELECT 'Airline' AS tbl, count(*) FROM Airline
UNION ALL SELECT 'Airport', count(*) FROM Airport
UNION ALL SELECT 'Passengers', count(*) FROM Passengers
UNION ALL SELECT 'flights', count(*) FROM flights
UNION ALL SELECT 'booking', count(*) FROM booking
UNION ALL SELECT 'Booking_flight', count(*) FROM Booking_flight
UNION ALL SELECT 'Boarding_pass', count(*) FROM Boarding_pass
UNION ALL SELECT 'Baggage', count(*) FROM Baggage
UNION ALL SELECT 'Baggage_check', count(*) FROM Baggage_check
UNION ALL SELECT 'Security_check', count(*) FROM Security_check;

--2
INSERT INTO airline (airline_code, airline_name, airline_country, created_at, updated_at, airline_info) 
VALUES ('KA', 'KazAir', 'Kazakhstan', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Yo');

--3
UPDATE airline 
SET airline_country = 'Turkey', updated_at = CURRENT_TIMESTAMP
WHERE airline_name = 'KazAir';

-- automate creation and update time
DO $$
DECLARE
	t record;
BEGIN
	FOR t IN
		SELECT table_name
		FROM information_schema.columns
		WHERE table_schema = 'public' AND column_name IN ('created_at', 'updated_at')
		GROUP BY table_name
		HAVING count(*) = 2
	LOOP
		EXECUTE format(
				'ALTER TABLE %I
					ALTER COLUMN created_at SET DEFAULT CURRENT_TIMESTAMP,
					ALTER COLUMN updated_at SET DEFAULT CURRENT_TIMESTAMP',
				t.table_name);
	END LOOP;
END $$;

--ASSIGNS NEW UPDATE_AT WHEN UPDATED
RETURNS trigger AS $$ 
BEGIN
	IF NEW.updated_at is NULL THEN
			NEW.updated_at = CURRENT_TIMESTAMP;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--4
INSERT INTO airline (airline_code, airline_name, airline_country, airline_info)
VALUES 
('AE', 'AirEasy', 'France', 'no'),
('FH', 'FlyHigh', 'Brazil', 'no'),
('FF', 'FlyFly', 'Poland', 'no');

--5
DELETE FROM flights
WHERE EXTRACT(YEAR FROM actual_arrival_time) = 2024

--6
UPDATE booking
SET ticket_price = ticket_price * 1.15

--on delete cascade
DO $$
DECLARE
    r record;
BEGIN
    FOR r IN
        SELECT conrelid::regclass AS tbl,
               conname,
               pg_get_constraintdef(oid) AS def
        FROM pg_constraint
        WHERE contype = 'f'
          AND connamespace = 'public'::regnamespace
          AND confdeltype = 'a'          -- only those still on the default NO ACTION
    LOOP
        EXECUTE format(
            'ALTER TABLE %s
                DROP CONSTRAINT %I,
                ADD CONSTRAINT %I %s ON DELETE CASCADE',
            r.tbl, r.conname, r.conname, r.def);
    END LOOP;
END $$;

--7
DELETE FROM booking
WHERE ticket_price < 10000

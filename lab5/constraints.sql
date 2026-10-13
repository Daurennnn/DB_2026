-- at least 10 y.o.
ALTER TABLE passengers
ADD CONSTRAINT ck_passenger_age CHECK (
	date_part('year', age(date_of_birth)) >= 10
)
-- test
INSERT INTO 
passengers(passenger_id, first_name, last_name, date_of_birth, gender, 
	country_of_citizenship, country_of_residence, 
	passport_number, created_at, update_at)
VALUES 
(201, 'John', 'Doe', '2011-01-01', 'Male', 'USA', 'USA', '003341115-8', 
	CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(202, 'Chira', 'Macalister', '2022-05-12', 'Female', 'Kazakhstan', 'Kazakhstan', '001743115-E', 
	CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- check booking price
ALTER TABLE booking
ADD CONSTRAINT ck_price_range CHECK (price >= 0 AND price <= 50000);
-- test
INSERT INTO booking
VALUES 
(501, 111, 'FlyArystan', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male', 40000),
(502, 196, 'AirAstana', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female', -5);


-- Check baggage weight
DELETE FROM baggage
WHERE weight_in_kg < 1 OR weight_in_kg > 23;
ALTER TABLE baggage
ADD CONSTRAINT ck_weight_range CHECK (weight_in_kg >= 1 AND weight_in_kg <= 23);
-- test
INSERT INTO baggage
VALUES 
(501, 19, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 14),
(502, 24, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 120)


-- Check airport name length 
DELETE FROM airport
WHERE LENGTH(airport_name) < 10;
ALTER TABLE airport
ADD CONSTRAINT ck_airport_name_len CHECK(LENGTH(airport_name) >= 10);
-- test
INSERT INTO airport
VALUES 
(21, 'Doha International', 'Qatar', 'Doha', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(22, 'Heathrow', 'UK', 'London', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- unique on tables
-- Unique constraints
-- For baggage, baggage_check, booking, security_check, boarding_pass only PK is needed (no need for UNIQUE)
 
ALTER TABLE airline
ADD CONSTRAINT uq_airline_code UNIQUE(airline_code);

ALTER TABLE airport
ADD CONSTRAINT uq_airport_name UNIQUE(airport_name);

SELECT booking_id, passenger_id, count(row(booking_id, passenger_id)) 
FROM baggage_check
GROUP BY booking_id, passenger_id
HAVING COUNT(row(booking_id, passenger_id)) > 1;
DELETE FROM
	baggage_check a
	USING baggage_check b
WHERE
	a.baggage_check_id < b.baggage_check_id AND
  a.booking_id = b.booking_id AND a.passenger_id = b.passenger_id;
ALTER TABLE baggage_check
ADD CONSTRAINT uq_booking_passenger UNIQUE(booking_id, passenger_id);

SELECT booking_id, flight_id, COUNT(ROW(booking_id, flight_id)) FROM booking_flight
GROUP BY booking_id, flight_id
HAVING COUNT(ROW(booking_id, flight_id)) > 1;
DELETE 
	FROM booking_flight a
	USING booking_flight b
WHERE
	a.booking_flight_id < b.booking_flight_id AND
  a.booking_id = b.booking_id AND a.flight_id = b.flight_id;
ALTER TABLE booking_flight
ADD CONSTRAINT uq_bookingid_flightid UNIQUE(booking_id, flight_id);

SELECT flight_no, scheduled_departure, COUNT(ROW(flight_no, scheduled_departure)) FROM flights
GROUP BY flight_no, scheduled_departure
HAVING COUNT(ROW(flight_no, scheduled_departure)) > 1;
DELETE 
	FROM flights a
	USING flights b
WHERE
	a.flight_id < b.flight_id AND
  a.flight_no = b.flight_no AND a.scheduled_departure = b.scheduled_departure;
ALTER TABLE flights
ADD CONSTRAINT uq_num_date UNIQUE(flight_no, scheduled_departure);

ALTER TABLE passengers
ADD CONSTRAINT uq_passport_num UNIQUE(passport_number);

ALTER TABLE passengers
ADD CONSTRAINT ck_male_age CHECK (gender <> 'male' OR date_of_birth <= CURRENT_DATE - INTERVAL '19 years');
ALTER TABLE passengers
ADD CONSTRAINT ck_male_age CHECK (gender <> 'female' OR date_of_birth <= CURRENT_DATE - INTERVAL '18 years');
ALTER TABLE passengers
ADD CONSTRAINT ck_male_age CHECK (country_of_citizenship <> 'Kazakhstan' OR 
	date_of_birth <= CURRENT_DATE - INTERVAL '18 years');
ALTER TABLE passengers
ADD CONSTRAINT ck_male_age CHECK (country_of_citizenship <> 'France' OR 
	date_of_birth <= CURRENT_DATE - INTERVAL '17 years');
ADD CONSTRAINT ck_male_age CHECK (country_of_citizenship <> 'France' OR 
	date_of_birth <= CURRENT_DATE - INTERVAL '17 years');


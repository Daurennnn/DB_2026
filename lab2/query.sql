CREATE TABLE Airline_info (
	airline_id SERIAL PRIMARY KEY NOT NULL,
	airline_code VARCHAR(30) NOT NULL,
	airline_name VARCHAR(50) NOT NULL,
	airline_country VARCHAR(50) NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	airline_info VARCHAR(50) NOT NULL
);

CREATE TABLE Airport (
	airport_id SERIAL PRIMARY KEY NOT NULL,
	airport_name VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL,
	state_name VARCHAR(50) NOT NULL,
	city VARCHAR(50) NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Baggage_check (
	baggage_check_id SERIAL PRIMARY KEY NOT NULL,
	check_result VARCHAR(50) NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	booking_id INTEGER NOT NULL,
	passenger_id INTEGER NOT NULL
);

CREATE TABLE Baggage (
	baggage_id SERIAL PRIMARY KEY NOT NULL,
	weight_in_kg DECIMAL(4, 2) NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	booking_id INTEGER NOT NULL
);

CREATE TABLE Boarding_pass (
	boarding_pass_id SERIAL PRIMARY KEY NOT NULL,
	booking_id INTEGER NOT NULL,
	seat VARCHAR(50) NOT NULL,
	boarding_time TIMESTAMP NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Booking_flight (
	booking_flight_id SERIAL PRIMARY KEY NOT NULL,
	booking_id INTEGER NOT NULL,
	flight_id INTEGER NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL
);

CREATE TABLE booking (
	booking_id SERIAL PRIMARY KEY NOT NULL,
	flight_id INTEGER NOT NULL,
	passenger_id INTEGER NOT NULL,
	booking_platform VARCHAR(50) NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	status VARCHAR(50) NOT NULL,
	price DECIMAL(7,2) NOT NULL
);


CREATE TABLE flights (
	flight_id SERIAL PRIMARY KEY NOT NULL,
	sch_departure_time TIMESTAMP NOT NULL,
	sch_arrival_time TIMESTAMP NOT NULL,
	departing_airport_id INTEGER NOT NULL,
	arriving_airport_id INTEGER NOT NULL,
	departing_gate VARCHAR(50) NOT NULL,
	arriving_gate VARCHAR(50) NOT NULL,
	airline_id INTEGER NOT NULL,
	actual_departure_time TIMESTAMP NOT NULL,
	actual_arrival_time TIMESTAMP NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Passengers (
	passenger_id SERIAL PRIMARY KEY NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	date_of_birth DATE NOT NULL,
	gender VARCHAR(50) NOT NULL,
	country_of_citizenship VARCHAR(50) NOT NULL,
	country_of_residence VARCHAR(50) NOT NULL,
	passport_number VARCHAR(50) NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Security_check (
	security_check_id SERIAL PRIMARY KEY NOT NULL,
	check_result VARCHAR(20) NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	passenger_id INTEGER NOT NULL
);


ALTER TABLE Airline_info
RENAME TO Airline;

ALTER TABLE booking
RENAME COLUMN price TO ticket_price ;

ALTER TABLE flights
ALTER COLUMN departing_gate TYPE TEXT;


ALTER TABLE Security_check
ADD CONSTRAINT fk_security_check_passenger
FOREIGN KEY (passenger_id) REFERENCES Passengers (passenger_id);

ALTER TABLE booking
ADD CONSTRAINT fk_booking_passenger
FOREIGN KEY (passenger_id) REFERENCES Passengers (passenger_id);

ALTER TABLE Baggage_check
ADD CONSTRAINT fk_baggage_check_passenger
FOREIGN KEY (passenger_id) REFERENCES Passengers (passenger_id);


ALTER TABLE Baggage_check
ADD CONSTRAINT fk_baggage_check_booking
FOREIGN KEY (booking_id) REFERENCES booking (booking_id);

ALTER TABLE Baggage
ADD CONSTRAINT fk_baggage_booking
FOREIGN KEY (booking_id) REFERENCES booking (booking_id);

ALTER TABLE Boarding_pass
ADD CONSTRAINT fk_boarding_pass_booking
FOREIGN KEY (booking_id) REFERENCES booking (booking_id);

ALTER TABLE Booking_flight
ADD CONSTRAINT fk_booking_flight_booking
FOREIGN KEY (booking_id) REFERENCES booking (booking_id);


ALTER TABLE Booking_flight
ADD CONSTRAINT fk_booking_flight_flight
FOREIGN KEY (flight_id) REFERENCES flights (flight_id);


ALTER TABLE flights
ADD CONSTRAINT fk_flights_departing_airport
FOREIGN KEY (departing_airport_id) REFERENCES Airport (airport_id);

ALTER TABLE flights
ADD CONSTRAINT fk_flights_arriving_airport
FOREIGN KEY (arriving_airport_id) REFERENCES Airport (airport_id);


ALTER TABLE flights
ADD CONSTRAINT fk_flights_airline
FOREIGN KEY (airline_id) REFERENCES Airline (airline_id);

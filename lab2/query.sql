  CREATE TABLE Airline_info (
	airline_id SERIAL PRIMARY KEY,
	airline_code VARCHAR(30),
	airline_name VARCHAR(50),
	airline_country VARCHAR(50),
	created_at TIMESTAMP,
	updated_at TIMESTAMP,
	airline_info VARCHAR(50)
);

CREATE TABLE Airport (
	airport_id SERIAL PRIMARY KEY,
	airport_name VARCHAR(50),
	country VARCHAR(50),
	state_name VARCHAR(50),
	city VARCHAR(50),
	created_at TIMESTAMP,
	updated_at TIMESTAMP
);

CREATE TABLE Baggage_check (
	baggage_check_id SERIAL PRIMARY KEY,
	check_result VARCHAR(50),
	created_at TIMESTAMP,
	updated_at TIMESTAMP,
	booking_id INTEGER,
	passenger_id INTEGER
);

CREATE TABLE Baggage (
	baggage_id SERIAL PRIMARY KEY,
	weight_in_kg DECIMAL(4, 2),
	created_at TIMESTAMP,
	updated_at TIMESTAMP,
	booking_id INTEGER
);

CREATE TABLE Bording_pass (
	boarding_pass_id SERIAL PRIMARY KEY,
	booking_id INTEGER,
	seat VARCHAR(50),
	boarding_time TIMESTAMP,
	created_at TIMESTAMP,
	updated_at TIMESTAMP
);

CREATE TABLE Booking_flight (
	booking_flight_id SERIAL PRIMARY KEY,
	booking_id INTEGER,
	flight_id INTEGER,
	created_at TIMESTAMP,
	updated_at TIMESTAMP
);

CREATE TABLE booking (
	booking_id SERIAL PRIMARY KEY,
	flight_id INTEGER,
	booking_platform VARCHAR(50),
	created_at TIMESTAMP,
	updated_at TIMESTAMP,
	status VARCHAR(50),
	price DECTIMAL(7,2)
);


CREATE TABLE flights (
	flight_id SERIAL PRIMARY KEY,
	sch_departure_time TIMESTAMP,
	sch_arrival_time TIMESTAMP,
	departing_airport_id INTEGER,
	arriving_airport_id INTEGER,
	departing_gate VARCHAR(50),
	arriving_gate VARCHAR(50),
	airline_id INTEGER,
	actual_departure_time TIMESTAMP,
	actual_arrival_time TIMESTAMP,
	created_at TIMESTAMP,
	updated_at TIMESTAMP
);

CREATE TABLE Passengers (
	passenger_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	date_of_birth DATE,
	gender VARCHAR(50),
	country_of_citizenship VARCHAR(50),
	country_of_residence VARCHAR(50),
	passport_number VARCHAR(50),
	created_at TIMESTAMP,
	updated_at TIMESTAMP
);

CREATE TABLE Security_check (
	security_check_id SERIAL PRIMARY KEY,
	check_result VARCHAR(20),
	created_at TIMESTAMP,
	updated_at TIMESTAMP,
	passenger_id INTEGER
);


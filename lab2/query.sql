

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

CREATE TABLE Bording_pass (
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



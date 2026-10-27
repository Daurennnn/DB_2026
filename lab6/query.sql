SELECT flight_id, flight_no FROM flights
WHERE airline_id = 1;

SELECT flight_id, flight_no, airport_name 
FROM flights
LEFT JOIN airport ON flights.departure_airport_id = airport.airport_id;

SELECT airline.airline_id, airline_name, scheduled_departure
FROM flights
INNER JOIN airline ON flights.airline_id = airline.airline_id
WHERE flights.scheduled_departure < CURRENT_TIMESTAMP + INTERVAL '1 MONTH'
OR flights.scheduled_departure < CURRENT_TIMESTAMP + INTERVAL '1 MONTH'
ORDER BY scheduled_departure DESC;

SELECT passengers.first_name, passengers.last_name, flights.flight_id, flights.flight_no
FROM passengers
INNER JOIN booking ON passengers.passenger_id = booking.passenger_id
INNER JOIN booking_flight ON booking.booking_id = booking_flight.booking_id
INNER JOIN flights ON booking_flight.flight_id = flights.flight_id
WHERE flights.flight_id = 350;

SELECT flights.flight_id, flights.flight_no, AVG(booking.price) AS average_price, 
	SUM(booking.price) AS total_money, 
	MAX(booking.price) AS max_price, 
	MIN(booking.price) AS min_price 
FROM flights
INNER JOIN booking_flight ON booking_flight.flight_id = flights.flight_id
INNER JOIN booking ON booking.booking_id = booking_flight.booking_id
GROUP BY flights.flight_id;

SELECT flights.flight_no, airline.airline_name, airport.airport_name, country
FROM flights
INNER JOIN airport ON flights.arrival_airport_id = airport.airport_id
INNER JOIN airline ON flights.airline_id = airline.airline_id
WHERE airport.country = 'China';

-- 1
SELECT flight_id, flight_no FROM flights
WHERE airline_id = 1;
-- 2
SELECT flight_id, flight_no, airport_name 
FROM flights
LEFT JOIN airport ON flights.departure_airport_id = airport.airport_id;
-- 3
SELECT airline.airline_id, airline_name, scheduled_departure
FROM flights
INNER JOIN airline ON flights.airline_id = airline.airline_id
WHERE flights.scheduled_departure < CURRENT_TIMESTAMP + INTERVAL '1 MONTH'
OR flights.scheduled_departure < CURRENT_TIMESTAMP + INTERVAL '1 MONTH'
ORDER BY scheduled_departure DESC;
-- 4
SELECT passengers.first_name, passengers.last_name, flights.flight_id, flights.flight_no
FROM passengers
INNER JOIN booking ON passengers.passenger_id = booking.passenger_id
INNER JOIN booking_flight ON booking.booking_id = booking_flight.booking_id
INNER JOIN flights ON booking_flight.flight_id = flights.flight_id
WHERE flights.flight_id = 350;
-- 5
SELECT flights.flight_id, flights.flight_no, AVG(booking.price) AS average_price, 
	SUM(booking.price) AS total_money, 
	MAX(booking.price) AS max_price, 
	MIN(booking.price) AS min_price 
FROM flights
INNER JOIN booking_flight ON booking_flight.flight_id = flights.flight_id
INNER JOIN booking ON booking.booking_id = booking_flight.booking_id
GROUP BY flights.flight_id;
-- 6
SELECT flights.flight_no, airline.airline_name, airport.airport_name, country
FROM flights
INNER JOIN airport ON flights.arrival_airport_id = airport.airport_id
INNER JOIN airline ON flights.airline_id = airline.airline_id
WHERE airport.country = 'China';
-- 7
SELECT passengers.passenger_id,
	passengers.first_name,
	passengers.last_name
FROM passengers
LEFT JOIN booking ON passengers.passenger_id = booking.passenger_id
INNER JOIN booking_flight ON booking.booking_id = booking_flight.booking_id
WHERE AGE(CURRENT_TIMESTAMP, passengers.date_of_birth) < INTERVAL '18 YEAR';
-- 8
SELECT CONCAT(p.first_name, ' ', p.last_name), p.passport_number, 
	date_trunc('minute', f.scheduled_arrival) AS arrival_at
FROM flights f
INNER JOIN booking_flight b_f ON f.flight_id = b_f.flight_id
INNER JOIN booking b ON b_f.booking_id = b.booking_id
INNER JOIN passengers p ON b.passenger_id = p.passenger_id
WHERE CURRENT_TIMESTAMP >= f.actual_departure
	AND CURRENT_TIMESTAMP < f.scheduled_arrival;
-- 9
SELECT flights.flight_id, flights.flight_no, airline.airline_code, 
	airline.airline_country, airport.country
FROM flights
INNER JOIN airline ON flights.airline_id = airline.airline_id
INNER JOIN airport ON flights.departure_airport_id = airport.airport_id
WHERE airport.country = airline.airline_country;
-- 10
SELECT f.flight_no, a.airline_name, d_a.airport_name, a_a.airport_name
FROM flights f
INNER JOIN airline a ON f.airline_id = a.airline_id
LEFT JOIN airport d_a ON f.departure_airport_id = d_a.airport_id
LEFT JOIN airport a_a ON f.arrival_airport_id = a_a.airport_id;
-- 11
SELECT al.airline_name, p.first_name, p.last_name, f.flight_no
FROM flights f
INNER JOIN airline al ON f.airline_id = al.airline_id
INNER JOIN booking_flight bf ON f.flight_id = bf.flight_id
INNER JOIN booking b ON bf.booking_id = b.booking_id
INNER JOIN passengers p ON b.passenger_id = p.passenger_id
WHERE al.airline_id = 1;
-- 12
SELECT f.flight_id, f.flight_no, ap.country AS arrival_country, 
	COUNT(b.passenger_id) AS count_passengers
FROM passengers p
JOIN booking b ON b.passenger_id = p.passenger_id
JOIN booking_flight bf ON bf.booking_id = b.booking_id
RIGHT JOIN flights f ON f.flight_id = bf.flight_id
JOIN airport ap ON ap.airport_id = f.arrival_airport_id
GROUP BY f.flight_id, ap.country
ORDER BY f.flight_id;
-- 13
SELECT p.first_name, p.last_name
FROM passengers p
LEFT JOIN booking b ON b.passenger_id = p.passenger_id
GROUP BY p.passenger_id
HAVING count(booking_id) = 0;
-- 14
SELECT al.airline_name, count(f.flight_id) AS count_flights
FROM airline al
LEFT JOIN flights f ON f.airline_id = al.airline_id
GROUP BY al.airline_id
ORDER BY count(f.flight_id);
-- 15
SELECT f.airline_id, al.airline_name, f.flight_no, ap.city
FROM flights f
LEFT JOIN airline al ON al.airline_id = f.airline_id
LEFT JOIN airport ap ON ap.airport_id = f.departure_airport_id
WHERE ap.airport_id = 1;

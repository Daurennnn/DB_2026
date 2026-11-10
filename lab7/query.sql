CREATE INDEX id_actual_departure 
  ON public.flights(actual_departure);
-- 
CREATE UNIQUE INDEX flights_fd_idx_uq
  ON flights(flight_no, scheduled_departure)
WHERE flight_id > 1000; 
-- 
create index flights_da_aa_idx 
  on flights(departure_airport_id, arrival_airport_id);

-- 224ms with index; 301ms without; increase ~ 34%
select *
from flights
where actual_departure > '2023-07-06';
-- 
explain analyze select *
from flights
where departure_airport_id = 10
	and arrival_airport_id = 20;
-- 
create unique index passengers_passno_idx_uq
on passengers(passport_number);
select *
from pg_indexes
where schemaname = 'public';

-- resuts in error
insert into passengers
values 
	(1001, 'dauren', 'zhan', '2001-12-11', 'male', 'kazakhstan', 'kazakhstan', '01928384756'),
	(10002, 'bebren', 'john', '2002-12-11', 'female', 'kazakhstan', 'kazakhstan', '01928384756');

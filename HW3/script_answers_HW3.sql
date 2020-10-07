use firstdb;

select *
from birdstrikes
-- we are adding IF statement / alternative to CASE WHEN--

-- task 1 --
select aircraft, airline, cost, speed,
if(speed = 0 or speed < 100, "low speed", "high speed") as speed_class
from birdstrikes
order by speed desc;
-- answer: created speed_class column

-- task 2 -- finding diff types of aircrafts in the dataset --
select distinct(aircraft) as distinct_aircraft
from birdstrikes;
-- answer: 3 aircraft types, Airplane, Blank and Heli

-- task 3 -- begins with command --
select *
from birdstrikes
where aircraft like 'H%'
order by speed asc;
-- answer: 9 knots? or KM/hr

-- task 4 -- 
select phase_of_flight, count(*) as cnt
from birdstrikes
group by phase_of_flight
order by cnt asc;
-- answer: Taxi (2 incidents)

-- task 5 --
select round(avg(cost)) as avg_cost, phase_of_flight
from birdstrikes
group by phase_of_flight
order by avg_cost desc;
-- answer: Climb

-- task 6 --
select distinct state, count(state) as cnt_state, avg(speed) as avg_speed
from birdstrikes
where length(state) < 5
group by state
order by avg_speed desc
-- answer: Iowa state with avg_speed of 2862 knots or KM/hr 

CREATE SCHEMA firstdb;
use firstdb;
drop schema if exists firstdb;
create schema firstdb;
use firstdb;
-- creating a table -- 
CREATE TABLE birdstrikes 
(id INTEGER NOT NULL,
aircraft VARCHAR(32),
flight_date DATE NOT NULL,
damage VARCHAR(16) NOT NULL,
airline VARCHAR(255) NOT NULL,
state VARCHAR(255),
phase_of_flight VARCHAR(32),
reported_date DATE,
bird_size VARCHAR(16),
cost INTEGER NOT NULL,
speed INTEGER,PRIMARY KEY(id));
-- load the CSV --
SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/birdstrikes_small.csv'
INTO TABLE birdstrikes 
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(id, aircraft, flight_date, damage, airline, state, phase_of_flight, @v_reported_date, bird_size, cost, @v_speed)
SET
reported_date = nullif(@v_reported_date, ''),
speed = nullif(@v_speed, '');


-- task 1 --
select *
from birdstrikes
limit 144,1;
-- answer: Tennessee
-+-id-+-aircraft+-flight_date-+----damage----+-----airline---------+----state----+-phase_of_flight-+reported_date+-bird_size-+-cost-+-speed-+
-- 146|	Airplane|	2000-01-19|	Caused damage|	FEDEX EXPRESS      |	Tennessee|	Approach	   | 2000-01-20	 |  Medium	 |      |  668	|
										
-- task 2 --
select *
from birdstrikes
order by flight_date desc
limit 1;
-- answer: 2000 Apr 18
-+-id-+-aircraft+-flight_date-+--damage---+-----airline---------+----state----+-phase_of_flight-+reported_date+-bird_size-+-cost-+-speed-+
-- 998 |Airplane|	2000-04-18|	No damage |	FEDEX EXPRESS		|  Oklahoma	  |     Approach	|			  |  Small	  |  0	 |  3000 |

-- task 3 --
select distinct cost
from birdstrikes
order by cost desc
limit 49,1;
-- answer: 5345

-- task 4 -- 
select *
from birdstrikes
where state is not null and bird_size is not null
limit 2;
-- answer: empty cell
-+-id-+-aircraft+-flight_date-+--damage---+-----airline---------+----state----+-phase_of_flight-+reported_date+-bird_size-+-cost-+-speed-+
-- 2  |	Airplane|	2000-01-01|	No damage |	CONTINENTAL AIRLINES|  New Jersey |	Take-off run  	|    NULL	  |	Medium	  |	0	 |   0
-- 3  |	Airplane|	2000-01-01|	No damage |	UNITED AIRLINES		|			  |				  	|    NULL	  |	Medium	  |	0	 |  NULL

-- task 5 --
select *, 
weekofyear(flight_date) as week_num,
curdate(),
datediff(curdate(),flight_date) as days_passed
from birdstrikes
where state = 'Colorado'
order by week_num desc
limit 1;
-- answer: 7580 days
-+-id-+-aircraft+-flight_date-+--damage--+----airline----+--state-+-phase_of_flight-+reported_date+-bird_size-+-cost-+-speed-+week_num+-curdate--+days_passed+
-- 4  |	Airplane|2000-01-01	  |	No damage|UNITED AIRLINES|Colorado|		Climb	  	| 			  | Medium	  |	0    |		 |52	  |2020-10-02|	7580	 |
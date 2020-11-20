-- lets check the files --
use supermario;
show tables;
-- lets see this table in particular--
select *
from clears;

-- seems like the date (catch) column in "clears" table doesnt see the dates properly --
select str_to_date(catch, "%d-%m-%y") 
from clears;
-- if we want to fix it now, we can use this "str_to_date" function and alter the "clears" table right now --
-- like this: --
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE clears ADD COLUMN realdate DATE;
UPDATE clears 
SET realdate = STR_TO_DATE(catch, "%d-%m-%y");
-- we added a new column with proper dates in the clears table --
-- we wont do this though, and will do this in the stored procedure as stated in the requirements for the TERM project --

-- ANALYTICS --

-- now we want to start looking for patterns that can explain to us some stuff that we are interested in --
-- like: whats the most "liked" game, why?; what are the most played games,why?; who are the most record holding players?, where are they from?; 
-- where are average players from? who made these maps? whats the avg time it takes to "clear" them?  how hard were the maps?

-- first we begin with --
-- finding most liked game_id (map that was created by a player) --
DROP PROCEDURE IF EXISTS CreateTopPlayers;

DELIMITER //
CREATE PROCEDURE CreateTopPlayers(
	IN x int
)
BEGIN
	DROP TABLE IF EXISTS best_players;
	CREATE TABLE best_players AS
    
select records.catch as date_of_record, records.game_id, records.player_id as recordsmen, players.player_id as players, players.flag, str_to_date(clears.catch, "%d-%m-%y") as realdate
from records
left join players
on records.player_id = players.player_id
left join clears
on clears.player_id = records.player_id

limit x
;
END //
DELIMITER ;

Call CreateTopPlayers(1000);
-- here we made a join of both players table and recordsmen players --
-- x stands for how many first rows we want to see --
select * from best_players;
-- there are lot off NULLs in players and flags because we join these columns on record players --

-- now lets find the nationality of (record holding) players --  
drop view Record_Player_Origin;
CREATE VIEW `Record_Player_Origin` AS
	select count(recordsmen) as record_holders, flag
	from best_players
    where flag is not null
	group by flag
	order by record_holders desc;
-- we can see that most of the record holders are from Japan: --
select * from Record_Player_Origin;

-- but what about if we wanted to see the nationalities of ordinary players? (the rest)--
drop view Normal_Player_Origin;
CREATE VIEW `Normal_Player_Origin` AS
	select count(player_id) as normal_players, flag
	from players
	group by flag
	order by normal_players desc;
-- we can see that most of the ordinary players are from USA (Japan is very close and more competitive apparently!!)--
select * from Normal_Player_Origin;

-- Now we create a new procedure to get data based on Makers of maps: -- 

DROP PROCEDURE IF EXISTS CreateTopMapMakers;

DELIMITER //
CREATE PROCEDURE CreateTopMapMakers()
BEGIN
	DROP TABLE IF EXISTS best_makers;
	CREATE TABLE best_makers AS
	select cm.catch as date_created, cm.map_id, cm.stars, cm.tweets, cm.attempts, cm.clears, cm.clearRate, c.difficulty, c.maker, c.title, p.flag
	from course_meta cm 
	join courses c 
	on cm.map_id = c.map_id
	join players p
	on c.maker = p.player_id
    ;
END //
DELIMITER ;

Call CreateTopMapMakers();
-- here is the relevant info on all makers of maps: --
-- ordered by "STARS" that the maker received from players --
-- x stands for how many first rows we want to see --
select * from best_makers;
-- here we see the maker of the map, his/her name and where he/she from, when the map was made, the difficulty, how liked it is among players 
-- and the title of the map --

-- now lets see who makes these most starred maps: --
drop view most_starred_makers;
CREATE VIEW `most_starred_makers` AS
select distinct maker, sum(stars) as total_stars, flag
from best_makers
group by maker
order by total_stars desc;
select * from most_starred_makers;
-- apparently all of the starred map makers are from Brazil ! --
-- to exclude corruptness of data, I manually checked the csv files, its really all Brazilians --
-- REASONS: its either because the first 1000 rows of the table that used really consists of only brasilians --- 
-- OR Brazilians as a nations are very creative and successful in creating Super Mario maps! :) ---

 -- lets see the what "difficulty" of maps means --
drop view Difficulty_Breakdown;
CREATE VIEW `Difficulty_Breakdown` AS
	select difficulty, round(sum(attempts)) as total_attempts, round(sum(clears)) as successful_attempts, round(avg(clearrate),2) as success_rate
	from best_makers
	group by difficulty
	order by success_rate desc;
select * from Difficulty_Breakdown;
-- we can see that as the difficulty grows, drops the success_rate (the average completion of a map and attemts needed) and the number of general tries --

-- now lets see what makes a game "starred"?
drop view Starred_games;
CREATE VIEW `Starred_games` AS
	select sum(stars) as total_stars, difficulty, round(sum(clears)) as total_clears, round(sum(attempts)) as total_attempts, round(avg(clearrate)) as success_rate
	from best_makers
	group by difficulty
	order by total_stars desc;
select * from Starred_games;
-- so apparently people star mostly "expert" difficulty maps probably because of their complexity and they play mostly harder maps for the same reason too!--
-- also the success rate (clears/attemts) drops drastically between easy and normal difficulties

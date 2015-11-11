/* 
some badminton courts operate past midnights but consider time after midnight
as part of the day before its actual day. This procedure fixes that by splitting
rows into different days if it run past midnights or Sundays
*/

-- enable auto increment so new rows can be added with primary keys
ALTER TABLE prices
CHANGE COLUMN price_id price_id INT(11) NOT NULL AUTO_INCREMENT FIRST;

-- change data type from datetime to date
ALTER TABLE prices
CHANGE COLUMN update_date update_date DATE NULL DEFAULT NULL AFTER type_id;

-- add new rows with an additional day and set start time to 12am
INSERT INTO prices (court_id,start_day_id,end_day_id,start_time_id,end_time_id,price,type_id,update_date)
SELECT court_id,start_day_id+1,end_day_id+1,0,end_time_id,price,type_id,update_date 
FROM prices
WHERE end_time_id < start_time_id AND end_time_id != 0;

-- edit the original rows to set end time to 12am
UPDATE prices SET end_time_id = 0
WHERE end_time_id < start_time_id AND end_time_id != 0;

-- make sure maximum index of day is 7 (8->1 = Monday)
UPDATE prices SET start_day_id = start_day_id % 7 WHERE start_day_id > 7;
UPDATE prices SET end_day_id = end_day_id % 7 WHERE end_day_id > 7;

-- add new rows with start day set at Monday if rows run pass Sundays
INSERT INTO prices (court_id,start_day_id,end_day_id,start_time_id,end_time_id,price,type_id,update_date)
SELECT court_id,1,end_day_id,start_time_id,end_time_id,price,type_id,update_date 
FROM prices
WHERE end_day_id < start_day_id;

-- set original end day to Sundays
UPDATE prices SET end_day_id = 7
WHERE end_day_id < start_day_id;

-- convert hour 24 to hour 0 (both mean 12am)
UPDATE prices SET end_time_id = 24
WHERE end_time_is = 0;
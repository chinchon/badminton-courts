ALTER TABLE prices
CHANGE COLUMN price_id price_id INT(11) NOT NULL AUTO_INCREMENT FIRST;

ALTER TABLE prices
CHANGE COLUMN update_date update_date DATE NULL DEFAULT NULL AFTER type_id;

INSERT INTO prices (court_id,start_day_id,end_day_id,start_time_id,end_time_id,price,type_id,update_date)
SELECT court_id,start_day_id+1,end_day_id+1,0,end_time_id,price,type_id,update_date 
FROM prices
WHERE end_time_id < start_time_id AND end_time_id != 0;

UPDATE prices SET end_time_id = 0
WHERE end_time_id < start_time_id AND end_time_id != 0;

UPDATE prices SET start_day_id = start_day_id % 7 WHERE start_day_id > 7;
UPDATE prices SET end_day_id = end_day_id % 7 WHERE end_day_id > 7;

INSERT INTO prices (court_id,start_day_id,end_day_id,start_time_id,end_time_id,price,type_id,update_date)
SELECT court_id,1,end_day_id,start_time_id,end_time_id,price,type_id,update_date 
FROM prices
WHERE end_day_id < start_day_id;

UPDATE prices SET end_day_id = 7
WHERE end_day_id < start_day_id;

UPDATE prices SET end_time_id = 24
WHERE end_time_is = 0;
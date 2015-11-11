-- find the prices for every available hour of the courts
SELECT court_id,day_id,time_id,price,type_id
FROM prices p
JOIN days d
JOIN time t
WHERE t.time_id BETWEEN p.start_time_id AND p.end_time_id - 1 
AND d.day_id BETWEEN p.start_day_id AND p.end_day_id
ORDER BY p.court_id,d.day_id,t.time_id
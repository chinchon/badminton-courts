-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.8-rc-log - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             9.3.0.4998
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for badminton
CREATE DATABASE IF NOT EXISTS `badminton` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `badminton`;


-- Dumping structure for table badminton.courts
CREATE TABLE IF NOT EXISTS `courts` (
  `court_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone_no` varchar(25) DEFAULT NULL,
  `unit` varchar(12) DEFAULT NULL,
  `street` varchar(12) DEFAULT NULL,
  `neighborhood` varchar(25) DEFAULT NULL,
  `postcode` varchar(5) DEFAULT NULL,
  `city` varchar(25) DEFAULT NULL,
  `state` varchar(12) DEFAULT NULL,
  `country` varchar(12) DEFAULT NULL,
  `latitude` varchar(12) DEFAULT NULL,
  `longitude` varchar(12) DEFAULT NULL,
  `gst_id` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`court_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table badminton.courts: ~3 rows (approximately)
/*!40000 ALTER TABLE `courts` DISABLE KEYS */;
INSERT INTO `courts` (`court_id`, `name`, `phone_no`, `unit`, `street`, `neighborhood`, `postcode`, `city`, `state`, `country`, `latitude`, `longitude`, `gst_id`) VALUES
	(1, 'Ara Courts Badminton Hall', '+603 7729 6955', 'Lot 997', 'Jalan Dahlia', 'Kampung Sungai Kayu Ara', '47400', 'Petaling Jaya', 'Selangor', 'Malaysia', '3.127565', '101.609445', '001053204480'),
	(2, 'Forum 19', '+6016 271 2020', '1', 'Jalan 19/1B', 'Seksyen 19', '46300', 'Petaling Jaya', 'Selangor', 'Malaysia', '3.113734', '101.627507', NULL),
	(3, 'New Vision Badminton Academy', '+60 3 7957 9595', '3', 'Jalan 13/1', 'Seksyen 13', '46200', 'Petaling Jaya', 'Selangor', 'Malaysia', '3.113391', '101.637289', NULL);
/*!40000 ALTER TABLE `courts` ENABLE KEYS */;


-- Dumping structure for table badminton.days
CREATE TABLE IF NOT EXISTS `days` (
  `day_id` int(11) NOT NULL,
  `day` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`day_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table badminton.days: ~7 rows (approximately)
/*!40000 ALTER TABLE `days` DISABLE KEYS */;
INSERT INTO `days` (`day_id`, `day`) VALUES
	(1, 'Monday'),
	(2, 'Tuesday'),
	(3, 'Wednesday'),
	(4, 'Thursday'),
	(5, 'Friday'),
	(6, 'Saturday'),
	(7, 'Sunday');
/*!40000 ALTER TABLE `days` ENABLE KEYS */;


-- Dumping structure for procedure badminton.FixDay
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `FixDay`()
BEGIN

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
WHERE end_time_id = 0;

END//
DELIMITER ;


-- Dumping structure for table badminton.prices
CREATE TABLE IF NOT EXISTS `prices` (
  `price_id` int(11) NOT NULL AUTO_INCREMENT,
  `court_id` int(11) NOT NULL,
  `start_day_id` int(11) NOT NULL,
  `end_day_id` int(11) NOT NULL,
  `start_time_id` int(11) NOT NULL,
  `end_time_id` int(11) NOT NULL,
  `price` decimal(12,2) DEFAULT NULL,
  `type_id` int(11) NOT NULL,
  `update_date` date DEFAULT NULL,
  PRIMARY KEY (`price_id`),
  KEY `court_id_index` (`court_id`),
  KEY `start_day_id_index` (`start_day_id`),
  KEY `end_day_id_index` (`end_day_id`),
  KEY `start_time_id_index` (`start_time_id`),
  KEY `end_time_id_index` (`end_time_id`),
  KEY `type_id_index` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;

-- Dumping data for table badminton.prices: ~41 rows (approximately)
/*!40000 ALTER TABLE `prices` DISABLE KEYS */;
INSERT INTO `prices` (`price_id`, `court_id`, `start_day_id`, `end_day_id`, `start_time_id`, `end_time_id`, `price`, `type_id`, `update_date`) VALUES
	(1, 1, 1, 4, 10, 18, 7.00, 2, '2015-10-17'),
	(2, 1, 1, 4, 10, 18, 10.00, 1, '2015-10-17'),
	(3, 1, 1, 4, 18, 23, 24.00, 2, '2015-10-17'),
	(4, 1, 1, 4, 18, 23, 28.00, 1, '2015-10-17'),
	(5, 1, 1, 4, 23, 24, 17.00, 2, '2015-10-17'),
	(6, 1, 1, 4, 23, 24, 17.00, 1, '2015-10-17'),
	(7, 1, 5, 5, 10, 18, 7.00, 2, '2015-10-17'),
	(8, 1, 5, 5, 10, 18, 10.00, 1, '2015-10-17'),
	(9, 1, 5, 5, 18, 23, 20.00, 2, '2015-10-17'),
	(10, 1, 5, 5, 18, 23, 24.00, 1, '2015-10-17'),
	(11, 1, 5, 5, 23, 24, 17.00, 2, '2015-10-17'),
	(12, 1, 5, 5, 23, 24, 17.00, 1, '2015-10-17'),
	(13, 1, 6, 7, 10, 24, 12.00, 2, '2015-10-17'),
	(14, 1, 6, 7, 10, 24, 15.00, 1, '2015-10-17'),
	(15, 2, 1, 5, 8, 18, 15.00, 1, '2015-09-25'),
	(16, 2, 1, 5, 8, 18, 10.00, 4, '2015-09-25'),
	(17, 2, 1, 5, 18, 24, 30.00, 1, '2015-09-25'),
	(18, 2, 6, 7, 8, 24, 20.00, 1, '2015-09-25'),
	(19, 2, 6, 7, 8, 24, 17.50, 3, '2015-09-25'),
	(20, 2, 1, 5, 18, 24, 27.50, 5, '2015-09-25'),
	(21, 2, 1, 5, 18, 24, 25.00, 6, '2015-09-25'),
	(22, 3, 1, 5, 9, 17, 17.00, 1, '2015-11-07'),
	(23, 3, 1, 5, 9, 17, 12.00, 4, '2015-11-07'),
	(24, 3, 1, 5, 17, 19, 24.00, 1, '2015-11-07'),
	(25, 3, 1, 5, 17, 19, 22.00, 6, '2015-11-07'),
	(26, 3, 1, 5, 19, 24, 28.00, 1, '2015-11-07'),
	(27, 3, 1, 5, 19, 24, 26.00, 6, '2015-11-07'),
	(28, 3, 6, 7, 9, 19, 24.00, 1, '2015-11-07'),
	(29, 3, 6, 7, 9, 19, 19.00, 3, '2015-11-07'),
	(30, 3, 6, 7, 19, 24, 15.00, 1, '2015-11-07'),
	(31, 3, 6, 7, 0, 1, 20.00, 1, '2015-11-07'),
	(32, 3, 1, 5, 11, 24, 20.00, 3, '2015-11-07'),
	(33, 1, 2, 5, 0, 1, 17.00, 2, '2015-10-17'),
	(34, 1, 2, 5, 0, 1, 17.00, 1, '2015-10-17'),
	(35, 1, 6, 6, 0, 1, 17.00, 2, '2015-10-17'),
	(36, 1, 6, 6, 0, 1, 17.00, 1, '2015-10-17'),
	(37, 1, 7, 7, 0, 1, 12.00, 2, '2015-10-17'),
	(38, 1, 7, 7, 0, 1, 15.00, 1, '2015-10-17'),
	(39, 3, 2, 6, 0, 1, 20.00, 3, '2015-11-07'),
	(40, 1, 1, 1, 0, 1, 12.00, 2, '2015-10-17'),
	(41, 1, 1, 1, 0, 1, 15.00, 1, '2015-10-17');
/*!40000 ALTER TABLE `prices` ENABLE KEYS */;


-- Dumping structure for view badminton.prices_per_hour
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `prices_per_hour` (
	`court_id` INT(11) NOT NULL,
	`day_id` INT(11) NOT NULL,
	`time_id` INT(11) NOT NULL,
	`price` DECIMAL(12,2) NULL,
	`type_id` INT(11) NOT NULL
) ENGINE=MyISAM;


-- Dumping structure for table badminton.time
CREATE TABLE IF NOT EXISTS `time` (
  `time_id` int(11) NOT NULL,
  `time` time DEFAULT NULL,
  PRIMARY KEY (`time_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table badminton.time: ~25 rows (approximately)
/*!40000 ALTER TABLE `time` DISABLE KEYS */;
INSERT INTO `time` (`time_id`, `time`) VALUES
	(0, '00:00:00'),
	(1, '01:00:00'),
	(2, '02:00:00'),
	(3, '03:00:00'),
	(4, '04:00:00'),
	(5, '05:00:00'),
	(6, '06:00:00'),
	(7, '07:00:00'),
	(8, '08:00:00'),
	(9, '09:00:00'),
	(10, '10:00:00'),
	(11, '11:00:00'),
	(12, '12:00:00'),
	(13, '13:00:00'),
	(14, '14:00:00'),
	(15, '15:00:00'),
	(16, '16:00:00'),
	(17, '17:00:00'),
	(18, '18:00:00'),
	(19, '19:00:00'),
	(20, '20:00:00'),
	(21, '21:00:00'),
	(22, '22:00:00'),
	(23, '23:00:00'),
	(24, '00:00:00');
/*!40000 ALTER TABLE `time` ENABLE KEYS */;


-- Dumping structure for table badminton.types
CREATE TABLE IF NOT EXISTS `types` (
  `type_id` int(11) NOT NULL,
  `type` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table badminton.types: ~6 rows (approximately)
/*!40000 ALTER TABLE `types` DISABLE KEYS */;
INSERT INTO `types` (`type_id`, `type`) VALUES
	(1, 'Standard'),
	(2, 'Parquet'),
	(3, 'Two Hour'),
	(4, 'Student'),
	(5, 'Booking (1 Month)'),
	(6, 'Booking (3 Month)');
/*!40000 ALTER TABLE `types` ENABLE KEYS */;


-- Dumping structure for view badminton.prices_per_hour
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `prices_per_hour`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `prices_per_hour` AS select `p`.`court_id` AS `court_id`,`d`.`day_id` AS `day_id`,`t`.`time_id` AS `time_id`,`p`.`price` AS `price`,`p`.`type_id` AS `type_id` from ((`prices` `p` join `days` `d`) join `time` `t`) where ((`t`.`time_id` between `p`.`start_time_id` and (`p`.`end_time_id` - 1)) and (`d`.`day_id` between `p`.`start_day_id` and `p`.`end_day_id`)) order by `p`.`court_id`,`d`.`day_id`,`t`.`time_id`;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

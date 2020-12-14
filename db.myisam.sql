-- Adminer 4.7.1 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

CREATE TABLE `days` (
  `Date` date NOT NULL,
  `Inv` int(3) NOT NULL,
  `Psum` int(10) NOT NULL,
  `Pmax` int(10) NOT NULL,
  PRIMARY KEY (`Date`,`Inv`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci PAGE_CHECKSUM=1 COMMENT='aus days.csv';


CREATE TABLE `events` (
  `DateTime1` datetime NOT NULL COMMENT 'Anfang ',
  `DateTime2` datetime DEFAULT NULL COMMENT 'Ende',
  `Inv` int(3) DEFAULT NULL COMMENT 'Inverter',
  `status` int(3) DEFAULT NULL COMMENT 'status code',
  `err` int(3) DEFAULT NULL COMMENT 'error code',
  PRIMARY KEY (`DateTime1`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci PAGE_CHECKSUM=1;


CREATE TABLE `events_INV_list` (`INV` int(3));


CREATE TABLE `min_date_list` (`date` date);


CREATE TABLE `min_INV` (
  `DateTime` datetime NOT NULL,
  `Inv` int(3) NOT NULL,
  `DaySum` int(10) DEFAULT NULL,
  `Uac` int(5) DEFAULT NULL,
  `Iac` int(5) DEFAULT NULL,
  `Pac` int(8) DEFAULT NULL,
  `Temp` int(3) DEFAULT NULL,
  `Status` int(2) DEFAULT NULL,
  `Error` int(2) DEFAULT NULL,
  PRIMARY KEY (`DateTime`,`Inv`),
  KEY `DateTime` (`DateTime`),
  KEY `Inv` (`Inv`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci PAGE_CHECKSUM=1 COMMENT='aus min*.csv, Inverterdaten';


CREATE TABLE `min_INV_list` (`INV` int(3));


CREATE TABLE `min_MPP` (
  `DateTime` datetime NOT NULL,
  `Inv` int(3) NOT NULL,
  `MPP` int(2) NOT NULL,
  `Udc` int(5) DEFAULT NULL,
  `Idc` int(5) DEFAULT NULL,
  `Pdc` int(8) DEFAULT NULL,
  PRIMARY KEY (`DateTime`,`Inv`,`MPP`),
  KEY `DateTime` (`DateTime`),
  KEY `Inv` (`Inv`),
  KEY `Inv_MPP` (`Inv`,`MPP`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci PAGE_CHECKSUM=1 COMMENT='aus min*.csv, string-Daten';


CREATE TABLE `min_MPP_list` (`Inv` int(3), `MPP` int(2));


CREATE TABLE `months` (
  `Date` date NOT NULL,
  `Inv` int(3) NOT NULL,
  `Psum` int(10) NOT NULL,
  PRIMARY KEY (`Date`,`Inv`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci PAGE_CHECKSUM=1 COMMENT='aus months.csv';


CREATE TABLE `PM` (
  `DateTime1` datetime NOT NULL COMMENT 'Anfang ',
  `DateTime2` datetime DEFAULT NULL COMMENT 'Ende',
  `Power_perc` int(3) DEFAULT NULL COMMENT 'Prozent Leistung 0...100',
  PRIMARY KEY (`DateTime1`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci PAGE_CHECKSUM=1;


CREATE TABLE `years` (
  `Date` date NOT NULL,
  `Inv` int(3) NOT NULL,
  `Psum` int(10) NOT NULL,
  PRIMARY KEY (`Date`,`Inv`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci PAGE_CHECKSUM=1 COMMENT='aus years.csv';


DROP TABLE IF EXISTS `events_INV_list`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `events_INV_list` AS select `events`.`Inv` AS `INV` from `events` group by `events`.`Inv` order by `events`.`Inv`;

DROP TABLE IF EXISTS `min_date_list`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `min_date_list` AS select cast(`min_INV`.`DateTime` as date) AS `date` from `min_INV` group by cast(`min_INV`.`DateTime` as date) order by cast(`min_INV`.`DateTime` as date);

DROP TABLE IF EXISTS `min_INV_list`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `min_INV_list` AS select `min_INV`.`Inv` AS `INV` from `min_INV` group by `min_INV`.`Inv` order by `min_INV`.`Inv`;

DROP TABLE IF EXISTS `min_MPP_list`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `min_MPP_list` AS select `min_MPP`.`Inv` AS `Inv`,`min_MPP`.`MPP` AS `MPP` from `min_MPP` group by `min_MPP`.`Inv`,`min_MPP`.`MPP` order by `min_MPP`.`Inv`,`min_MPP`.`MPP`;

-- 2020-12-14 09:06:45


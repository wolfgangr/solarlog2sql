-- phpMyAdmin SQL Dump
-- version 4.6.6deb4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Erstellungszeit: 14. Apr 2019 um 21:16
-- Server-Version: 10.1.37-MariaDB-0+deb9u1
-- PHP-Version: 7.0.33-0+deb9u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Datenbank: `solarlog`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `days`
--

CREATE TABLE `days` (
	  `Date` date NOT NULL,
	  `Inv` int(3) NOT NULL,
	  `Psum` int(10) NOT NULL,
	  `Pmax` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='aus days.csv';

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `months`
--

CREATE TABLE `months` (
	  `Date` date NOT NULL,
	  `Inv` int(3) NOT NULL,
	  `Psum` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='aus months.csv';

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `years`
--

CREATE TABLE `years` (
	  `Date` date NOT NULL,
	  `Inv` int(3) NOT NULL,
	  `Psum` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='aus years.csv';

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `days`
--
ALTER TABLE `days`
  ADD PRIMARY KEY (`Date`,`Inv`);

--
-- Indizes für die Tabelle `months`
--
ALTER TABLE `months`
  ADD PRIMARY KEY (`Date`,`Inv`);

--
-- Indizes für die Tabelle `years`
--
ALTER TABLE `years`
  ADD PRIMARY KEY (`Date`,`Inv`);


-- Adminer 4.7.1 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `min_INV`;
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
  KEY `Inv` (`Inv`),
  KEY `DateTime` (`DateTime`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='aus min*.csv, Inverterdaten';


DROP TABLE IF EXISTS `min_MPP`;
CREATE TABLE `min_MPP` (
  `DateTime` datetime NOT NULL,
  `Inv` int(3) NOT NULL,
  `MPP` int(2) NOT NULL,
  `Udc` int(5) DEFAULT NULL,
  `Idc` int(5) DEFAULT NULL,
  `Pdc` int(8) DEFAULT NULL,
  PRIMARY KEY (`DateTime`,`Inv`,`MPP`),
  KEY `Inv_MPP` (`Inv`,`MPP`),
  KEY `DateTime` (`DateTime`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='aus min*.csv, string-Daten';


-- 2020-12-10 22:24:16


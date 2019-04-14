-- phpMyAdmin SQL Dump
-- version 4.6.6deb4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Erstellungszeit: 14. Apr 2019 um 19:03
-- Server-Version: 10.1.37-MariaDB-0+deb9u1
-- PHP-Version: 7.0.33-0+deb9u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Datenbank: `solarlog`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `years`
--

CREATE TABLE `years` (
	  `Date` date NOT NULL,
	  `Inv` int(3) NOT NULL,
	  `Psum` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='aus years.csv';

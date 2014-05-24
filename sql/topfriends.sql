-- phpMyAdmin SQL Dump
-- version 4.0.9
-- http://www.phpmyadmin.net
--
-- Máquina: 127.0.0.1
-- Data de Criação: 25-Abr-2014 às 07:00
-- Versão do servidor: 5.6.14-log
-- versão do PHP: 5.5.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de Dados: `topfriends`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `fbusers`
--

CREATE TABLE IF NOT EXISTS `fbusers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fbid` bigint(20) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `data` longtext NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `expires` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fbid_index` (`fbid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=427924 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `fbuser_images`
--

CREATE TABLE IF NOT EXISTS `fbuser_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fbuser_fbid` bigint(20) NOT NULL,
  `snapshot` longtext,
  `fbshare` text,
  `fbsharetype` enum('image','link') DEFAULT 'link',
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fbuser_fbid` (`fbuser_fbid`),
  KEY `fbsharetype` (`fbsharetype`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=878463 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

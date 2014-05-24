CREATE TABLE `sessions` (
 `id` varchar(200) NOT NULL,
 `data` longtext,
 `created` datetime DEFAULT NULL,
 `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8
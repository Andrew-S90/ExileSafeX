CREATE TABLE IF NOT EXISTS `safex` (
  `uid` varchar(32) NOT NULL,
  `safex_player` varchar(20000) NOT NULL DEFAULT '[]',
  `marxet_player` varchar(20000) NOT NULL DEFAULT '[]',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
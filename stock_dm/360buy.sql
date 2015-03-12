-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.4.3-beta-community - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             8.1.0.4545
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for 360buy
CREATE DATABASE IF NOT EXISTS `360buy` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `360buy`;


-- Dumping structure for table 360buy.active_coupon
CREATE TABLE IF NOT EXISTS `active_coupon` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `url` char(128) COLLATE utf8_bin DEFAULT '',
  `start_ts` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_ts` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `add_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='get coupon link set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.category
CREATE TABLE IF NOT EXISTS `category` (
  `category_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(32) COLLATE utf8_bin DEFAULT '',
  `url` char(128) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`category_id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='product category set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.fail_skuid
CREATE TABLE IF NOT EXISTS `fail_skuid` (
  `skuid` int(10) unsigned NOT NULL,
  `last_try_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`skuid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='failed skuid list';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.full_category
CREATE TABLE IF NOT EXISTS `full_category` (
  `full_cate_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name_list` char(128) COLLATE utf8_bin DEFAULT '',
  `jd_id_list` char(32) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`full_cate_id`),
  KEY `name_list` (`name_list`),
  KEY `jd_id_list` (`jd_id_list`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='full category set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.gift
CREATE TABLE IF NOT EXISTS `gift` (
  `promo_id` int(10) unsigned NOT NULL,
  `skuid` int(10) unsigned NOT NULL,
  `type` int(10) unsigned DEFAULT '0',
  `number` int(10) unsigned DEFAULT '0',
  `state` smallint(5) unsigned DEFAULT '0',
  KEY `promo_id` (`promo_id`),
  KEY `skuid` (`skuid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='gift set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.product
CREATE TABLE IF NOT EXISTS `product` (
  `skuid` int(10) unsigned NOT NULL,
  `skuidkey` char(32) COLLATE utf8_bin DEFAULT NULL,
  `brand` mediumint(9) DEFAULT '0',
  `tips` tinyint(1) DEFAULT '0',
  `type` int(10) unsigned DEFAULT '0',
  `name` varchar(256) COLLATE utf8_bin NOT NULL,
  `live_ts` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_ts` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `full_cate_id` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`skuid`),
  KEY `brand` (`brand`),
  KEY `full_cate_id` (`full_cate_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='product info list';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.product_category
CREATE TABLE IF NOT EXISTS `product_category` (
  `skuid` int(10) unsigned DEFAULT NULL,
  `category_id` int(10) unsigned DEFAULT NULL,
  KEY `skuid_jci` (`skuid`,`category_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='product map category set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.promotion
CREATE TABLE IF NOT EXISTS `promotion` (
  `promo_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subsidy_money` decimal(10,2) DEFAULT '0.00',
  `coupon_jq` mediumint(9) DEFAULT '0',
  `limitTimePromo` tinyint(1) DEFAULT '0',
  `coupon_score` int(10) unsigned DEFAULT '0',
  `member_special_level` int(10) unsigned DEFAULT NULL,
  `member_special_price` decimal(10,2) DEFAULT NULL,
  `add_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`promo_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='promotion set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.seller_3rd
CREATE TABLE IF NOT EXISTS `seller_3rd` (
  `id` int(10) unsigned NOT NULL,
  `name` char(32) COLLATE utf8_bin DEFAULT '',
  `url` char(128) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='3rd seller set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.slogan
CREATE TABLE IF NOT EXISTS `slogan` (
  `skuid` int(10) unsigned NOT NULL,
  `title` char(255) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`skuid`),
  KEY `title` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='full category set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.snapshoot
CREATE TABLE IF NOT EXISTS `snapshoot` (
  `skuid` int(10) unsigned NOT NULL COMMENT 'can be duplicated',
  `promo_id` int(10) unsigned NOT NULL COMMENT 'can be duplicated',
  `market_price` decimal(10,2) DEFAULT '0.00',
  `price` decimal(10,2) DEFAULT '0.00',
  `comment_count` int(10) unsigned DEFAULT '0',
  `comment_average_score` tinyint(3) unsigned DEFAULT '0',
  `add_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `skuid_promo_id` (`skuid`,`promo_id`),
  KEY `price` (`price`),
  KEY `comment_count` (`comment_count`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='snapshoot set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.z_comment_summary
CREATE TABLE IF NOT EXISTS `z_comment_summary` (
  `item_id` int(11) unsigned zerofill NOT NULL,
  `total_comments` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '全部评论',
  `good_comments` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '好评',
  `normal_comments` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '中评',
  `bad_comments` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '差评',
  `cs_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='comment summary';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.z_item_info
CREATE TABLE IF NOT EXISTS `z_item_info` (
  `item_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_list_no` char(20) COLLATE utf8_bin DEFAULT NULL,
  `item_name` char(80) COLLATE utf8_bin DEFAULT NULL,
  `item_devliver_pid` mediumint(10) unsigned NOT NULL DEFAULT '0' COMMENT '发货提供商',
  `item_type_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `item_list_no` (`item_list_no`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='item info list';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.z_service_provider
CREATE TABLE IF NOT EXISTS `z_service_provider` (
  `sp_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(80) COLLATE utf8_bin DEFAULT NULL,
  `url` char(80) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`sp_id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='provider list';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.z_snapshot_price
CREATE TABLE IF NOT EXISTS `z_snapshot_price` (
  `ss_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ss_price` decimal(10,2) unsigned NOT NULL,
  `item_id` int(11) unsigned zerofill NOT NULL,
  `ss_promotion_type` char(80) COLLATE utf8_bin DEFAULT NULL,
  `ss_comments` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论人数',
  `ss_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ss_id`),
  KEY `ss_comments` (`ss_comments`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='price history list';

-- Data exporting was unselected.


-- Dumping structure for table 360buy.z_type
CREATE TABLE IF NOT EXISTS `z_type` (
  `type_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(80) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`type_id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='item type list';

-- Data exporting was unselected.


-- Dumping database structure for 360buy_del
CREATE DATABASE IF NOT EXISTS `360buy_del` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `360buy_del`;


-- Dumping structure for table 360buy_del.active_coupon
CREATE TABLE IF NOT EXISTS `active_coupon` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `url` char(128) COLLATE utf8_bin DEFAULT '',
  `start_ts` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_ts` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `add_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='get coupon link set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.category
CREATE TABLE IF NOT EXISTS `category` (
  `category_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(32) COLLATE utf8_bin DEFAULT '',
  `url` char(128) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`category_id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='product category set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.full_category
CREATE TABLE IF NOT EXISTS `full_category` (
  `full_cate_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name_list` char(128) COLLATE utf8_bin DEFAULT '',
  `jd_id_list` char(32) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`full_cate_id`),
  KEY `name_list` (`name_list`),
  KEY `jd_id_list` (`jd_id_list`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='full category set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.gift
CREATE TABLE IF NOT EXISTS `gift` (
  `promo_id` int(10) unsigned NOT NULL,
  `skuid` int(10) unsigned NOT NULL,
  `type` int(10) unsigned DEFAULT '0',
  `number` int(10) unsigned DEFAULT '0',
  `state` smallint(5) unsigned DEFAULT '0',
  KEY `promo_id` (`promo_id`),
  KEY `skuid` (`skuid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='gift set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.product
CREATE TABLE IF NOT EXISTS `product` (
  `skuid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `skuidkey` char(32) COLLATE utf8_bin DEFAULT NULL,
  `brand` mediumint(9) DEFAULT '0',
  `tips` tinyint(1) DEFAULT '0',
  `type` int(10) unsigned DEFAULT '0',
  `name` varchar(256) COLLATE utf8_bin NOT NULL,
  `live_ts` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_ts` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `full_cate_id` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`skuid`),
  KEY `brand` (`brand`),
  KEY `full_cate_id` (`full_cate_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='product info list';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.product_category
CREATE TABLE IF NOT EXISTS `product_category` (
  `skuid` int(10) unsigned DEFAULT NULL,
  `category_id` int(10) unsigned DEFAULT NULL,
  KEY `skuid_jci` (`skuid`,`category_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='product map category set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.promotion
CREATE TABLE IF NOT EXISTS `promotion` (
  `promo_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subsidy_money` decimal(10,2) DEFAULT '0.00',
  `coupon_jq` mediumint(9) DEFAULT '0',
  `limitTimePromo` tinyint(1) DEFAULT '0',
  `coupon_score` int(10) unsigned DEFAULT '0',
  `member_special_level` int(10) unsigned DEFAULT NULL,
  `member_special_price` decimal(10,2) DEFAULT NULL,
  `add_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`promo_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='promotion set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.seller_3rd
CREATE TABLE IF NOT EXISTS `seller_3rd` (
  `id` int(10) unsigned NOT NULL,
  `name` char(32) COLLATE utf8_bin DEFAULT '',
  `url` char(128) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='3rd seller set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.snapshoot
CREATE TABLE IF NOT EXISTS `snapshoot` (
  `skuid` int(10) unsigned NOT NULL COMMENT 'can be duplicated',
  `promo_id` int(10) unsigned NOT NULL COMMENT 'can be duplicated',
  `market_price` decimal(10,2) DEFAULT '0.00',
  `price` decimal(10,2) DEFAULT '0.00',
  `comment_count` int(10) unsigned DEFAULT '0',
  `comment_average_score` tinyint(3) unsigned DEFAULT '0',
  `add_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `skuid_promo_id` (`skuid`,`promo_id`),
  KEY `price` (`price`),
  KEY `comment_count` (`comment_count`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='snapshoot set';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.z_comment_summary
CREATE TABLE IF NOT EXISTS `z_comment_summary` (
  `item_id` int(11) unsigned zerofill NOT NULL,
  `total_comments` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '全部评论',
  `good_comments` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '好评',
  `normal_comments` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '中评',
  `bad_comments` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '差评',
  `cs_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='comment summary';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.z_item_info
CREATE TABLE IF NOT EXISTS `z_item_info` (
  `item_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_list_no` char(20) COLLATE utf8_bin DEFAULT NULL,
  `item_name` char(80) COLLATE utf8_bin DEFAULT NULL,
  `item_devliver_pid` mediumint(10) unsigned NOT NULL DEFAULT '0' COMMENT '发货提供商',
  `item_type_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `item_list_no` (`item_list_no`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='item info list';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.z_service_provider
CREATE TABLE IF NOT EXISTS `z_service_provider` (
  `sp_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(80) COLLATE utf8_bin DEFAULT NULL,
  `url` char(80) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`sp_id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='provider list';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.z_snapshot_price
CREATE TABLE IF NOT EXISTS `z_snapshot_price` (
  `ss_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ss_price` decimal(10,2) unsigned NOT NULL,
  `item_id` int(11) unsigned zerofill NOT NULL,
  `ss_promotion_type` char(80) COLLATE utf8_bin DEFAULT NULL,
  `ss_comments` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论人数',
  `ss_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ss_id`),
  KEY `ss_comments` (`ss_comments`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='price history list';

-- Data exporting was unselected.


-- Dumping structure for table 360buy_del.z_type
CREATE TABLE IF NOT EXISTS `z_type` (
  `type_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(80) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`type_id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='item type list';

-- Data exporting was unselected.


-- Dumping database structure for 360buy_dm
CREATE DATABASE IF NOT EXISTS `360buy_dm` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `360buy_dm`;


-- Dumping structure for table 360buy_dm.pid_check_list
CREATE TABLE IF NOT EXISTS `pid_check_list` (
  `id` bigint(20) unsigned NOT NULL,
  `status` enum('INIT','INVALID','REMOVE','NORMAL') DEFAULT 'INIT',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table 360buy_dm.pid_check_list_bk
CREATE TABLE IF NOT EXISTS `pid_check_list_bk` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table 360buy_dm.proxy_list
CREATE TABLE IF NOT EXISTS `proxy_list` (
  `proxy_server` char(21) NOT NULL COMMENT 'IP+:+Port',
  `test_passed_times` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`proxy_server`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping database structure for 360buy_dm_asc
CREATE DATABASE IF NOT EXISTS `360buy_dm_asc` /*!40100 DEFAULT CHARACTER SET ascii */;
USE `360buy_dm_asc`;


-- Dumping structure for table 360buy_dm_asc.pid_check_list
CREATE TABLE IF NOT EXISTS `pid_check_list` (
  `id` bigint(20) unsigned NOT NULL,
  `status` enum('INIT','INVALID','REMOVE','NORMAL') DEFAULT 'INIT',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii;

-- Data exporting was unselected.


-- Dumping structure for table 360buy_dm_asc.pid_check_list_bk
CREATE TABLE IF NOT EXISTS `pid_check_list_bk` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii;

-- Data exporting was unselected.


-- Dumping structure for table 360buy_dm_asc.proxy_list
CREATE TABLE IF NOT EXISTS `proxy_list` (
  `proxy_server` char(21) NOT NULL COMMENT 'IP+:+Port',
  `test_passed_times` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`proxy_server`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii;

-- Data exporting was unselected.


-- Dumping database structure for 360buy_dm_utf8
CREATE DATABASE IF NOT EXISTS `360buy_dm_utf8` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `360buy_dm_utf8`;


-- Dumping structure for table 360buy_dm_utf8.job_list
CREATE TABLE IF NOT EXISTS `job_list` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT 'noname',
  `status` enum('INIT','INVALID','REMOVE','NORMAL') DEFAULT 'INIT',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table 360buy_dm_utf8.pid_check_list
CREATE TABLE IF NOT EXISTS `pid_check_list` (
  `id` bigint(20) unsigned NOT NULL,
  `status` enum('INIT','INVALID','REMOVE','NORMAL') DEFAULT 'INIT',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table 360buy_dm_utf8.pid_check_list_bk
CREATE TABLE IF NOT EXISTS `pid_check_list_bk` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table 360buy_dm_utf8.proxy_list
CREATE TABLE IF NOT EXISTS `proxy_list` (
  `proxy_server` char(21) NOT NULL COMMENT 'IP+:+Port',
  `test_passed_times` int(10) unsigned DEFAULT '0',
  `type` enum('HTTP','HTTPS') DEFAULT 'HTTP',
  PRIMARY KEY (`proxy_server`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table 360buy_dm_utf8.yiilog
CREATE TABLE IF NOT EXISTS `yiilog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` varchar(128) DEFAULT NULL,
  `category` varchar(128) DEFAULT NULL,
  `logtime` int(11) DEFAULT NULL,
  `message` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

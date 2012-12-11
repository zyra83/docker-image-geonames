DROP DATABASE IF EXISTS geoname; 
CREATE DATABASE geoname; 
USE geoname; 

--
-- Table structure for table `admin1_codes`
--

CREATE TABLE `admin1_codes` (
  `code` varchar(255) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `ascii_label` varchar(255) DEFAULT NULL,
  `geoname_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `idx_geoname_id` (`geoname_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Level 1 administrations (régions pour la France)';

--
-- Table structure for table `admin2_codes`
--

CREATE TABLE `admin2_codes` (
  `code` varchar(255) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `ascii_label` varchar(255) DEFAULT NULL,
  `geoname_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `idx_geoname_id` (`geoname_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `alternate_names`
--

CREATE TABLE `alternate_names` (
  `id` bigint(20) NOT NULL,
  `geoname_id` bigint(20) DEFAULT NULL,
  `iso_language` varchar(255) DEFAULT NULL,
  `alternate_name` varchar(255) DEFAULT NULL,
  `is_preferred_name` varchar(255) DEFAULT NULL,
  `is_short_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_geoname_id` (`geoname_id`),
  KEY `idx_iso_language` (`iso_language`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `continent_codes`
--

CREATE TABLE `continent_codes` (
  `code` char(2) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `geoname_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `country_infos`
--

CREATE TABLE `country_infos` (
  `iso_alpha2` char(2) NOT NULL,
  `iso_alpha3` char(3) DEFAULT NULL,
  `iso_numeric` int(11) DEFAULT NULL,
  `fips` varchar(3) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `capital` varchar(200) DEFAULT NULL,
  `area` varchar(244) DEFAULT NULL,
  `population` int(11) DEFAULT NULL,
  `continent` char(2) DEFAULT NULL,
  `tld` char(3) DEFAULT NULL,
  `currency` char(3) DEFAULT NULL,
  `currency_name` char(20) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `postal_code_format` varchar(255) DEFAULT NULL,
  `postal_code_regex` varchar(255) DEFAULT NULL,
  `languages` varchar(200) DEFAULT NULL,
  `geoname_id` bigint(20) DEFAULT NULL,
  `neighbours` varchar(255) DEFAULT NULL,
  `equivalent_fips_code` char(10) DEFAULT NULL,
  PRIMARY KEY (`iso_alpha2`),
  KEY `idx_1` (`iso_alpha3`),
  KEY `idx_2` (`iso_numeric`),
  KEY `idx_3` (`geoname_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `feature_codes`
--

CREATE TABLE `feature_codes` (
  `code` varchar(10) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `geonames`
--

CREATE TABLE `geonames` (
  `id` int(11) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `ascii_name` varchar(200) DEFAULT NULL,
  `alternate_names` text,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `feature_class` varchar(1) DEFAULT NULL,
  `feature_code` varchar(10) DEFAULT NULL,
  `country_code` varchar(2) DEFAULT NULL,
  `cc2` varchar(60) DEFAULT NULL,
  `admin1_code` varchar(20) DEFAULT NULL,
  `admin2_code` varchar(80) DEFAULT NULL,
  `admin3_code` varchar(20) DEFAULT NULL,
  `admin4_code` varchar(20) DEFAULT NULL,
  `population` bigint(20) DEFAULT NULL,
  `elevation` bigint(20) DEFAULT NULL,
  `dem` varchar(255) DEFAULT NULL,
  `timezone` varchar(40) DEFAULT NULL,
  `modification` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_elevation` (`elevation`),
  KEY `idx_feature_code` (`feature_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `iso_language_codes`
--

CREATE TABLE `iso_language_codes` (
  `iso_639_3` char(4) DEFAULT NULL,
  `iso_639_2` varchar(50) DEFAULT NULL,
  `iso_639_1` varchar(50) DEFAULT NULL,
  `language_name` varchar(200) DEFAULT NULL,
  KEY `idx_1` (`iso_639_3`),
  KEY `idx_2` (`iso_639_2`),
  KEY `idx_3` (`iso_639_1`),
  KEY `idx_4` (`language_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `time_zones`
--

CREATE TABLE `time_zones` (
  `id` varchar(255) NOT NULL,
  `gmt_offset_20120101` decimal(4,2) DEFAULT NULL,
  `dst_offset_20120701` decimal(4,2) DEFAULT NULL,
  `raw_offset` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `user_tags`
--

CREATE TABLE `user_tags` (
  `geoname_id` bigint(20) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  KEY `idx_1` (`geoname_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA INFILE 'L:/www/js-geonames/import/dl/admin1CodesASCII.txt' 
INTO TABLE geoname.admin1_codes;

LOAD DATA INFILE 'L:/www/js-geonames/import/dl/admin2Codes.txt' 
INTO TABLE geoname.admin2_codes;

LOAD DATA INFILE 'L:/www/js-geonames/import/dl/alternateNames.txt' 
INTO TABLE geoname.alternate_names
(
    id,
    geoname_id,
    @iso_language,
    @alternate_name,
    @is_preferred_name,
    @is_short_name
)
SET
iso_language = nullif(@iso_language, ''),
alternate_name = nullif(@alternate_name, ''),
is_preferred_name = if(@is_preferred_name = 1, true, false),
is_short_name = if(@is_short_name = 1, true, false);

LOAD DATA INFILE 'L:/www/js-geonames/import/data/continentCodes.txt' 
INTO TABLE geoname.continent_codes FIELDS 
TERMINATED BY ',' (code, name, geoname_id);

/*
 La colonne area a un tuple avec la valeur 10938E+4 en notation scientifique
*/
LOAD DATA INFILE 'L:/www/js-geonames/import/dl/countryInfo-n.txt' 
INTO TABLE geoname.country_infos
(
    iso_alpha2,
    iso_alpha3,
    iso_numeric,
    fips,
    name,
    capital,
    area,
    population,
    continent,
    tld,
    currency,
    currency_name,
    phone,
    postal_code_format,
    postal_code_regex,
    languages,
    @geoname_id,
    neighbours,
    equivalent_fips_code
)
SET geoname_id = nullif(@geoname_id,'');

LOAD DATA INFILE 'L:/www/js-geonames/import/dl/featureCodes_en.txt' 
INTO TABLE geoname.feature_codes
(
    code,
    name,
    @description
)
SET description = nullif(@description, '');

LOAD DATA INFILE 'L:/www/js-geonames/import/dl/allCountries.txt' 
INTO TABLE geoname.geonames
(
    id,
    name,
    ascii_name,
    alternate_names,
    latitude,
    longitude,
    feature_class,
    feature_code,
    country_code,
    @cc2,
    admin1_code,
    @admin2_code,
    @admin3_code,
    @admin4_code,
    population,
    @elevation,
    dem,
    @timezone,
    modification
)
SET elevation = nullif(@elevation,''),
cc2 = nullif(@cc2,''),
admin2_code = nullif(@admin2_code,''),
admin3_code = nullif(@admin3_code,''),
admin4_code = nullif(@admin4_code,''),
timezone = nullif(@timezone,'');

LOAD DATA INFILE 'L:/www/js-geonames/import/dl/iso-languagecodes.txt' 
INTO TABLE geoname.iso_language_codes
IGNORE 1 LINES
(
    @iso_639_3,
    @iso_639_2,
    @iso_639_1,
    @language_name
)
SET iso_639_3 = nullif(@iso_639_3,''),
iso_639_2 = nullif(@iso_639_2,''),
iso_639_1 = nullif(@iso_639_1,''),
language_name = nullif(@language_name,'');

LOAD DATA INFILE 'L:/www/js-geonames/import/dl/timeZones.txt' 
INTO TABLE geoname.time_zones
IGNORE 1 LINES;

LOAD DATA INFILE 'L:/www/js-geonames/import/dl/userTags.txt' 
INTO TABLE geoname.user_tags;
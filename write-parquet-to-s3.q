--Example of converting to Parquet/columnar formats
ADD JAR /usr/lib/hive-hcatalog/share/hcatalog/hive-hcatalog-core-1.0.0-amzn-5.jar;

SET hive.mapred.supports.subdirectories=TRUE;
SET mapred.input.dir.recursive=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

CREATE EXTERNAL TABLE `openaqrealtime_4parquet`(
  `date` struct<utc:string,local:string> COMMENT 'from deserializer', 
  `parameter` string COMMENT 'from deserializer',
  `location` string COMMENT 'from deserializer', 
  `value` float COMMENT 'from deserializer', 
  `unit` string COMMENT 'from deserializer', 
  `city` string COMMENT 'from deserializer', 
  `attribution` array<struct<name:string,url:string>> COMMENT 'from deserializer', 
  `averagingperiod` struct<unit:string,value:float> COMMENT 'from deserializer', 
  `coordinates` struct<latitude:float,longitude:float> COMMENT 'from deserializer', 
  `country` string COMMENT 'from deserializer', 
  `sourcename` string COMMENT 'from deserializer', 
  `sourcetype` string COMMENT 'from deserializer', 
  `mobile` string COMMENT 'from deserializer')
ROW FORMAT serde 'org.apache.hive.hcatalog.data.JsonSerDe'
LOCATION '${hiveconf:INPUT}';
 
CREATE EXTERNAL TABLE openaq_parquet (
  `date` struct<utc:string,local:string>, 
  `parameter` string,
  `location` string,
  `value` double, 
  `unit` string, 
  `city` string, 
  `attribution` array<struct<name:string,url:string>>, 
  `averagingperiod` struct<unit:string,value:float>, 
  `coordinates` struct<latitude:float,longitude:float>,
  `sourcename` string, 
  `sourcetype` string, 
  `mobile` boolean)
PARTITIONED BY (country string)
STORED AS PARQUET
LOCATION '${hiveconf:OUTPUT}';

INSERT OVERWRITE TABLE openaq_parquet
PARTITION (country)
SELECT date,parameter,location,value,unit,city,attribution,averagingperiod,coordinates,sourcename,sourcetype,mobile,country
FROM openaqrealtime_4parquet;

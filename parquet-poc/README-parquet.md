# Converting OpenAQ JSON data to parquet using Athena

Steps taken from [Converting to Columnar Formats](https://docs.aws.amazon.com/athena/latest/ug/convert-to-columnar.html)

1. Export user-specific variables

**NOTE:** You can process the whole archive by exporting

```bash
export S3_INPUT=s3://openaq-fetches/realtime-gzipped
```

or process data for a single day:

```bash
export S3_INPUT=s3://openaq-fetches/realtime-gzipped/2019-04-26
```

```bash
export QUERY_FILE=s3://xxx/write-parquet-to-s3.q
export REGION=us-east-1
export KEYNAME=xxx
export SUBNET=subnet-xxxxxxxx
export LOG_URI=s3://xxx/emr_logs
export S3_OUTPUT=s3://xxx/openaq_parquet
```

2. Upload the query
```bash
aws s3 cp write-parquet-to-s3.q ${QUERY_FILE}
```

3. Create the EMR cluster and add the convert to parquet step
```bash
aws emr create-cluster \
  --applications Name=Hadoop Name=Hive Name=HCatalog \
  --ec2-attributes \
  KeyName=${KEYNAME},InstanceProfile=EMR_EC2_DefaultRole,SubnetId=subnet-4f946228 \
  --service-role EMR_DefaultRole \
  --release-label emr-4.7.0 \
  --instance-type c4.4xlarge \
  --instance-count 4 \
  --steps Type=HIVE,Name="Convert to Parquet",ActionOnFailure=TERMINATE_CLUSTER,Args=[-f,${QUERY_FILE},-hiveconf,INPUT=${S3_INPUT},-hiveconf,OUTPUT=${S3_OUTPUT},-hiveconf,REGION=${REGION}] \
  --region ${REGION} \
  --auto-terminate \
  --log-uri ${LOG_URI}
```

4. Create the table in Athena and run a test query

```bash
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
LOCATION 's3://aimeeb-emr/openaq_parquet';
```


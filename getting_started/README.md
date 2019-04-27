
Getting started with the OpenAQ data

# Getting Data

## Athena

*URL:* https://tinyurl.com/openaqdkdc-athena
See Joe for the account credentials

Once you're logged into the Athena instance you can run SQL queries against the `fetches` table.

This will get all the pm25 data for the city of Delhi for the year 2019.

```sql
SELECT *
FROM fetches
WHERE date.utc
    BETWEEN '2019-01-01'
        AND '2019-12-31'
        AND parameter = 'pm25'
        AND value >= 0
        AND city = 'Delhi';
```

Once the query finishes, you can export the CSV that can be loaded for further analysis and visualization.

## R

Only provides last 90 days of information

https://ropensci.github.io/ropenaq/index.html

## Python

Only provides last 90 days of information

http://dhhagan.github.io/py-openaq/index.html

# Looking for locations

The locations can be found under the data tab in the OpenAQ website: https://openaq.org/

You can also use the V1 API locations endpoint (use the JSON view chrome extension to render it nicely): https://api.openaq-staging.org/v1/locations


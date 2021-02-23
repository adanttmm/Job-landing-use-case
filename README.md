# Answers to DiDi's BI challenge

As a first step I set up a MySQL database on my localhost, and tried to load the csv files into it. Here I noticed that the 'restaurants_visitors' file has corrupted data on the 'visit_date' column; since there's the 'visit_datetime' column and it has complete data, the missing rows can be recovered. Once this was done the file had no problems loading into the database and I was able to star working on the challenges.

 ----------------------------------------
 ## Q1
 - List with the top 5 restaurants with highest average visits on holidays:

 |Restaurant ID|Avg. visits on holidays|
|---|------------------|
|0a74a5408a0b8642|33.2727|
|e053c561f32acc28|30.6364|
|db80363d35f10926|25.2000|
|42c9aa6d617c5057|18.8571|
|36429b5ca4407b3e|18.4444|

> SQL code on challenge1.sql
 
 ----------------------------------------
 ## Q2
 - The day with largest expected traffic is Staurday, which make sense to be expected:

|Day of the week|Avg. visits per weekday|
|-----------|---------------------|
|Saturday|193.8525|
|Friday|181.0820|
|Thursday|114.5085|
|Wednesday|92.2623|
|Sunday|79.9667|
|Monday|79.6949|
|Tuesday|76.9825|

> SQL code on challenge1.sql
 
 


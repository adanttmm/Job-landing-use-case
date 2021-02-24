# Answers to DiDi's BI challenge

As a first step I set up a MySQL database on my localhost, and tried to load the csv files into it. Here I noticed that the 'restaurants_visitors' file has corrupted data on the 'visit_date' column; since there's the 'visit_datetime' column and it has complete data, the missing rows can be recovered. Once this was done the file had no problems loading into the database and I was able to star working on the challenges.

 ----------------------------------------
 ## Challenge 1
 - List with the top 5 restaurants with highest average visits on holidays:

 |Restaurant ID|Avg. visits on holidays|
|---|------------------|
|0a74a5408a0b8642|33.2727|
|e053c561f32acc28|30.6364|
|db80363d35f10926|25.2000|
|42c9aa6d617c5057|18.8571|
|36429b5ca4407b3e|18.4444|

> SQL code on [challenge1.sql](https://github.com/adanttmm/DiDi_case/blob/main/challenge1.sql)
 
 ----------------------------------------
 ## Challenge 2
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

> SQL code on [challenge2.sql](https://github.com/adanttmm/DiDi_case/blob/main/challenge2.sql)
 
 ----------------------------------------
 ## Challenge 3
 - The growth week over week the las 4 weeks of data is negative, which means that theres a contraction on business driven mainly by the fact that the number of restaurants logging data decrease to only 2 the last week vs almost 30 on on previos periods:

|Year|Week number|Restaurants loggind data|% variation vs previous week|
|---------------|---------------|---------------|--------------|
|2017|22|2|-0.7619|
|2017|21|5|-0.1923|
|2017|20|7|-0.5543|
|2017|19|12|0.0671|

> SQL code on [challenge3.sql](https://github.com/adanttmm/DiDi_case/blob/main/challenge3.sql)
 
----------------------------------------
 ## Challenge 4
- To forecast the incoming 6 months first I query the data to get the visitors per day and the number of restaurants which logged the data (this in response to the insight found on the previous challenge), and put it into a csv file.
> SQL code on [challenge4.sql](https://github.com/adanttmm/DiDi_case/blob/main/challenge4.sql)
- I load the data on a pandas dataframe to work with it in Python, and start analyzing it:
 \s
  1. I explore the data looking at some overall statistics and the trend overtime:
 \s
  This is the head of the dataset:

|date|	num_rest|	num_visits|
|---|---|---|
|0|	2016-01-02|	1|	34|
|1|	2016-01-03|	1|	17|
|2|	2016-01-04|	1|	7|
|3|	2016-01-06|	3|	19|
|4|	2016-01-07|	1|	7|
 
  And some basic statistics:
    
|statistic|num_rest	|num_visits|
|---|---|---|
|count|	418.000000	|418.000000|
|mean|	8.811005|	117.566986|
|std	|7.547781	|125.268064|
|min	|1.000000	|2.000000|
|25%	|2.000000	|25.000000|
|50%	|4.500000	|68.500000|
|75%	|15.000000|	168.750000|
|max	|26.000000|	644.000000|  

  2. I see that there's 418 days of data spaning over a 517 days period; this means there's missing data. Looking at the linechart it's clear that the missing data is between August and October 2016, so this will have to be addressed:
![linechart](https://github.com/adanttmm/DiDi_case/blob/main/linechart_1.png) 

  Benchmarking multiple interpolation methods: 
![interpolation methods](https://github.com/adanttmm/DiDi_case/blob/main/linechart_2.png)

  I ended up selecting just imputing with the mean seen until July 25th 2016, because it's the more simple, yet sensible trend
![imputing mean](https://github.com/adanttmm/DiDi_case/blob/main/linechart_3.png)  
  
  3. Mooving into the forecasting, first I see the seasonal decomposition of the time series that shows a clear weekly seasinality, and identify that there appears to be four periods with different behavior on the trend:
    - Previous to Aug'16 there's a flat trend with a slight growth.
    - From Nov'16 to Jan'17 large growth.
    - It drops at the begining of 2017 but remains stable until May'17.
    - Posterior to May'17 it drops again to levels from early 2016.  
![seasonal decomposition complete](https://github.com/adanttmm/DiDi_case/blob/main/seasonal_decomposition1.png)  

I chose to exclude the data previous to Nov'16, because it looks like the business from early 2016 was a complete different phenomenon, this produces a variation on the residuals which in turn could affect the forecast with heteroscedasticity. 
Keeping the change in Jan'17 makes sense, since this could easily be explained by the usual drop in spent after the holidays.
It appears that mid 2017 there was a challenging situation, because the drop in visitors look to big to be explainde by the same reason as the first months, so I also keep this data because there's no indication of corrupted data or an error that could impact the analysis.
The final decomposition still shows a little increase in variation for the residuals arround January, but I already chose to keep it because is informative and relevant for the model.
![seasonal decomposition final](https://github.com/adanttmm/DiDi_case/blob/main/seasonal_decomposition2.png) 







  5.  








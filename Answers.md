# Answers to DiDi's BI challenge

As a first step I set up a MySQL database on my localhost, and tried to load the csv files into it. Here I noticed that the 'restaurants_visitors' file has corrupted data on the 'visit_date' column; since there's the 'visit_datetime' column and it has complete data, the missing rows can be recovered. Once this was done the file had no problems loading into the database and I was able to start working on the challenges.

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
 - The day with largest expected traffic is Saturday, which make sense to be expected:

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
 - The growth week over week the last 4 weeks of data is negative, which means that there's a contraction on business driven mainly by the fact that the number of restaurants logging data decrease to only 2 the last week vs almost 30 on on previous periods:

|Year|Week number|Restaurants logging data|% variation vs previous week|
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
 
  1. I explore the data looking at some overall statistics and the trend overtime:
 
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

  2. I see that there's 418 days of data spanning over a 517 days period; this means there's missing data. Looking at the line chart it's clear that the missing data is between August and October 2016, so this will have to be addressed:
![line chart](https://github.com/adanttmm/DiDi_case/blob/main/linechart_1.png) 

  Benchmark multiple interpolation methods: 
![interpolation methods](https://github.com/adanttmm/DiDi_case/blob/main/linechart_2.png)

  I ended up selecting just imputing with the mean seen until July 25th 2016, because it's the more simple, yet sensible trend
![imputing mean](https://github.com/adanttmm/DiDi_case/blob/main/linechart_3.png)  
  
  3. In the seasonal decomposition of the time series there's a clear weekly seasonality, and identify that there appears to be four periods with different behavior on the trend:

  - Previous to Aug'16 there's a flat trend with a slight growth.
  - From Nov'16 to Jan'17 large growth.
  - It drops at the beginning of 2017 but remains stable until May'17.
  - Posterior to May'17 it drops again to levels from early 2016.  
![seasonal decomposition complete](https://github.com/adanttmm/DiDi_case/blob/main/seasonal_decomposition1.png)  

There's also atypical values on Dec'16 which may correspond to christmas and new year's eve; depending on the forecasting method, these are treated (Autoregressive) or not (Exponential Smoothing). First I separate train and test datasets to measure model accuracy, and after selection retrain with the whole dataset for forecasting. 

  4. The final autoregressive model has a mean absolute percentage error (MAPE) of 1.6%. It has a good performance, but the forecast turns out nonsensical so I move on to other method:
![Autoregressive model](https://github.com/adanttmm/DiDi_case/blob/main/ARIMA%20forecast.png)  


  5. Finally I get great performance from exponential smoothing, with MAPE of 0.81% and a much better forecast:
![Exponential smoothing](https://github.com/adanttmm/DiDi_case/blob/main/SES%20benchmark%20final.png)

### In the end the forecast for the next 6 months is of a total ***2,853*** visitors and an average of ***15.6*** visitors per day. 

>Python notebook on [forecast notebook](https://github.com/adanttmm/DiDi_case/blob/main/DiDi%20challenge%20forecasting.ipynb)
----------------------------------------
## Challenge 5

- First I would go after the restaurants that have logged data before but stopped, prioritizing the ones that used to do better than average. This is an opportunity of 20 out of 39 restaurants which haven't logged data since Apr'17. It's important to see what can be done with this customers, since usually retaining is cheaper and more effective than bringing new ones, and looking at the average forecasted per day, and the average visits on holidays of the top restaurants, recovering just one out of this would greatly improve results:

|Restaurant ID|Last date|
|---|--------|
|234d3dbf7f3d5a50|2016-04-30|
|aed3a8b49abe4a48|2016-09-12|
|1d1e8860ae04f8e9|2016-12-26|
|8cc350fd70ee0757|2017-01-11|
|d500b48a8735fbd3|2017-01-24|
|dc71c6cc06cd1aa2|2017-02-10|
|e01d99390355408d|2017-02-14|
|1f1390a8be2272b3|2017-03-03|
|2c6c79d597e48096|2017-03-14|
|d477b6339b8ce69f|2017-03-30|
|00a91d42b08b08d9|2017-04-04|
|6b2268863b14a2af|2017-04-08|
|f0fb0975bdc2cdf9|2017-04-15|
|45326ebb8dc72cfb|2017-04-19|
|e89735e80d614a7e|2017-04-21|
|3440e0ea1b70a99b|2017-04-22|
|831658500aa7c846|2017-04-26|
|632ba66e1f75aa28|2017-04-27|
|f068442ebb6c246c|2017-04-28|
|bcce1ea4350b7b72|2017-04-28|

- Looking at the effect from the number of restaurants logging data, the next most impactful action would be to attract new restaurants to bring new visitors to the platform; I looked at the daily average visits per restaurant per genre, and see that *Izakaya* are by much the preferred alternative, so this restaurants would be the priority, followed by *Western*, *Italian/French*, *Dining bar*, and *Japanese* which are the next in popularity.

|Genre|Avg. visitors per restaurant|
|----------|------------|
|Izakaya|52.7165|
|Western food|29.3281|
|Italian/French|28.5637|
|Dining bar|26.6289|
|Japanese food|26.1653|
|Bar/Cocktail|13.8286|
|Cafe/Sweets|10.2695|
|Yakiniku/Korean food|9.6149|
|Other|5.1758|

- Also using the restaurant data I can look at the better performing zones, and focus on gathering restaurants on those geographies:

![restaurants geolocation](https://github.com/adanttmm/DiDi_case/blob/main/map_visits.png)

- Lastly to help low performing restaurants, I would suggest promotional campaigns like discounts or loyalty programs to boost their sales. To increase effectivity, and ensure a good execution from the restaurants, I would set a ranking so they know how they compare vs other restaurants of the same category, and compete to get the best ranking places; depending on budget an additional benefit like a badge or trophy could be useful to motivate the owners, and showcase their ranking.

>SQL code on [challenge5.sql](https://github.com/adanttmm/DiDi_case/blob/main/challenge5.sql)

>Python notebook on [geolocation notebook](https://github.com/adanttmm/DiDi_case/blob/main/Geolocation%20restaurants.ipynb)

----------------------------------------
## Challenge 6

- I would join the data published by the government statistics department (INEGI) on economics by geolocation (AGEB). This data is thought to help small and medium businesses with information on socio-economic level, demographics, volume of businesses by type. Finding correlation with the restaurant performance and the zones they're in could help focus on the ones with better chances to improve, and target new restaurants on successful zones.
- Gathering data on past and future local holidays would be a must, because even if it's not very relevant for Japan, those particular dates could prove important to launch campaigns that boost performance.
- Here restaurants and apps usually survey customers, to get data on their products and services. This would be paramount to find opportunities for each restaurant and build personalized recommendations for the customers.
- Payment information would be very interesting to see if the restaurants that offer different alternatives for payment, like credit cards and restaurant coupons, perform better.     

----------------------------------------
## Challenge 7

- The most clear channels would be the app stores. To estimate the cost I get the global average cost per install for the most popular devices (IOs with $0.86usd and Android $0.44usd found on [CPIs](https://www.businessofapps.com/ads/cpi/research/cost-per-install/)). This is a good starting point, and then I'd monitor the KPIs from each marketplace to get the cost, which I would then adjust to include the spent on out of home and traditional marketing to include the efforts to drive organic traffic.
- Next I'd check the digital campaigns, which have their cost per acquisition and tools to optimize.
- I guess that there's commercial partners that drive app downloads, and its cost may be estimated accounting for the investment the partners require, the volume of apps they drive (maybe through their websites, intranets, employees, etc.) and the direct benefit of the relationship.

----------------------------------------
## Challenge 8
  

- The first step would be to define the target variable and the performance time window for the model (the timeframe that will be checked to see the result of the target variable), this goes alongside choosing a time period that will be used for training the model, and and out of time validation dataset corresponding to the performance window of the target variable. 
- For target variable I'd choose a flag for whether the customer had a trip on the performance window or not.
- The variables I think would be relevant are:
  - Seniority measured as the difference between the date of registry and the current date.
  - Average weekly trips.
  - Total number of trips.
  - Average amount spent per trip.
  - Total amount spent.
  - Days since last trip.
  - Trips by week of the year to check for seasonal behavior.
  - Average hour of the day in which the user travels (maybe flag late night, business hours, and early morning trips).
  - Last trip amount spent.
  - Last trip hour if the day.
  - Last trip weekday. 
  - Average ratings from previous trips.
  - Last trip rating.
  - Average waiting time before start.
  - Average time since start.
  - Last trip time since start. 
  - Last trip waiting time before start.
  - Number of canceled trips.
  - Flag if last trip was canceled.
  - Number of disrupted trips.
  - Flag if last trip had disruption.
  - Previous complaints.
  - Flag if last trip had complaint.
- I would run a variable selection process using correlation with the target, or variable reduction with L1 correction on a linear model.
- For the modeling process rather than choosing an apriori method, I'd first run a benchmark of multiple models trained on a sample, and then use the best one for fine-tunning, using grid-search with cross validation to pick the best hyperparamenters. For this problem in particular I'd benchmark:
  -  Logistic regression with L1 and L2.
  -  Classification tree.
  -  Random forest.
  -  XGboost.
  -  Neural network.
  -  SVM.
  -  KNN.


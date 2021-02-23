
select 
	rv.visit_date,
	count(DISTINCT rv.id) as num_restaturants,
	sum(reserve_visitors) as sum_visitors
from restaurants_visitors rv 
group by rv.visit_date 
INTO OUTFILE '/var/lib/mysql-files/visitors_ts.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
;

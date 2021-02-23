drop table if exists visits_per_week;

create temporary table visits_per_week as
SELECT 
	'd_1' as aux1,
	year(rv.visit_date) as year_visit_date,
	week(rv.visit_date) as week_visit_date,
	sum(rv.reserve_visitors) as sum_visitors,
	count(DISTINCT rv.id) as num_restaurants
from restaurants_visitors rv 
group by 
	year(rv.visit_date),
	week(rv.visit_date)
order by 
	year(rv.visit_date) DESC,
	week(rv.visit_date) desc
;
	

SELECT 
	vpw.year_visit_date,
	vpw.week_visit_date,
	vpw.num_restaurants,
	vpw.sum_visitors/lead(sum_visitors,1) over (PARTITION by aux1 order by vpw.year_visit_date desc, vpw.week_visit_date desc) - 1  as pct_weekly_var
from visits_per_week vpw
limit 4;
	
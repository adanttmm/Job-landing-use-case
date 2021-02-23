drop table if exists visits_by_date;

create temporary table visits_by_date as
select DISTINCT 
	rv.id,
	rv.visit_date, 
	sum(rv.reserve_visitors) as sum_visits
from restaurants_visitors rv 
group by 
	rv.id,
	rv.visit_date
;

select
	di.day_of_week,
	sum(vbd.sum_visits)/count(distinct di.calendar_date) as avg_visits_by_weekday
from date_info di 
	join visits_by_date vbd on (vbd.visit_date = di.calendar_date)
group by di.day_of_week 
order by sum(vbd.sum_visits)/count(distinct di.calendar_date) desc
;
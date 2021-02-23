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
	vbd.id,
	sum(sum_visits)/count(1) as avg_holiday_visits
from visits_by_date vbd
	join date_info di on (di.calendar_date = vbd.visit_date)
where di.holiday_flag = 1
group by vbd.id
order by sum(sum_visits)/count(1) DESC
limit 5
;





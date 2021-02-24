
-- FIRST COMMENT

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


SELECT 
	si.genre_name,
	sum(vbd.sum_visits)/count(distinct vbd.visit_date) as avg_visitors
from visits_by_date vbd 
	join store_info si  on (si.store_id = vbd.id)
group by 
	si.genre_name
order by sum(vbd.sum_visits)/count(distinct vbd.visit_date) desc
;

select 
	min(latitude) as latitude_min,
	max(latitude) as latitude_max,
	min(longitude) as longitude_min,
	max(longitude) as longitude_max
from store_info si 
;

-- SECOND COMMENT


SELECT 
	si.genre_name,
	si.store_id,
	si.latitude,
	si.longitude,
	sum(vbd.sum_visits)/count(distinct vbd.visit_date) as avg_visitors
from visits_by_date vbd 
	join store_info si  on (si.store_id = vbd.id)
group by 
	si.genre_name,
	si.store_id,
	si.latitude,
	si.longitude
order by sum(vbd.sum_visits)/count(distinct vbd.visit_date) desc
;

select 
	min(latitude) as latitude_min,
	
-- THIRD COMMENT
	
select
	vbd.id,
	max(vbd.visit_date) as max_date
from visits_by_date vbd
group by vbd.id
order by max(vbd.visit_date) asc 
;
	
-- FOURTH COMMENT
	
select
	di.holiday_flag, 
	vbd.visit_date,
	sum(vbd.sum_visits)/count(distinct vbd.id) as avg_traffic
from visits_by_date vbd
	join date_info di on (di.calendar_date = vbd.visit_date)
group by 
	di.holiday_flag, 
	vbd.visit_date
order by sum(vbd.sum_visits)/count(distinct vbd.id) asc 
;
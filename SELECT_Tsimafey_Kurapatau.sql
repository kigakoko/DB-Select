--1.1
select s.store_id, s.first_name, s.last_name, sum(p.amount) as total_revenue
from payment p
join staff s on p.staff_id = s.staff_id
where extract(year from p.payment_date) = 2017
group by s.store_id, s.first_name, s.last_name
order by total_revenue desc
limit 2;

--1.2
with staff_revenue as (
    select s.store_id, s.first_name, s.last_name, sum(p.amount) as total_revenue,
           rank() over (order by sum(p.amount) desc) as revenue_rank
    from payment p
    join staff s on p.staff_id = s.staff_id
    where extract(year from p.payment_date) = 2017
    group by s.store_id, s.first_name, s.last_name
)
select store_id, first_name, last_name, total_revenue
from staff_revenue
where revenue_rank <= 2;

--2.1
select f.title, f.rating, count(r.rental_id) as rental_count
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by f.film_id, f.title, f.rating
order by rental_count desc
limit 5;

--2.2
select f.title, f.rating, 
       (select count(r.rental_id) 
        from rental r 
        join inventory i on r.inventory_id = i.inventory_id 
        where i.film_id = f.film_id) as rental_count
from film f
order by rental_count desc
limit 5;

--3.1
select a.actor_id, a.first_name, a.last_name, max(f.release_year) as latest_year
from actor a
left join film_actor fa on a.actor_id = fa.actor_id
left join film f on fa.film_id = f.film_id
group by a.actor_id
order by latest_year asc;



--3.2
select a.actor_id, a.first_name, a.last_name, 
       (select max(f.release_year) 
        from film_actor fa 
        join film f on fa.film_id = f.film_id 
        where fa.actor_id = a.actor_id) as latest_year
from actor a
order by latest_year asc;

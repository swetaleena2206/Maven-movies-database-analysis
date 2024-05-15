use mavenmovies;

/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

SELECT 
	concat(staff.first_name,' ', staff.last_name) as Manager_Name, 
    address.address, 
    address.district, 
    city.city, 
    country.country

FROM store
	LEFT JOIN staff ON store.manager_staff_id = staff.staff_id
    LEFT JOIN address ON store.address_id = address.address_id
    LEFT JOIN city ON address.city_id = city.city_id
    LEFT JOIN country ON city.country_id = country.country_id;

/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/
SELECT 
	inventory.inventory_id,
    inventory.store_id,
    film.title,
    film.rating,
    film.rental_rate,
    film.replacement_cost
    
FROM inventory
	LEFT JOIN film 
    ON inventory.film_id = film.film_id;
    

/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
SELECT 
    inventory.store_id,
    film.rating,
	count(inventory.inventory_id) as total_number_of_inventories
FROM inventory
	LEFT JOIN film 
    ON inventory.film_id = film.film_id
    group by 1,2;

/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 
SELECT 
    inventory.store_id,
    category.name as category_name,
    AVG(film.replacement_cost) as Avg_replacement_cost,
    SUM(film.replacement_cost) as Total_replacement_cost,
	Count(film.film_id) as total_number_of_films
FROM inventory
	LEFT JOIN film ON inventory.film_id = film.film_id
    LEFT JOIN film_category ON film.film_id = film_category.film_id
    LEFT JOIN category ON film_category.category_id = category.category_id
GROUP BY 1,2
ORDER BY SUM(film.replacement_cost) DESC;


/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/
SELECT 
	concat(customer.first_name,' ', customer.last_name) as Customer_Name, 
    customer.store_id,
    customer.`active`,
    address.address, 
    city.city, 
    country.country
    
FROM customer
	LEFT JOIN store ON customer.store_id = store.store_id
    LEFT JOIN address ON store.address_id = address.address_id
    LEFT JOIN city ON address.city_id = city.city_id
    LEFT JOIN country ON city.country_id = country.country_id;

/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/
select * from rental;
SELECT 
	concat(customer.first_name,' ', customer.last_name) as Customer_Name, 
    COUNT(rental.rental_id) as Total_lifetime_rentals,
    SUM(payment.amount) as Total_payment
    
FROM customer
	LEFT JOIN rental ON customer.customer_id = rental.customer_id
    LEFT JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY 1
ORDER BY Total_payment DESC;
    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/

SELECT 'investor' AS Type, 
first_name, last_name, company_name FROM investor
UNION
SELECT 'advisor' AS Type,
first_name, last_name, 'null' AS company_name FROM advisor;


/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/
SELECT
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END AS number_of_awards,
   ((count(actor_id) / count(actor_award_id))* 100) as 'percent_of_actors_with_atleast_one_film'
FROM actor_award
group by 1;



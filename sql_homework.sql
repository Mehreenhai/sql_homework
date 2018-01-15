USE sakila;

# 1a.
SELECT first_name, last_name
FROM actor;

#1b.
SELECT UPPER(CONCAT(first_name, " ", last_name)) AS 'Actor Name'
FROM actor;

#2a.
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name LIKE 'Joe';

#2b.
SELECT * 
FROM actor
WHERE last_name LIKE '%GEN%';

#2c.
SELECT * 
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name ASC, first_name ASC;


#2d.
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a.
ALTER TABLE actor
ADD middle_name VARCHAR(50)
AFTER first_name;

#3b.
ALTER TABLE actor
MODIFY  middle_name BLOB;

#3c. 
ALTER TABLE actor
DROP COLUMN middle_name;

#4a.
SELECT last_name, COUNT(actor_id) number_of_actors
FROM actor
GROUP BY 1
ORDER BY 2 DESC;

#4b.
SELECT last_name, COUNT(actor_id) number_of_actors
FROM actor
GROUP BY 1
HAVING number_of_actors >=2
ORDER BY 2 DESC;

#4c.
UPDATE actor 
SET first_name = 'HARPO'
WHERE last_name LIKE 'WILLIAMS' AND first_name LIKE 'GROUCHO';

#4d. (finding id)
-- (SELECT actor_id FROM actor
-- WHERE last_name LIKE 'WILLIAMS' AND first_name LIKE 'HARPO')
-- note: yields ID = 172 (not adding this part as a subquery so that the below statement will work even after the first name is changed)

#4d.(answer)
 UPDATE  actor
 SET  first_name = CASE WHEN first_name LIKE 'HARPO'  THEN 'GROUCHO'
							   ELSE 'MUCHO GROUCHO' END
WHERE actor_id = 172;								

#5a.
DESCRIBE address;

#6a.
SELECT first_name, last_name, address
FROM staff a
INNER JOIN address b
ON a.address_id = b.address_id
;

#6b.
SELECT CONCAT(first_name, " ", last_name) AS staff_name, SUM(amount) total_amount
FROM staff a
INNER JOIN payment b
ON a.staff_id = b.staff_id
WHERE payment_date LIKE '2005-08-%'
GROUP BY 1
ORDER BY 2 DESC;

#6c.
SELECT title, COUNT(actor_id) AS number_of_actors
FROM film a
INNER JOIN film_actor b
ON a.film_id = b.film_id
GROUP BY 1
ORDER BY 2 DESC;

#6d.
SELECT title, COUNT(inventory_id) number_of_copies
FROM inventory a
INNER JOIN film b
ON a.film_id = b.film_id
GROUP BY 1
ORDER BY 2 DESC;

#6e.
SELECT first_name,  last_name, SUM(amount) total_paid
FROM customer a
INNER JOIN payment b
ON a.customer_id = b.customer_id
GROUP BY 1, 2
ORDER BY 2 ;

#7a.
SELECT  title 
FROM film
WHERE 
(LOWER(title) LIKE 'k%' OR LOWER(title) LIKE 'q%')
AND language_id IN
(SELECT language_id FROM language WHERE name LIKE 'English')
;

#7b.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(SELECT actor_id FROM film WHERE title LIKE 'Alone Trip')
ORDER BY 1;

#7c.
SELECT first_name, last_name, email
FROM customer cu
INNER JOIN address a
ON cu.address_id = a.address_id
INNER JOIN city ci
ON ci.city_id = a.city_id
INNER JOIN country co
ON co.country_id = ci.country_id
WHERE country LIKE 'Canada'
ORDER BY 1;

#7d.
SELECT title AS film_title 
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
WHERE c.name LIKE 'Family';

#7e.
SELECT title, COUNT(DISTINCT(rental_id)) number_of_rentals
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY 1
ORDER BY 2 DESC
;

#7f.
SELECT s.store_id AS store_id, SUM(r.amount) AS total_amount_in_dollars
FROM store s
INNER JOIN staff i
ON s.store_id = i.store_id
INNER JOIN payment r
ON i.staff_id = r.staff_id
GROUP BY 1
ORDER BY 2 DESC
;

#7g.
SELECT s.store_id AS store_id, city, country
FROM store s
INNER JOIN address a
ON s.address_id = a.address_id
INNER JOIN city ci
ON ci.city_id = a.city_id
INNER JOIN country co
ON co.country_id = ci.country_id
ORDER BY 1
;

#7h.
SELECT e.name AS category, SUM(amount) AS gross_revenue
FROM payment a
INNER JOIN rental b
ON a.rental_id = b.rental_id
INNER JOIN inventory c
ON b.inventory_id = c.inventory_id
INNER JOIN film_category d
ON c.film_id = d.film_id
INNER JOIN category e
ON d.category_id = e.category_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
;

#8a.
CREATE VIEW top_five_genres AS

(SELECT e.name AS category, SUM(amount) AS gross_revenue
FROM payment a
INNER JOIN rental b
ON a.rental_id = b.rental_id
INNER JOIN inventory c
ON b.inventory_id = c.inventory_id
INNER JOIN film_category d
ON c.film_id = d.film_id
INNER JOIN category e
ON d.category_id = e.category_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5);

#8b.
SELECT * FROM top_five_genres;

#8c.
DROP VIEW top_five_genres;


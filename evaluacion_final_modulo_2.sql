USE sakila;

-- 1. Select all movie titles without duplicates.

SELECT DISTINCT title
	FROM film;

-- 2. Show the titles of all movies that have a rating of "PG-13."

SELECT title
	FROM film
	WHERE rating = "PG-13";

-- 3. Find the title and description of all movies that contain the word "amazing" in their description.

SELECT title, description
	FROM film
    WHERE description LIKE "%amazing%";

-- 4. Find the title of all movies whose length is more than 120 minutes.
 
 SELECT title
	FROM film
	WHERE length > 120;

-- 5. Retrieve the names of all actors.

SELECT first_name, last_name
	FROM actor;

-- 6. Find the first and last names of actors who have "Gibson" in their last name.

SELECT first_name, last_name
	FROM actor
	WHERE last_name = "Gibson";

-- 7. Find the names of actors who have an actor_id between 10 and 20.

SELECT first_name, last_name
	FROM actor
	WHERE actor_id BETWEEN 10 AND 20;

-- 8. Find the titles of movies in the film table that are neither "R" nor "PG-13" in terms of their rating.

SELECT title
	FROM film 
	WHERE rating NOT IN ('R', 'PG-13');

-- 9. Find the total number of movies in each rating from the film table and display the rating along with the count.

SELECT rating, COUNT(title) AS total_movies
	FROM film 
	GROUP BY rating;

/* 10. Find the total number of movies rented by each customer and show the customer ID, their first name, last name,
	   and the number of movies rented.
       
(Uso 'COUNT(r.rental_id)' para contar los alquileres que ha hecho cada cliente, un 'LEFT JOIN' para que al unir las tablas
también tenga en cuenta a los clientes que no hayan alquilado ninguna peli y 'GROUP BY' para que se cuenten los alquileres 
de cada cliente individualmente.)  */
       
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS movies_rented
	FROM customer AS c
    LEFT JOIN rental AS r ON c.customer_id = r.customer_id
    GROUP BY c.customer_id
    ORDER BY movies_rented ASC;
       
-- 11. Find the total number of movies rented by category and display the category name along with the rental count.

/* 'COUNT(rental_id)': cuenta el número de alquileres.
   'INNER JOIN' para unir las 5 tablas que necesito, usando las columnas indicadas, y llegar a la que contiene la información 
    que necesito. 
   'GROUP BY' por 'category_id' para que el conteo de los alquileres se realice por cada categoría.
   'ORDER BY DESC' para que aparezca primero la categoría con más alquileres. */

SELECT c.name, COUNT(r.rental_id) AS total_rentals
	FROM category c
	INNER JOIN film_category AS fc 
		USING(category_id)
	INNER JOIN film AS f 
		USING(film_id)
	INNER JOIN inventory AS i 
		USING(film_id)
	INNER JOIN rental AS r 
		USING(inventory_id)
	GROUP BY c.category_id
	ORDER BY total_rentals DESC;

-- 12. Find the average duration of movies for each rating in the film table and show the rating along with the average duration.

/* 'AVG(length)' para calcular el promedio de la duración de las películas
   'GROUP BY rating' para que ese promedio se realice para cada clasificación de forma separada. */

SELECT rating, AVG(length) AS average_length
	FROM film 
	GROUP BY rating;

-- 13. Find the first and last names of actors who appear in the movie titled "Indian Love."

/* 'INNER JOIN' para unir las 3 tablas que necesito usando las columnas indicadas y conseguir llegar a la tabla 'film', 
   donde está el dato que necesito para que se cumpla la condición del 'WHERE' */

SELECT a.first_name, a.last_name
	FROM actor AS a
	INNER JOIN film_actor AS fa 
		USING(actor_id)
	INNER JOIN film AS f 
		USING(film_id)
	WHERE f.title = 'Indian Love';

-- 14. Show the titles of all movies that contain the word "dog" or "cat" in their description.

SELECT title, description
	FROM film 
	WHERE description LIKE '%dog%' 
    OR description LIKE '%cat%';

-- 15. Are there any actors who do not appear in any movies in the film_actor table?

SELECT a.first_name, a.last_name
	FROM actor a
	LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
	WHERE fa.film_id IS NULL;

-- 16. Find the titles of all movies that were released between the years 2005 and 2010.

/* En esos años, solo hay peliculas lanzadas en el 2006...*/

SELECT title
	FROM film
	WHERE release_year BETWEEN 2005 and 2010;

-- 17. Find the titles of all movies that are in the same category as "Family."

/* No existe esta película en la BBDD */

SELECT film_id
	FROM film 
	WHERE title = 'Family';

-- 18. Show the first and last names of actors who appear in more than 10 movies.

/* 'COUNT(fa.film_id)' para contar las peliculas en las que ha actuado cada actor
   'INNER JOIN' usando la columna indicada para unir con la tabla que relaciona actores con películas
   'GROUP BY' para que el conteo de peliculas lo haga por cada actor
   'HAVING' para fitrar el grupo por la condición dada
    Al usar 'ORDER BY' sin ASC ni DESC,lo hará en orden ascendente. */

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS total_movies
	FROM actor AS a
	INNER JOIN film_actor AS fa
		USING(actor_id)
        GROUP BY a.actor_id
        HAVING total_movies > 10
        ORDER BY total_movies;
        
-- 19. Find the titles of all movies that are rated "R" and have a duration greater than 2 hours in the film table.

SELECT title
FROM film
WHERE rating = 'R' AND length > 120; -- 2 horas son 120 minutos


/* 20. Find movie categories that have an average duration of more than 120 minutes and display the category name along 
with the average duration. */

SELECT c.name AS category_name, AVG(f.length) AS average_length
	FROM category AS c
	INNER JOIN film_category AS fc 
		USING(category_id)
	INNER JOIN film AS f 
		USING(film_id)
	GROUP BY c.category_id
	HAVING average_length > 120;


/* 21. Find actors who have acted in at least 5 movies and display the actor's name along with the number of movies 
they have acted in. 

'COUNT(film_id)' para contar el número de películas en las que ha actuado cada actor (movies_number)
 'INNER JOIN' con la tabla 'film_actor' para establecer la relación entre actores y películas usando la columna indicada
 'GROUP BY' para asegurar que el conteo de películas se realiza para cada actor individualmente
 'HAVING' para filtrar los resultados, después de agrupar, según la condición dada. */


SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS movies_number
	FROM actor AS a
	INNER JOIN film_actor AS fa 
		USING(actor_id)
	GROUP BY a.actor_id
	HAVING movies_number >= 5;


/* 22. Find the titles of all movies that were rented for more than 5 days. Use a subquery to find rental_ids 
with a duration exceeding 5 days and then select the corresponding movies. */












/* 23. Find the first and last names of actors who have not acted in any movies in the "Horror" category. 
	   Use a subquery to find actors who have acted in movies of the "Horror" category and then exclude them 
       from the list of actors. 
       
       
-- Hago la query para encontrar la categoría correspondiente a 'Horror', luego la que me permite obtener la información
sobre las categorías de las películas en las que los actores han actuado y , por último, la consulta que, 
gracias a las otras 2 subconsultas, me permite filtrar los actores y quedarme solo con los que no han actuado en películas
del género 'Horror'.

 -------------------------------------------------------------------------------------      
Subconsultas:

1. 
SELECT category_id 
FROM category 
WHERE name = 'Horror';  --- 11

2.
SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film_category AS fc 
		USING(film_id)
    WHERE fc.category_id = 11;
 ---------------------------------------------------------------------------------------
 */
     
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
						SELECT fa.actor_id
							FROM film_actor fa
								INNER JOIN film_category AS fc 
									USING(film_id)
							WHERE fc.category_id = (
													SELECT category_id 
														FROM category 
                                                        WHERE name = 'Horror')
							);


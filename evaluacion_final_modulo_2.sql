USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

/*
---------------------------------------------------------------------------------------------
Explicación: 
'DISTINCT' para asegurar que, en el caso de que hubiese duplicados en la tabla, 
solo devuelva títulos únicos.  
---------------------------------------------------------------------------------------------
*/


SELECT DISTINCT title
	FROM film;


-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13". 

/*
---------------------------------------------------------------------------------------------
 Explicación: 
'WHERE rating = "PG-13"' --> filtra los resultados y solo nos devuelve aquellas películas cuyo rating 
es el que le indicamos. 
---------------------------------------------------------------------------------------------
*/


SELECT title
	FROM film
	WHERE rating = "PG-13";
    

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

/*
---------------------------------------------------------------------------------------------
Explicación: 
Con el 'WHERE' filtramos la búsqueda, indicamos la columna dónde debe buscar, y con 'LIKE' 
buscamos patrones de texto en ella. Los signos de porcentaje (%) representan cualquier secuencia de caracteres, por lo 
que "%amazing%" nos devolverá todo lo que contenga la palabra 'amazing' en cualquier parte de la descripción". 
---------------------------------------------------------------------------------------------
*/


SELECT title, description
	FROM film
    WHERE description LIKE "%amazing%";
    

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.


/* 
---------------------------------------------------------------------------------------------
Explicación: 'WHERE' filtra los resultados, devolviéndonos solo las películas cuya duración (length) 
es mayor a 120 minutos. 
---------------------------------------------------------------------------------------------
*/


 SELECT title
	FROM film
	WHERE length > 120;


-- 5. Recupera los nombres de todos los actores.

/*
---------------------------------------------------------------------------------------------
Explicación: Obtendremos una lista con los nombres y apellidos de todos los actores en la tabla actor. 
---------------------------------------------------------------------------------------------
*/


SELECT first_name, last_name
	FROM actor;
    

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

/*
---------------------------------------------------------------------------------------------
Explicación: 
'WHERE last_name = "Gibson"'--> seleccionará y devolverá las filas que cumplan con la condición 
de que el apellido del actor sea 'Gibson'. 
---------------------------------------------------------------------------------------------
*/


SELECT first_name, last_name
	FROM actor
	WHERE last_name = "Gibson";
    

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

/*
---------------------------------------------------------------------------------------------
Explicación: 
'WHERE actor_id BETWEEN 10 AND 20' --> filtra los valores de la columna 'actor_id' y nos devuelve 
los que están en el rango indicado. 
---------------------------------------------------------------------------------------------
*/


SELECT first_name, last_name
	FROM actor
	WHERE actor_id BETWEEN 10 AND 20;
    

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

/*
---------------------------------------------------------------------------------------------
Explicación:
'WHERE rating NOT IN ('R', 'PG-13')' --> devuelve los valores que NO están en las clasificaciones que
 le hemos dado. 
---------------------------------------------------------------------------------------------
*/


SELECT title
	FROM film 
	WHERE rating NOT IN ('R', 'PG-13');
    

/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto
 con el recuento. 
 
--------------------------------------------------------------------------------------------- 
Explicación: 
'COUNT(title)' --> cuenta el número de títulos de películas para cada clasificación
'GROUP BY rating' --> agrupará las películas que tienen la misma clasificación. 
---------------------------------------------------------------------------------------------
*/

SELECT rating, COUNT(title) AS total_movies
	FROM film 
	GROUP BY rating;
    

/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y
apellido junto con la cantidad de películas alquiladas.

 ---------------------------------------------------------------------------------------------      
Explicación: 
'COUNT(r.rental_id)' --> cuenta los alquileres que ha hecho cada cliente.
'LEFT JOIN' --> para que al unir las tablas también tenga en cuenta a los clientes que no han alquilado ninguna peli.
'GROUP BY' --> agrupa los alquileres de cada cliente individualmente.  
---------------------------------------------------------------------------------------------
*/

       
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS movies_rented
	FROM customer AS c
    LEFT JOIN rental AS r ON c.customer_id = r.customer_id
    GROUP BY c.customer_id
    ORDER BY movies_rented ASC;
    
       
/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el
recuento de alquileres.


---------------------------------------------------------------------------------------------
Explicación:
'COUNT(rental_id)'--> cuenta el número de alquileres (total_rentals).
'INNER JOIN film_category' --> vincula películas con sus categorías.
'INNER JOIN film' --> la tabla que contiene los detalles de las películas.
'INNER JOIN inventory' --> contiene información sobre las copias disponibles.
'INNER JOIN rental' --> contiene información sobre los alquileres.
'GROUP BY c.category_id' --> para que el conteo de los alquileres se realice por cada categoría.
'ORDER BY DESC' --> para que aparezca primero la categoría más alquilada. 
---------------------------------------------------------------------------------------------
*/


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
    
    

/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la
clasificación junto con el promedio de duración.


---------------------------------------------------------------------------------------------
Explicación:
'AVG(length)' --> calcula el promedio de la duración de las películas
'GROUP BY rating' --> para que ese promedio se realice para cada clasificación de forma separada. 
---------------------------------------------------------------------------------------------
*/


SELECT rating, AVG(length) AS average_length
	FROM film 
	GROUP BY rating;


-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".


/*
---------------------------------------------------------------------------------------------
Explicación: 
'INNER JOIN film_actor' --> para vincular actores con las películas en las que han actuado.
'INNER JOIN film' --> para conseguir información sobre las películas.
'WHERE title = 'Indian Love'' --> para que nos devuelva los resultados que cumplen la condición dada.
---------------------------------------------------------------------------------------------
*/


SELECT a.first_name, a.last_name
	FROM actor AS a
	INNER JOIN film_actor AS fa 
		USING(actor_id)
	INNER JOIN film AS f 
		USING(film_id)
	WHERE f.title = 'Indian Love';
    


-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

/*
---------------------------------------------------------------------------------------------
Explicación: 
'WHERE description LIKE '%dog%'/'%cat%'' --> nos devolverá todas las películas en cuya descripción aparezca cualquier 
 cosa que contenga 'dog' / 'cat'
'OR' --> seleccionará las filas donde al menos una de las 2 condiciones se cumpla. 
---------------------------------------------------------------------------------------------
*/


SELECT title, description
	FROM film 
	WHERE description LIKE '%dog%' 
    OR description LIKE '%cat%';
    

-- 15. ¿Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor?
	   -- No, no hay ningún actor que cumpla la condición que se pide.
    
/* 
---------------------------------------------------------------------------------------------
Explicación: Hago una subconsulta para averiguar el 'id' correspondiente a los actores que han actuado en, al menos, 
una película; y la consulta para obtener nombres y apellidos de los que no están en el resultado anterior.  

Subconsulta:

 SELECT actor_id
    FROM film_actor;
 --------------------------------------------------------------------------------------------------   
 */

    
SELECT first_name, last_name
	FROM actor 
	WHERE actor_id NOT IN (
						   SELECT actor_id
							     FROM film_actor
					       );

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
	   -- En este rango de años, solo hay peliculas lanzadas en 2006...

/* 
---------------------------------------------------------------------------------------------
Explicación: 
'WHERE release_year BETWEEN 2005 AND 2010' --> filtra los valores de la columna 'release_year' y nos devuelve 
												los que están dentro del rango indicado. 
---------------------------------------------------------------------------------------------    
*/
    

SELECT title
	FROM film
	WHERE release_year BETWEEN 2005 and 2010;


-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

/* 
-------------------------------------------------------------------------------------------------- 
Explicación: 
Hago una subconsulta para averiguar el 'id' correspondiente a la categoría 'Family', otra que me 
permite obtener el 'film_id' de las películas que están en esa categoría y , por último, la consulta que filtra por
esos 'film_id' y me dará solo los títulos que están en la categoría indicada.

Subconsultas:

1.
SELECT category_id 
	FROM category 
    WHERE name = 'Family'; --> category_id = 8

2.    
SELECT film_id 
   FROM film_category 
   WHERE category_id = 8; 
   
------------------------------------------------------------------------------------------------------
*/


SELECT title 
FROM film 
WHERE film_id IN ( 
				   SELECT film_id 
						FROM film_category 
						WHERE category_id = (
											  SELECT category_id 
													FROM category 
													WHERE name = 'Family')
					);


-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

/*  
---------------------------------------------------------------------------------------------
Explicación:
'COUNT(fa.film_id)' ---> cuenta las peliculas en las que ha actuado cada actor (total_movies).
'INNER JOIN' usando la columna indicada para unir con la tabla que relaciona actores con películas.
'GROUP BY a.actor_id' ---> para que el conteo de peliculas lo haga por cada actor.
'HAVING total_movies > 10' ---> para fitrar el grupo por la condición dada.
Al usar 'ORDER BY' sin ASC ni DESC,lo hará en orden ascendente. 
------------------------------------------------------------------------------------------------
*/

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS ttotal_movies
	FROM actor AS a
	INNER JOIN film_actor AS fa
		USING(actor_id)
        GROUP BY a.actor_id
        HAVING total_movies > 10
        ORDER BY total_movies;
        
        
        
-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.


/* 
---------------------------------------------------------------------------------------------
Explicación:
'WHERE rating = 'R' AND length > 120' --> devuelve los valores que cumplen las condiciones que le hemos dado.
---------------------------------------------------------------------------------------------
 */
 
 
SELECT title
FROM film
WHERE rating = 'R' AND length > 120;  -- > 2 horas son 120 minutos


/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el
nombre de la categoría junto con el promedio de duración. 

---------------------------------------------------------------------------------------------
Explicación: 
'AVG(f.length)' --> promedio de la duración de las películas de la tabla film (average_length)
'INNER JOIN film_category USING(category_id)' --> para relacionar películas y categorías.
'INNER JOIN film USING(film_id)' --> para poder acceder a la duración de cad película.
'GROUP BY category_id' --> para agrupar películas de la misma categoría.
'HAVING average_length > 120' --> filtra cada grupo (categoría) y selecciona solo los que cumplen la condición dada.
---------------------------------------------------------------------------------------------
*/


SELECT c.name AS category_name, AVG(f.length) AS average_length
	FROM category AS c
	INNER JOIN film_category AS fc 
		USING(category_id)
	INNER JOIN film AS f 
		USING(film_id)
	GROUP BY c.category_id
	HAVING average_length > 120;


/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la
cantidad de películas en las que han actuado.

---------------------------------------------------------------------------------------------
Explicación: 
'COUNT(film_id)' -->  cuenta el número de películas en las que ha actuado cada actor (movies_number).
'INNER JOIN film_actor' -->  relaciona actores y películas.
'GROUP BY actor_id' --> asegura que el conteo de películas se realiza para cada actor individualmente
'HAVING movies_number >= 5' --> filtra los resultados, después de agrupar, y nos devuelve los que cumplen
     la condición que le damos. 
---------------------------------------------------------------------------------------------     
*/


SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS movies_number
	FROM actor AS a
	INNER JOIN film_actor AS fa 
		USING(actor_id)
	GROUP BY a.actor_id
	HAVING movies_number >= 5;


/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para
encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

---------------------------------------------------------------------------------------------
Explicación: 
Hago una consulta para relacionar las tablas 'inventory' y 'rental' y poder conseguir los registros de 
alquiler que tengan una duración superior a 5 días. Para ello filtro con WHERE y uso 'DATEDIFF', que es una función de
SQL que permite calcular la diferencia entre 2 fechas (en este caso las de alquiler y la de devolución).
Una vez conseguidos esos datos ya puedo hacer la consulta principal y volver a filtrar con WHERE para conseguir 
sólo las películas que también se encuentren en el resultado de la subconsulta.

  
Subconsulta:

1.
SELECT i.film_id
	FROM inventory AS i
	INNER JOIN rental AS r
		USING(inventory_id)
	WHERE DATEDIFF(r.return_date, r.rental_date) > 5;        
----------------------------------------------------------------------------------------------------
*/


SELECT f.title
FROM film f
WHERE f.film_id IN (
					SELECT i.film_id
						FROM inventory AS i
						INNER JOIN rental AS r
							USING(inventory_id)
						WHERE DATEDIFF(r.return_date, r.rental_date) > 5
					);



/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego
exclúyelos de la lista de actores.
       
---------------------------------------------------------------------------------------------       
Explicación: 
Hago una subconsulta para encontrar la categoría correspondiente a 'Horror', luego otra que me permita 
obtener la información sobre las categorías de las películas en las que los actores han actuado y , por último, la 
consulta principal, que gracias a las otras 2 subconsultas, me permite filtrar los actores y quedarme solo con los que 
no han actuado en películas del género 'Horror'.

       
Subconsultas:

1. 
SELECT category_id 
FROM category 
WHERE name = 'Horror';  ---> category_id = 11

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
                            
                            
/* 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la
tabla film. 


--------------------------------------------------------------------------------------------------
Explicación:
'INNER JOIN film_category' --> vincula las películas con sus categorías
'INNER JOIN category' --> para obtener los nombres de las categorías
'WHERE name = 'Comedy' AND length > 180' --> para que el resultado cumpla las 2 condiciones que se piden.
-------------------------------------------------------------------------------------------------- 
*/


SELECT f.title
	FROM film AS f
	INNER JOIN film_category AS fc 
		USING(film_id)
	INNER JOIN category AS c 
		USING(category_id)
	WHERE c.name = 'Comedy' AND f.length > 180;


/* 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe
mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos. */  
select first_name, last_name, title from actor left join 
(select actor_id, film.title from film_actor left join film using(film_id)) as second
on actor.actor_id = second.actor_id;                      


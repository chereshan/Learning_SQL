/*Learning SQL Generate, Manipulate, and Retrieve Data Alan Beaulieu*/
USE SAKILA;
-- Используется публичная БД sakila
-- -----------------------------------------
-- -----------------------------------------
-- Болье (гл. 1, ...)
-- SELECT
-- 1. Предложение SELECT
SELECT *
FROM language;
--
SELECT language_id,
 'COMMON' language_usage,
 language_id*3.14 lang_pi_value,
 upper(name) name
FROM language;
-- 2. Псевдоним столбцов
/*Иногда запрос будет возвращать повторы данных, т.к. некоторые актеры снимались более, чем в 1 фильме. */
SELECT actor_id FROM film_actor ORDER BY actor_id;
-- Чтобы это исправить добавим ключевое слово DISTINCT
SELECT DISTINCT actor_id 
from film_actor
ORDER BY actor_id;
-- -----------------------------------------
-- FROM
-- 1. Производные таблицы
SELECT concat(cust.last_name,', ', cust.first_name )  full_name
FROM
    (SELECT first_name, last_name, email
    FROM customer
    WHERE first_name = 'JESSIE'
    ) cust;
-- 2. Включение нескольких таблиц в FROM
SELECT customer.first_name, customer.last_name, 
    time(rental.rental_date) rental_time
FROM customer
    INNER JOIN rental
    ON customer.customer_id = rental.rental_id
WHERE date(rental.rental_date) = '2005-05-24';
-- 3. Использование псевдонимов
SELECT c.first_name, c.last_name, 
    time(r.rental_date) rental_time
FROM customer c -- задаем псевдоним
    INNER JOIN rental r -- задаем псевдоним
    ON c.customer_id = r.rental_id
WHERE date(r.rental_date) = '2005-05-24';
-- -----------------------------------------
-- WHERE
-- 1. Использование WHERE
SELECT title
FROM film
WHERE rating = 'G' AND rental_duration >= 7;
--
SELECT title
FROM film
WHERE rating = 'G' OR rental_duration >= 7;
--
SELECT title, rating, rental_duration
FROM film
WHERE (rating = 'G' AND rental_duration >= 7)
OR (rating = 'PG-13' AND rental_duration < 4);
-- -----------------------------------------
-- GROUP BY и HAVING
SELECT c.first_name, c.last_name, count(*)
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.first_name, c.last_name
HAVING count(*) >= 40;
-- -----------------------------------------
-- ORDER BY
SELECT c.first_name, c.last_name,
time(r.rental_date) rental_time
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
WHERE date(r.rental_date)='2005-06-14';
-- 1. Алфавитный порядок фамилий
SELECT c.first_name, c.last_name,
time(r.rental_date) rental_time
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY c.last_name;
-- 2. В обратном поряке
SELECT c.first_name, c.last_name,
time(r.rental_date) rental_time
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY c.last_name DESC;
-- -----------------------------------------
-- -----------------------------------------
-- Болье (гл. 4, Фильтрация)
-- 1. Условие равенства
SELECT c.email
FROM customer c
    INNER JOIN rental r
    ON c.customer_id = r.customer_id
WHERE date(r.rental_date)='2005-06-14';
-- 2. Условие неравенства
SELECT c.email
FROM customer c
    INNER JOIN rental r
    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) <> '2005-06-14';
-- 3. Условие диапозона
SELECT customer_id, rental_date
    FROM rental
WHERE rental_date < '2005-05-25';
--
SELECT customer_id, rental_date
    FROM rental
WHERE rental_date <= '2005-06-16'
AND rental_date >= '2005-06-14';
-- 4. Оператор BETWEEN
-- сначала нижняя граница, а потом верхняя\
SELECT customer_id, rental_date
    FROM rental
WHERE rental_date BETWEEN '2005-06-14' AND '2005-06-16';
--
SELECT customer_id, payment_date, amount
    FROM payment
WHERE amount BETWEEN 10.0 AND 11.99;
-- 5. Строковые условия
SELECT last_name, first_name
    FROM customer
WHERE last_name BETWEEN 'FA' AND 'FRB';
-- 6. Условия членства
SELECT title, rating
    FROM film
WHERE rating = 'G' OR rating = 'PG';
--
SELECT title, rating
    FROM film
WHERE rating IN ('G','PG');
--
SELECT title, rating
	FROM film
WHERE rating NOT IN ('PG-13', 'NC-17','R', 'NC-17');
-- 7. Условие членства в подзапросе
SELECT title, rating
    FROM film
WHERE rating IN (SELECT rating FROM film WHERE title LIKE '%PET%');
-- 8. Условия соответствия
SELECT last_name, first_name
FROM customer
WHERE substr(last_name, 4,1) = 'Q';
-- 9. Подстановочные символы
SELECT last_name, first_name
FROM customer
WHERE last_name LIKE '_A_T%S';
--
SELECT last_name, first_name
FROM customer
WHERE last_name LIKE 'Q%' OR last_name LIKE 'Y%';
-- 10. Регулярные выражения
-- НАДО УСТАНОВИТЬ РАСШИРЕНИЕ
SELECT last_name, first_name
FROM customer
WHERE last_name REGEXP '^[QY]';
-- 11. null
SELECT rental_id, customer_id
FROM rental
WHERE return_date IS NULL;
-- null!=null
SELECT rental_id, customer_id
FROM rental
WHERE return_date = NULL;
--
SELECT rental_id, customer_id, return_date
FROM rental
WHERE return_date IS NOT NULL;
--
SELECT rental_id, customer_id, return_date
FROM rental
WHERE return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';
--
SELECT rental_id, customer_id, return_date
FROM rental
WHERE return_date IS NULL
OR return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';
-- -----------------------------------------
-- -----------------------------------------
-- Болье (гл. 2, Создание таблиц)
-- DROP TABLE person;
CREATE TABLE person
    (person_id INTEGER PRIMARY KEY auto_increment, -- Здесь очень внимательно обратить внимание. Так надо прописывать обзательно автоинкремент.
    fname VARCHAR(20),
    lname VARCHAR(20),
    eye_color CHAR(2) CHECK ( eye_color in ('BR','BL','GR')),
    birth_date DATE,
    street VARCHAR(30),
    city VARCHAR(20),
    state VARCHAR(20),
    country VARCHAR(20),
    postal_code VARCHAR(20));
--
select *
from person;
--
-- DROP TABLE favorite_food;
CREATE TABLE favorite_food
(person_id SMALLINT UNSIGNED,
food VARCHAR(20),
CONSTRAINT pk_favorite_food PRIMARY KEY(person_id, food),
CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id)
REFERENCES person (person_id)
);
--
select *
from favorite_food;
--
-- Автоматическая нумерация ключей
INSERT INTO person
    (person_id,fname, lname, eye_color, birth_date)
    VALUES (null,'William','Turner', 'BR', '1972-05-27');
-- Если включен автоинкримент на id, то таблица будет автоматически шагать инкрементно при добавлении null в строку id
INSERT INTO favorite_food (person_id, food)
VALUES (1, 'pizza');
INSERT INTO favorite_food (person_id, food)
VALUES (1, 'cookies');
INSERT INTO favorite_food (person_id, food)
 VALUES (1, 'nachos');
-- 
select *
from favorite_food;
--
INSERT INTO person
(person_id, fname, lname, eye_color, birth_date, street, city, state, country, postal_code)
VALUES (null, 'Susan','Smith', 'BL', '1975-11-02','23 Maple St.', 'Arlington', 'VA', 'USA', '20220');
-- Обноваление данных
UPDATE person
    SET street='1225 Tremont St.',
    city ='Boston',
    state = 'MA',
    country = 'USA',
    postal_code = '02138'
WHERE person_id = 1;
--
select *
from person;
-- -----------------------------------------
-- -----------------------------------------
-- Болье (гл. 5, Запросы к нескольким таблицам)
-- 1. Декартово произведение
SELECT c.first_name, c.last_name, a.address
FROM customer c JOIN address a;
-- 2. Внутреннее соединение
SELECT c.first_name, c.last_name, a.address
FROM customer c JOIN address a
    ON c.address_id = a.address_id;
--
SELECT c.first_name, c.last_name, a.address
FROM customer c INNER JOIN address a
    USING (address_id);
-- 3. Соединение трех+ таблиц
SELECT c.first_name, c.last_name, ct.city
FROM customer c
INNER JOIN address a
    ON c.address_id = a.address_id
INNER JOIN city ct
    ON a.city_id = ct.city_id;
-- 4. Использование подзапросов в качестве таблиц
SELECT c.first_name, c.last_name, addr.address, addr.city
FROM customer c 
	INNER JOIN 
		(SELECT a.address_id, a.address, ct.city
		FROM address a
			INNER JOIN city ct
			ON a.city_id = ct.city_id
		) addr
	ON c.address_id = addr.address_id;
-- -----------------------------------------
-- -----------------------------------------
-- Болье (гл. 6, Множества)
-- 1. UNION
SELECT 'CUST' typ, c.first_name, c.last_name
from customer c 
union
select 'ACTR' typ, a.first_name, a.last_name
from actor a;
--
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
UNION ALL
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%' ;
--
-- ---------------
-- ВАЖНО! В MySQL нет операторов INTERSECT и EXCEPT
-- ---------------
(SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%'
AND c.last_name LIKE 'D%')
INTERSECT
(SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%'
AND a.last_name LIKE 'D%');
--
SELECT 'ACTR' typ,a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%'
AND a.last_name LIKE 'D%'
EXCEPT
SELECT 'CUST' typ,c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%'
AND c.last_name LIKE 'D%';
-- -----------------------------------------
-- -----------------------------------------
-- Болье (гл. 7, Генерация, обработка и преобразование данных)
-- Строки
SELECT name, name LIKE '%y' ends_in_y
from category;
--
select concat(c.first_name, c.last_name, ' has been a customer since ', date(c.create_date))  comment
FROM customer c;
-- -----------------------------------------
-- -----------------------------------------
-- Болье (гл. 8, Группировка и агрегация)
-- Группировка
SELECT customer_id
FROM rental
GROUP BY customer_id;
--
SELECT customer_id, count(*)
FROM rental
GROUP BY customer_id;
--
SELECT customer_id, count(*)
FROM rental
GROUP BY customer_id
ORDER BY 2 DESC;
--
SELECT tt.*
FROM (select customer_id, count(*) num from rental
GROUP BY customer_id) tt
WHERE num>=40;
-- НАДО ИСПОЛЬЗОВАТЬ HAVING
SELECT customer_id, count(*)
FROM rental
GROUP BY customer_id
HAVING count(*) >= 40;
-- Агрегатные функции
SELECT MAX(amount) max_amt,
MIN(amount) min_amt,
AVG(amount) avg_amt,
SUM(amount) tot_amt,
COUNT(*) num_payments
FROM payment;
--
SELECT customer_id,
MAX(amount) max_amt,
MIN(amount) min_amt,
AVG(amount) avg_amt,
SUM(amount) tot_amt,
COUNT(*) num_payments
from payment
group by customer_id;
--
SELECT COUNT(customer_id) num_rows,
COUNT(DISTINCT customer_id) num_customers
FROM payment;
-- С использованием даты-времени
SELECT MAX(datediff(return_date,rental_date))
from rental;
-- Генерация групп
SELECT actor_id, count(*)
FROM film_actor
GROUP BY actor_id;
--
SELECT fa.actor_id, f.rating, count(*)
FROM film_actor fa
INNER JOIN film f
ON fa.film_id = f.film_id
GROUP BY fa.actor_id, f.rating
ORDER BY 1,2;
-- -----------------------------------------
-- -----------------------------------------
-- Болье (гл. 9, Подзапросы)
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id = (SELECT MAX(customer_id) FROM customer);
-- Скалярный (некоррелированный подзапрос)
select city_id, city
from city
where country_id <>(select country_id from country where country='India');
-- IN
SELECT city_id, city
FROM city
WHERE country_id IN
(SELECT country_id
FROM country
WHERE country IN ('Canada','Mexico'));
-- ALL
SELECT first_name, last_name
FROM customer
WHERE customer_id <> ALL
(SELECT customer_id
FROM payment
WHERE amount = 0);
-- Лучше использовать эквивалентный NOT insert
SELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN
(SELECT customer_id
FROM payment
WHERE amount = 0);
--
SELECT customer_id, count(*)
FROM rental
GROUP BY customer_id
HAVING count(*) > ALL
(SELECT count(*)
FROM rental r
INNER JOIN customer c
ON r.customer_id = c.customer_id
INNER JOIN address a
ON c.address_id = a.address_id
INNER JOIN city ct
ON a.city_id = ct.city_id
INNER JOIN country co
ON ct.country_id = co.country_id
WHERE co.country IN ('United States','Mexico','Canada')
GROUP BY r.customer_id);
-- ANY
SELECT customer_id, sum(amount)
FROM payment
GROUP BY customer_id
HAVING sum(amount) > ANY
(SELECT sum(p.amount)
FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id
INNER JOIN address a
ON c.address_id = a.address_id
INNER JOIN city ct
ON a.city_id = ct.city_id
INNER JOIN country со
ON ct.country_id = со.country_id
WHERE со.country IN ('Bolivia','Paraguay','Chile')
GROUP BY со.country);
-- Многостолбцовые подзапросы
SELECT fa.actor_id, fa.film_id
FROM film_actor fa
WHERE fa.actor_id IN
(SELECT actor_id FROM actor WHERE last_name = 'MONROE')
AND fa.film_id IN
(SELECT film_id FROM film WHERE rating = 'PG');
--
SELECT actor_id, film_id
FROM film_actor
WHERE (actor_id, film_id) IN
(SELECT a.actor_id, f .film_id
FROM actor a
CROSS JOIN film f
WHERE a.last_name='MONROE'
AND f.rating = 'PG');
-- Коррелированные подзапросы
SELECT c.first_name, c.last_name
FROM customer c
WHERE 20 =
(SELECT count(*) FROM rental r
WHERE r.customer_id = c.customer_id);
--
SELECT c.first_name, c.last_name
FROM customer c
WHERE
(SELECT sum(p.amount) FROM payment p
WHERE p.customer_id = c.customer_id)
BETWEEN 180 AND 240;
--
SELECT c.first_name, c.last_name
FROM customer c
WHERE EXISTS
(SELECT 1 FROM rental r
WHERE r.customer_id = c.customer_id
AND date(r.rental_date) <'2005-05-25');
--
SELECT c.first_name, c.last_name
FROM customer c
WHERE EXISTS
(SELECT r.rental_date , r.customer_id
FROM rental r
WHERE r.customer_id = c.customer_id
AND date(r.rental_date) < '2005-05-25');
--
SELECT a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS
(SELECT 1
FROM film_actor fa
INNER JOIN film f ON f.film_id = fa.film_id
WHERE fa.actor_id = a.actor_id
AND f.rating ='R');
--  Применение подзапросов
-- Подзапросы как источники данных
SELECT c.first_name, c.last_name,
pymnt.num_rentals, pymnt.tot_payments
FROM customer c
    INNER JOIN
    (SELECT customer_id,
    count(*) num_rentals, sum(amount) tot_payments
    FROM payment
    GROUP BY customer_id
    ) pymnt
ON c.customer_id = pymnt.customer_id;
--
SELECT customer_id, count( *) num_rentals,
sum(amount) tot_payments
FROM payment
GROUP BY customer_id;
-- СОЗДАНИЕ ДАННЫХ
SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
UNION ALL
SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
UNION ALL
SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit;
--
SELECT pymnt_grps.name, count(*) num_customers
FROM
    (SELECT customer_id,
    count(*) num_rentals, sum(amount) tot_payments
    FROM payment
    GROUP BY customer_id) pymnt
INNER JOIN
    (SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
    UNION ALL
    SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
    UNION ALL
    SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit
    ) pymnt_grps
ON pymnt.tot_payments BETWEEN pymnt_grps.low_limit AND pymnt_grps.high_limit
GROUP BY pymnt_grps.name;
-- ПОДЗАПРОСЫ ОРИЕНТИРОВАННЫЕ НА ЗАДАЧУ
SELECT c.first_name, c.last_name, ct.city, sum(p.amount) tot_payments, count(*) tot_rentals
FROM payment p
    INNER JOIN customer c
    ON p.customer_id = c.customer_id
    INNER JOIN address a
    ON c.address_id = a.address_id
    INNER JOIN city ct
    ON a.city_id = ct.city_id
GROUP BY c.first_name, c.last_name, ct.city;
--
SELECT c.first_name, c.last_name, ct.city, pymnt.tot_payments, pymnt.tot_rentals
FROM
    (SELECT customer_id,
    count(*) tot_rentals, sum(amount) tot_payments
    FROM payment
    GROUP BY customer_id
    ) pymnt
INNER JOIN customer c
    ON pymnt.customer_id = c.customer_id
INNER JOIN address a
    ON c.address_id = a.address_id
INNER JOIN city ct
    ON a.city_id = ct.city_id;
-- ОБОБЩЕННЫЕ ТАБЛИЧНЫЕ ВЫРАЖЕНИЯ
WITH actors_s AS
    (SELECT actor_id, first_name, last_name
    FROM actor
    WHERE last_name LIKE 'S%'),
actors_s_pg AS
    (SELECT s.actor_id, s.first_name, s.last_name,
    f.film_id, f.title
    FROM actors_s s
    INNER JOIN film_actor fa
    ON s.actor_id = fa.actor_id
    INNER JOIN film f
    ON f.film_id = fa.film_id
    WHERE f.rating = 'PG'),
actors_s_pg_revenue AS
    (SELECT spg.first_name, spg.last_name, p.amount
    FROM actors_s_pg spg
    INNER JOIN inventory i
    ON i.film_id = spg.film_id
    INNER JOIN rental r
    ON i.inventory_id = r.inventory_id
    INNER JOIN payment p
    ON r.rental_id = p.rental_id
    ) -- конец предложения WITH
SELECT spg_rev.first_name, spg_rev.last_name,
sum(spg_rev.amount) tot_revenue
FROM actors_s_pg_revenue spg_rev
GROUP BY spg_rev.first_name, spg_rev.last_name
ORDER BY 3 desc;
-- Подзапросы как генераторы выражений
SELECT
(SELECT c.first_name FROM customer c
WHERE c.customer_id = p.customer_id) AS first_name,
(SELECT c.last_name FROM customer c
WHERE c.customer_id = p.customer_id) AS last_name,
(SELECT ct.city FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ct ON a.city_id = ct.city_id
WHERE c.customer_id = p.customer_id) city,
sum(p.amount) tot_payments,
count(*) tot_rentals
FROM payment p
GROUP BY p.customer_id;
--
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
ORDER BY
(SELECT count(*) FROM film_actor fa
WHERE fa.actor_id = a.actor_id) DESC;
--
-- -----------------------------------------
-- -----------------------------------------
-- Болье (гл. 10, Соединения)
-- Внешние соединения
--  Следующий запрос подсчитывает количество доступных копий каждого фильма с помощью соединения этих двух таблиц
SELECT f.film_id, f.title, count(*) num_copies
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
GROUP BY f.film_id, f.title;
-- Хотя можно было бы ожидать, что будет возвращено 1000 строк (по одной для каждого фильма), запрос возвращает только 958 строк. Дело в том, что запрос использует внутреннее соединение, которое возвращает только строки, удовлетворяющие условию соединения. Например, фильм Alice Fantasia (film_id равен 14) не отображается в результатах, потому что для него нет строк в таблице inventory
-- Если вы хотите, чтобы запрос возвращал все 1000 фильмов, независимо от того, имеются ли соответствующие строки в таблице inventory, можете использовать внешнее соединение, которое, по сути, делает условие соединения необязательным
SELECT f.film_id, f.title, count(i.inventory_id) num_copies
FROM film f
LEFT OUTER JOIN inventory i
ON f.film_id = i.film_id
GROUP BY f.film_id, f.title;
-- Как видите, запрос теперь возвращает все 1000 строк из таблицы film, при этом 42 строки из общего количества строк (включая фильм Alice Fantasia) имеют значение 0 в столбце num_copies, что указывает на отсутствие доступных для проката копий
-- Вот описание изменений по сравнению с предыдущей версией запроса:
-- Определение соединения было изменено с inner на left outer, что указывает серверу на необходимость включения всех строк из таблицы в левой части соединения (в данном случае film) и включения столбцов из таблицы с правой стороны соединения (inventory), если соединение прошло успешно
-- Определение столбца num_copies было изменено с count ( * ) на count ( i. inventory_id) ; это выражение подсчитывает количество значений столбца inventory.inventory_id, не равных null.
-- Теперь давайте удалим предложение group by и отфильтруем большинство строк, чтобы ясно видеть различия между внутренними и внешними соединениями. Вот запрос с использованием внутреннего соединения и условия фильтрации для возврата всего лишь нескольких фильмов:
SELECT f.film_id, f.title, i.inventory_id
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
WHERE f.film_id BETWEEN 13 AND 15;
-- Результаты показывают , что в прокате имеется четыре копии АН Forever и шесть копий Alien Center. Вот как выглядит тот же запрос, но с использованием внешнего соединения:
SELECT f.film_id, f.title, i.inventory_id
FROM film f
LEFT OUTER JOIN inventory i
ON f.film_id = i.film_id
WHERE f.film_id BETWEEN 13 AND 15;
-- Левое и правое внешние соединения
-- n. Ключевое слово left указывает , что таблица в левой части соединения отвечает за определения количества строк в результирующем наборе, тогда как таблица в правой части используется для предоставления значений столбца всякий раз, когда найдено совпадение. Однако можно указать и правое внешнее соединение — в этом случае таблица с правой стороны от right outer join отвечает за определение количества строк в результирующем наборе, тогда как таблица с левой стороны используется для предоставления значений столбцов.
-- ключевые слова left и right служат только для того, чтобы сообщить серверу, в какой таблице разрешено иметь пробелы в данных. Если вы хотите внешне соединить таблицы А и В и хотите, чтобы в результирующем наборе присутствовали все строки из А (с дополнительными столбцами из В всякий раз, когда есть соответствующие данные), то можете указать либо A left outer join В, либо В right outer join А.
-- Трехсторонние внешние соединения
SELECT f.film_id, f.title, i.inventory_id, r.rental_date
FROM film f
LEFT OUTER JOIN inventory i
ON f.film_id = i.film_id
LEFT OUTER JOIN rental r
ON i.inventory_id = r.inventory_id
WHERE f.film_id BETWEEN 13 AND 15;
-- Перекрестные соединения
SELECT c.name category_name, l.name language_name
 FROM category c
CROSS JOIN language l;
-- Этот запрос генерирует декартово произведение таблиц category и language, в результате чего получается результирующий набор из 96 строк (16 строк category х 6 строк language)
-- естественные соединения
-- сли вы ленивы, то можете выбрать тип соединения, который позволит вам указать таблицы, которые необходимо соединить, но при этом позволит серверу базы данных самому определять, какими должны быть условия соединения. Этот тип соединения, известный как естественное соединение, основывается при выводе условий соединения на идентичности имен столбцов в нескольких таблицах. Например, таблица rental включает столбец с именем customer_id, который является внешним ключом к таблице customer, первичный ключ которой также имеет имя customer_id. Таким образом, вы можете попробовать написать запрос, который использует естественное соединение двух таблиц:
SELECT c.first_name, c.last_name, date(r.rental_date)
FROM customer c
NATURAL JOIN rental r;
-- Поскольку вы указали естественное соединение, сервер проверяет определения таблиц и добавляет условие г .customer_id = с. customer_id для соединения двух таблиц. Это могло бы получиться, но в схеме Sakila все таблицы включают столбец last_update, чтобы знать, когда каждая строка была в последний раз изменена, поэтому сервер добавляет еще одно условие соединения — г.last_update = с.last_update, которое и приводит к тому, что запрос не возвращает никакие данные.
-- Единственный способ обойти эту проблему — использовать подзапрос, чтобы ограничить столбцы как минимум одной из таблиц:
SELECT cust.first_name, cust.last_name, date(r.rental_date)
FROM
(SELECT customer_id, first_name, last_name
FROM customer) cust
NATURAL JOIN rental r;
-- -----------------------------------------
-- -----------------------------------------
-- Болье (гл. 11, Услованя логика)
-- В некоторых ситуациях требуется, чтобы SQL-логика разветвлялась в том или ином направлении в зависимости от значений определенных столбцов или выражений
-- условную логику можно использовать в инструкциях select, insert, update и delete.
-- Например, при запросе информации о клиенте вы можете захотеть включить столбец customer.active, в котором хранится 1 для обозначения активного и 0 — для обозначения неактивного клиента. Если результаты запроса используются для создания отчета, то вы можете захотеть перевести это значение в строку, чтобы улучшить удобочитаемость
SELECT first_name, last_name,
	CASE
		WHEN active = 1 THEN 'ACTIVE'
	ELSE 'INACTIVE'
END activity_type
FROM customer;
-- Этот запрос включает выражение case для генерации значения столбца activity_type, которое возвращает строку ACTIVE или INACTIVE в зависимости от значения столбца customer.active.
-- ВЫРАЖЕНИЕ CASE
-- Поисковые выражения CASE
-- СИНТАКСИС
CASE
	WHEN Cl THEN El
	WHEN C2 THEN E2
    ...
	WHEN CN THEN EN
	[ELSE ED]
END;
-- В этом определении символы C l,С2, C N представляют условия, а символы E l, Е2,..., EN — выражения, возвращаемые выражением case.
-- Все выражения, возвращаемые различными предложениями when, должны иметь один и тот же тип (например, date, number, varchar).
CASE
	WHEN category.name IN ('Children' ,'Family','Sports' ,'Animation')
		THEN 'All Ages'
	WHEN category.name = 'Horror'
		THEN 'Adult'
	WHEN category.name IN ('Music','Games')
		THEN 'Teens'
	ELSE 'Other'
END;
-- Это выражение case возвращает строку, которую можно использовать для классификации фильмов в зависимости от их категории. При обработке выражения case по порядку сверху вниз вычисляются предложения when; как только одно из условий в предложении when дает значение true, возвращается соответствующее выражение, а все оставшиеся предложения when игнорируются. Если ни одно из условий в предложениях when не является истинным, возвращается выражение в предложении else.
-- в которой для возврата количество прокатов — но только для активных клиентов! — используется подзапрос
SELECT c.first_name, c.last_name,
	CASE
		WHEN active = 0 THEN 0
        ELSE
			(SELECT count(*) FROM rental r
			WHERE r.customer_id = c.customer_id)
	END num_rentals
FROM customer c;
-- Эта версия запроса использует коррелированный подзапрос для получения количества прокатов для каждого активного клиента. В зависимости от процента активных клиентов использование этого подхода может быть более эффективным, чем соединение таблиц customer и rental и группировка по столбцу customer_id.
-- ПРОСТЫЕ ВЫРАЖЕНИЯ CASE
CASE V0
	WHEN VI THEN El
	WHEN V2 THEN E2
	WHEN VN THEN EN
	[ELSE ED]
END;
-- том определении VO представляет значение, а символы VI, V2, ..., VN — значения, с которыми необходимо сравнивать V0. Символы El, Е2, ..., EN обозначают выражения, которые должны быть возвращены выражением case, a ED — выражение, которое должно быть возвращено, если ни одно из значений в наборе VI, V2, ..., VN не совпадает со значением V0.
CASE category.name
	WHEN 'Children' THEN 'All Ages'
	WHEN 'Family' THEN 'All Ages'
	WHEN 'Sports' THEN 'All Ages'
	WHEN 'Animation' THEN 'All Ages'
	WHEN 'Horror' THEN 'Adult'
	WHEN 'Music' THEN 'Teens'
	WHEN 'Games' THEN 'Teens'
	ELSE 'Other'
END;
-- ПРИМЕРЫ ВЫРАЖЕНИЕ CASE
-- Преобразования результирующего набора
-- Возможно, вы столкнулись с ситуацией, когда вы выполняете агрегирование конечного набора значений, таких как дни недели, но хотите, чтобы результирующий набор содержал единственную строку со столбцами, по одному для каждого значения, а не по одной строке для каждого значения.
-- В качестве примера предположим, что требуется написать запрос, который показывает количество прокатов фильмов в мае, июне и июле 2005 года:
SELECT monthname(rental_date) rental_month,
count(*) num_rentals
FROM rental
WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01'
GROUP BY monthname(rental_date);
-- Однако на запрос накладывается условие — он должен вернуть одну строку данных с тремя столбцами (по одному для каждого из трех месяцев). Чтобы преобразовать этот результирующий набор в единую строку, нужно создать три столбца и в каждом столбце суммировать только те строки, которые относятся к рассматриваемому месяцу:
SELECT
SUM(CASE WHEN monthname(rental_date) = 'May' THEN 1 ELSE 0 END) May_rentals,
SUM(CASE WHEN monthname(rental_date)='June' THEN 1 ELSE 0 END) June_rentals,
SUM(CASE WHEN monthname(rental_date)='July' THEN 1 ELSE 0 END) July_rentals
FROM rental
WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01';
-- Все три столбца в предыдущем запросе идентичны, за исключением значения месяца. Когда функция monthname ( ) возвращает требуемое значение для конкретного столбца, выражение case возвращает значение 1; в противном случае возвращается 0. При суммировании по всем строкам каждый столбец возвращает количество счетов, открытых в этом месяце. Очевидно, что такие преобразования применимы только для небольшого количества значений; генерация по одному столбцу для каждого года, начиная с 1905 года, быстро станет утомительной
-- ПРОВЕРКА СУЩЕСТВОВАНИЯ
-- Иногда нужно определить, существуют ли взаимосвязи между двумя сущностями, без учета количества. 
-- Например, вы можете захотеть узнать, снялся ли некоторый актер хотя бы в одном фильме с рейтингом G, без учета фактического количества фильмов. Вот запрос для генерации трех выходных столбцов, один из которых показывает , снимался ли актер в фильмах с рейтингом G, еще один — для фильмов с рейтингом PG и третий — для фильмов с рейтингом NC-17
SELECT a.first_name, a.last_name,
CASE
WHEN EXISTS (SELECT 1 FROM film_actor fa
INNER JOIN film f ON fa.film_id = f.film_id
WHERE fa.actor_id = a.actor_id
AND f.rating = 'G') THEN 'Y'
ELSE 'N'
END g_actor,

case 
WHEN EXISTS (SELECT 1 FROM film_actor fa
INNER JOIN film f ON fa.film_id = f.film_id
WHERE fa.actor_id = a.actor_id
AND f.rating = 'PG') THEN 'Y'
ELSE 'N'
END pg_actor,
case 
WHEN EXISTS (SELECT 1 FROM film_actor fa
INNER JOIN film f ON fa.film_id = f.film_id
WHERE fa.actor_id = a.actor_id
AND f.rating = 'NC-17') THEN 'Y'
ELSE 'N'
END n17_actor
FROM actor a
WHERE a.last_name LIKE 'S%' OR a.first_name LIKE 'S%';
-- film_actor и film; один из них ищет фильмы с рейтингом G, второй — фильмы с рейтингом PG и третий — фильмы с рейтингом NC-17. Поскольку в каждом предложении when используется оператор exists, условия вычисляются как истинные, если актер появился как минимум в одном фильме с соответствующим рейтингом
-- В других случаях может быть интересно, сколько именно строк имеется, но только до определенного предела. Например, в следующем запросе простое выражение case используется для подсчета количества копий в прокате для каждого фильма, возвращая строки ' Out Of Stock ' (нет в прокате), Scarce ' (редкий), 'Available ' (доступный) или ' Common ' (обычный (в большом количестве)):
SELECT f.title,
CASE (SELECT count(*) FROM inventory i
WHERE i.film_id = f.film_id)
	WHEN 0 THEN 'Out Of Stock'
	WHEN 1 THEN 'Scarce'
	WHEN 2 THEN 'Scarce'
	WHEN 3 THEN 'Available'
	WHEN 4 THEN 'Available'
	ELSE 'Common'
END film_availability
FROM film f;
-- ОШИБКА ДЕЛЕНИЯ НА 0
SELECT 100 / 0;
SELECT с.first_name, с.last_name,
sum(p.amount) tot_payment_amt,
count(p.amount) num_payments,
sum(p.amount) /
	CASE WHEN count(p.amount) = 0 THEN 1
	ELSE count(p.amount)
	END avg_payment
FROM customer с
LEFT OUTER JOIN payment p
ON с.customer_id = p.customer_id
GROUP BY с.first_name, с.last_name;
-- Этот запрос вычисляет среднюю сумму платежа для каждого клиента. Поскольку некоторые клиенты могут быть новыми и еще не брали напрокат ни одного фильма, лучше включить выражение case, чтобы знаменатель никогда не был равен нулю.
-- Условные обновления
-- При обновлении строк в таблице для создания значения столбца иногда требуется условная логика. 
-- Например, предположим, что каждую неделю выполняется задание, которое устанавливает столбец customer.active равным 0 для тех клиентов, которые ни разу не брали фильм напрокат за последние 90 дней. Вот инструкция, которая устанавливает значение 0 или 1 для каждого клиента:
UPDATE customer
	SET active =
		CASE
			WHEN 90 <= (SELECT datediff(now(), max(rental_date))
						FROM rental r
						WHERE r.customer_id = customer.customer_id)
				THEN 0
			ELSE 1
		END
WHERE active = 1;
-- Этот оператор использует коррелированный подзапрос для определения количества дней с момента последнего взятия фильма напрокат для каждого клиента, и полученное значение сравнивается со значением 90; если возвращенное подзапросом значение равно 90 или больше, клиент помечается как неактивный.
-- обработка значений null 
-- Хотя значения null являются подходящими значениями для хранения в таблице в случае, если значение столбца неизвестно, извлекать нулевые значения для отображения или использования в выражениях не всегда целесообразно. Например, пусть необходимо при выводе на экран не оставлять поле пустым, а отобразить в нем слово Unknown (неизвестно). При выборке данных для замены строки, если значение равно null, можно использовать выражение case наподобие следующего:
SELECT c.first_name, c.last_name,
CASE
	WHEN a.address IS NULL THEN 'Unknown'
	ELSE a.address
END address,
CASE
	WHEN ct.city IS NULL THEN 'Unknown'
	ELSE ct.city
	END city,
CASE
	WHEN cn.country IS NULL THEN 'Unknown'
	ELSE cn.country
	END country
FROM customer c
LEFT OUTER JOIN address a ON c.address_id = a.address_id
LEFT OUTER JOIN city ct ON a.city_id = ct.city_id
LEFT OUTER JOIN country cn ON ct.country_id = cn.country_id;
-- -----------------------------------------
-- -----------------------------------------
-- Болье (гл. 16, Аналитические функции)
-- окна данных
--  Например, следующий запрос подсчитывает итоговую сумму общих ежемесячных платежей за прокат фильмов за период с мая по август 2005 года:
SELECT quarter(payment_date) quarter,
monthname(payment_date) month_nm,
sum(amount) monthly_sales
FROM payment
WHERE year(payment_date) = 2005
GROUP BY quarter(payment_date), monthname(payment_date);
--  Но для того, чтобы определить эти самые высокие значения программно, нужно добавить к каждой строке дополнительные столбцы, показывающие максимальные значения за квартал и за весь период. Вот предыдущий запрос, но с добавленными новыми столбцами для вычисления указанных значений:
SELECT quarter(payment_date) quarter,
monthname(payment_date) month_nm,
sum(amount) monthly_sales,
max(sum(amount)) OVER () as max_overall_sales,
max(sum(amount)) OVER (partition by quarter (payment_date) ) as max_qrtr_sales
FROM payment
WHERE year(payment_date) = 2005
GROUP BY quarter(payment_date), monthname(payment_date);
-- локализованная сортировка
-- 
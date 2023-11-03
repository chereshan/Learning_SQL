use sakila;
/*Болье (гл. 3)*/
-- УПРАЖНЕНИЕ 3.1
/*Получите идентификатор актера, а также имя и фамилию для всех актеров. Отсортируйте вывод сначала по фамилии, а затем — по имени.*/
SELECT actor_id, first_name, last_name
FROM actor
ORDER BY last_name, first_name;
-- ------------------------------------------
-- УПРАЖНЕНИЕ 3.2
/*Получите идентификатор, имя и фамилию актера для всех актеров, чьи фамилии — ' WILLIAMS ' или ' DAVIS '.*/
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name='WILLIAMS' OR last_name='DAVIS';
-- ------------------------------------------
-- УПРАЖНЕНИЕ 3.3
/*Напишите запрос к таблице rental, который возвращает идентификаторы клиентов, бравших фильмы напрокат 5 июля 2005 года (используйте столбец rental.rental_date; можете также использовать функцию date ( )*/
SELECT customer_id, rental_date
FROM rental r
WHERE date(r.rental_date)='2005-07-05';
-- ------------------------------------------
-- УПРАЖНЕНИЕ 3.4
/*Заполните пропущенные места (обозначенные как <#>) в следующем многотабличном запросе, чтобы получить показанные результаты*/
SELECT c.email, r.return_date
FROM customer c
	INNER JOIN rental r
	ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY r.return_date DESC;
-- ---------------------------------------
-- ---------------------------------------
-- УПРАЖНЕНИЕ 4.1
/*Какие из идентификаторов платежей будут возвращены при следующих условиях фильтрации?*/
/*customer_id <> 5
AND (amount > 8 OR
date(payment_date) = '2005-08-23')*/
SELECT p.payment_id, date(payment_date), amount
FROM payment p
WHERE p.customer_id!=5 AND (p.amount>8 OR date(payment_date)='2005-08-2');
-- ------------------------------------------
-- УПРАЖНЕНИЕ 4.2
/*Какие из идентификаторов платежей будут возвращены при следующих условиях фильтрации?
 * customer_id = 5 AND
NOT (amount > 6 OR date(payment_date) = '2005-06-19')
 */
SELECT *
FROM payment
WHERE customer_id = 5 AND NOT (amount > 6 OR date(payment_date) = '2005-06-19');
-- ------------------------------------------
-- УПРАЖНЕНИЕ 4.3
/*Создайте запрос, который извлекает из таблицы payments все строки, в которых сумма равна 1,98, 7,98 или 9,98.*/
SELECT *
FROM payment
WHERE amount IN (1.98, 7.98, 9.98);
--
SELECT *
FROM payment
WHERE (amount = 1.98 OR amount = 7.98 OR amount = 9.98);
--------------------------------------------
-- УПРАЖНЕНИЕ 4.4
/*Создайте запрос, который находит всех клиентов, в фамилиях которых содержатся буква А во второй позиции и буква W — в любом месте после А*/
select *
from customer
where last_name LIKE '_A%W%';
-- ---------------------------------------
-- ---------------------------------------
-- УПРАЖНЕНИЕ 5.1
/*Заполните пропущенные места (обозначенные как <# >) в следующем запросе так, чтобы получить показанные результаты:*/
SELECT c.first_name, c.last_name, a.address, ct.city
from customer c
INNER JOIN address a
ON c.address_id = a.address_id
INNER JOIN city ct
ON a.city_id = ct.city_id
WHERE a.district = 'California';
-- УПРАЖНЕНИЕ 5.2
/*Напишите запрос, который выводил бы названия всех фильмов, в которых играл актер с именем JOHN.*/
select a.first_name, f.title
from actor a
join film_actor fa on fa.actor_id=a.actor_id
join film f on f.film_id=fa.film_id
where a.first_name='john';
-- УПРАЖНЕНИЕ 6.3
/*Создайте запрос, который возвращает все адреса в одном и том же городе. Вам нужно будет соединить таблицу адресов с самой собой, и каждая строка должна включать два разных адреса.*/
select c.city, sh.address1, sh.address2
from
(select aa.address address1, a.address address2, a.city_id
from address aa
join address a on a.city_id=aa.city_id
where a.address!=aa.address) sh
join city c on c.city_id=sh.city_id;
-- ---------------------------------------
-- ---------------------------------------
-- УПРАЖНЕНИЕ 5.2
/*Напишите составной запрос, который находит имена и фамилии всех актеров и клиентов, чьи фамилии начинаются с буквы L.*/
SELECT a.first_name, a.last_name
FROM actor a 
WHERE a.last_name LIKE 'L%'
UNION ALL
SElect c.first_name, c.last_name
from customer c 
WHERE c.last_name LIKE 'L%'
order by last_name;

SELECT a.first_name fname, a.last_name lname
FROM actor a 
UNION ALL
SElect c.first_name fname, c.last_name lname
from customer c
WHERE lname LIKE 'L%';
-- ---------------------------------------
-- ---------------------------------------
-- УПРАЖНЕНИЕ 7.1
-- Напишите запрос, который возвращает символы строки 'Please find the substring in this string' с 17-го по 25-й.
select substring('Please find the substring in this string', 17, 9);
-- УПРАЖНЕНИЕ 7.2
-- Напишите запрос, который возвращает абсолютное значение и знак (-1, 0 или 1) числа -25,76823. Верните также число, округленное до ближайших двух знаков после запятой.
select abs(-25.76823), sign(-25.76823), round(-25.76823,2);
-- УПРАЖНЕНИЕ 7.3
-- Напишите запрос, возвращающий для текущей даты только часть, соответствующую месяцу.
SELECT MONTH(curdate());
-- ---------------------------------------
-- ---------------------------------------
-- УПРАЖНЕНИЕ 8.1
-- Создайте запрос, который подсчитывает количество строк в таблице payment.
select count(*)
from payment;
-- УПРАЖНЕНИЕ 8.2
-- Измените запрос из упражнения 8.1 так, чтобы подсчитать количество платежей, произведенных каждым клиентом. Выведите идентификатор клиента и общую уплаченную сумму для каждого клиента.
select customer_id, count(*), sum(amount)
from payment
group by customer_id;
-- УПРАЖНЕНИЕ 8.3
-- Измените запрос из упражнения 8.2, включив в него только тех клиентов, у которых имеется не менее 40 выплат .
select customer_id, count(*), sum(amount)
from payment
group by customer_id
having count(*)>=40;
-- ---------------------------------------
-- ---------------------------------------
-- УПРАЖНЕНИЕ 9.1
-- Создайте запрос к таблице film, который использует условие фильтрации с некоррелированным подзапросом к таблице category, чтобы найти все боевики (category.name ='Action')
select title
FROM FILM
where film_id in 
	(select film_id from film_category where category_id=
		(select category_id from category where name='Action'));
-- УПРАЖНЕНИЕ 9.2
-- Переработайте запрос из упражнения 9.1, используя коррелированный подзапрос к таблицам category и film_category для получения тех же результатов.
select title
FROM FILM f
where (select category_id from category where name='Action')=
	(select category_id from film_category fc where fc.film_id=f.film_id);
--
SELECT f.title
FROM film f
WHERE EXISTS
(SELECT 1
FROM film_category fc 
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action'
AND fc.film_id = f.film_id);
-- УПРАЖНЕНИЕ 8.3
-- Соедините следующий запрос с подзапросом к таблице film_actor, чтобы показать уровень мастерства каждого актера:
SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
UNION ALL
SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
UNION ALL
SELECT 'Newcomer' level, 1 min_roles, 19 max_roles;
-- Подзапрос к таблице film_actor должен подсчитывать количество строк для каждого актера с использованием group by actor_id, и результат подсчета должен сравниваться со столбцами min_roles/max_roles, чтобы определить, какой уровень мастерства имеет каждый актер.
select *,actr.actor_id, num_roles, grps.level
from 
(select actor_id, count(*) num_roles
from film_actor
group by actor_id) as actr
inner join
(SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
UNION ALL
SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
UNION ALL
SELECT 'Newcomer' level, 1 min_roles, 19 max_roles) as grps
on actr.num_roles between  grps.min_roles AND grps.max_roles;
-- ---------------------------------------
-- ---------------------------------------
-- УПРАЖНЕНИЕ 10.1
-- Используя следующие определения таблиц и данные, напишите запрос, который возвращает имя каждого клиента вместе с его суммами платежей:
-- картинка
-- Включите в результирующий набор всех клиентов, даже если для клиента нет записей о платежах.
SELECT c.customer_id, concat(c.first_name,' ', c.last_name) name, SUM(p.amount)
from customer c
left OUTER join payment p on p.customer_id=c.customer_id
group by c.customer_id;
-- УПРАЖНЕНИЕ 10.2
-- Измените запрос из упражнения 10.1 таким образом, чтобы использовать другой тип внешнего соединения (например, если вы использовали левое внешнее соединение в упражнении 10.1, на этот раз используйте правое внешнее соединение) так, чтобы результаты были идентичны полученным ранее.
SELECT c.customer_id, concat(c.first_name,' ', c.last_name) name, SUM(p.amount)
from payment p
right OUTER join customer c on p.customer_id=c.customer_id
group by c.customer_id;
-- УПРАЖНЕНИЕ 10.3
-- Разработайте запрос, который будет генерировать набор {1, 2, 3, ..., 99, 100}. (Указание: используйте перекрестное соединение как минимум с двумя подзапросами в предложении from.)
SELECT ones.x + tens.x + 1
FROM
(SELECT 0 x UNION ALL
SELECT 1 x UNION ALL
SELECT 2 x UNION ALL
SELECT 3 x UNION ALL
SELECT 4 x UNION ALL
SELECT 5 x UNION ALL
SELECT 6 x UNION ALL
SELECT 7 x UNION ALL
SELECT 8 x UNION ALL
SELECT 9 x
) ones
CROSS JOIN
(SELECT 0 x UNION ALL
SELECT 10 x UNION ALL
SELECT 20 x UNION ALL
SELECT 30 x UNION ALL
SELECT 40 x UNION ALL
SELECT 50 x UNION ALL
SELECT 60 x UNION ALL
SELECT 70 x UNION ALL
SELECT 80 x UNION ALL
SELECT 90 x
) tens;
-- ---------------------------------------
-- ---------------------------------------
-- УПРАЖНЕНИЕ 11.1
-- Перепишите следующий запрос, в котором используется простое выражение case, так, чтобы получить те же результаты с использованием поискового выражения case. Старайтесь, насколько это возможно, использовать как можно меньше предложений when.
SELECT name,
CASE name
    WHEN 'English' THEN 'latin1'
    WHEN 'Italian' THEN 'latin1'
    WHEN 'French' THEN 'latin1'
    WHEN 'German' THEN 'latin1'
    WHEN 'Japanese' THEN 'utf8'
    WHEN 'Mandarin' THEN 'utf8'
    ELSE 'Unknown'
END character_set
FROM language;
--
select name,
case
	when name in ('English', 'Italian', 'French', 'German') then 'latin1'
    when name in ('Japanese', 'Mandarin') then 'utf8'
    else 'Unknown'
    end character_set
from language;
-- УПРАЖНЕНИЕ 11.1
-- Перепишите следующий запрос так, чтобы результирующий набор содержал одну строку с пятью столбцами (по одному для каждого рейтинга). Назовите эти пять столбцов G, PG, PG_13, R и NC_17.
SELECT 
SUM(case when rating='G' THEN 1 ELSE 0 END) G,
SUM(case when rating='PG' THEN 1 ELSE 0 END) PG,
SUM(case when rating='PG-13' THEN 1 ELSE 0 END) PG_13,
SUM(case when rating='R' THEN 1 ELSE 0 END) R,
SUM(case when rating='NC-17' THEN 1 ELSE 0 END) NC_17
FROM film;
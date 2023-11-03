-- DROP TABLE;
-- 0. СОЗДАНИЕ ТАБЛИЦ
CREATE DATABASE stasyshin;
use stasyshin;
-- drop table suppliers;
CREATE TABLE suppliers (
    post_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name NVARCHAR(20),
    rating INTEGER,
    town NVARCHAR(20)
);
--
INSERT INTO suppliers 
values
(null, 'Смит', 20, 'Лондон'),
(null, 'Джонс', 10, 'Париж'),
(null, 'Блейк', 30, 'Париж'),
(null, 'Кларк', 20, 'Лондон'),
(null, 'Адамс', 30, 'Афины')
;
-- ---------------------------------------
-- DROP TABLE PARTS;
CREATE TABLE parts (
    det_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name NVARCHAR(20),
    color NVARCHAR(20),
    weight INTEGER,
    town NVARCHAR(20)
);
--
INSERT INTO parts
values
(null,'Гайка', 'Красный', 12, 'Лондон'),
(null,'Болт', 'Зеленый', 17, 'Париж'),
(null,'Винт', 'Голубой', 17, 'Рим'),
(null,'Винт', 'Красный', 14, 'Лондон'),
(null,'Кулачок', 'Голубой', 12, 'Париж'),
(null,'Блюм', 'Красный', 19, 'Лондон');
-- ---------------------------------------
-- drop table products;
CREATE TABLE products (
    izd_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name NVARCHAR(20),
    town NVARCHAR(20)
);
--
INSERT INTO products
values
(null, 'Жесткий диск', 'Париж'),
(null, 'Перфоратор', 'Рим'),
(null, 'Считыватель', 'Афины'),
(null, 'Принтер', 'Афины'),
(null, 'Флоппи-диск', 'Лондон'),
(null, 'Терминал', 'Осло'),
(null, 'Лента', 'Лондон');
-- ---------------------------------------
-- drop table shipments;
CREATE TABLE shipments (
    ship_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    post_id INTEGER,
    det_id INTEGER,
    izd_id INTEGER,
    amount INTEGER
);
--
INSERT INTO shipments 
values
(null, 1, 1, 1, 200),
(null, 1, 1, 4, 700),
(null, 2, 3, 1, 400),
(null, 2, 3, 2, 200),
(null, 2, 3, 3, 200),
(null, 2, 3, 4, 500),
(null, 2, 3, 5, 600),
(null, 2, 3, 6, 400),
(null, 2, 3, 7, 800),
(null, 2, 5, 2, 100),
(null, 3, 3, 1, 200),
(null, 3, 4, 2, 500),
(null, 4, 6, 3, 300),
(null, 4, 6, 7, 300),
(null, 5, 2, 2, 200),
(null, 5, 2, 4, 100),
(null, 5, 5, 5, 500),
(null, 5, 5, 7, 100),
(null, 5, 6, 2, 200),
(null, 5, 1, 4, 100),
(null, 5, 3, 4, 200),
(null, 5, 4, 4, 800),
(null, 5, 5, 4, 400),
(null, 5, 6, 4, 500)
;
-- 0.ДОП. Жаргон
-- Число поставок…. == число строк таблицы spj ….
-- Объем поставки == количество поставленных деталей == значение столбца kol таблицы spj.
-- Количество деталей …. == количество поставленных деталей == значение столбца kol таблицы spj.
-- Вес поставки == количество поставленных деталей * вес поставленной детали (вес, указанный в таблице p, – это вес одной детали).
-- Число деталей …. == число разных номеров (наименований, видов, типов) деталей….
-- Число изделий …. == число разных номеров (наименований, видов, типов) изделий ….
-- Число поставщиков …. == число разных номеров (наименований, видов, типов) поставщиков ….
-- Город, из которого сделана поставка, == город, где производится деталь, указанная в поставке.
-- Город, куда сделана поставка, == город, где собирают изделие, указанное в поставке.
-- ВАЖНО! ВСЮДУ, ГДЕ ИСПОЛЬЗУЕТСЯ LENGTH() СТОИТ ИСПОЛЬЗОВАТЬ CHAR_LENGTH(), т.к. первая будет выдавать удвоенный в результат в результате кодировки, которая находит ближайший самый похожий символ, а для кирилических символов их, судя по всему, нужно 2
-- -----------------------------------------------
-- -----------------------------------------------

-- 1. Найти поставщиков, которые поставляли детали красного цвета для изделий с длиной названия >8. Вывести номера поставщиков без повторений в порядке возрастания номеров. 
select distinct stab.post_name, stab.post_id
from
(select p.color, s.name post_name, CHAR_LENGTH(pr.name) len_name, pr.name izd_name, s.post_id
from shipments sh
join parts p on p.det_id=sh.det_id
join suppliers s on s.post_id=sh.post_id
join products pr on pr.izd_id=sh.izd_id) stab
where len_name>8 and color='Красный'
order by 2;

-- ДЗ: 1. Вывести о каждой поставке информацию:
-- город, откуда сделана поставка;
-- город, куда поставлены детали;
-- количество деталей;
-- вес детали.  
select sh.ship_id,sh.amount, p.town town_from, pr.town town_to, p.weight
FROM shipments sh
join parts p on p.det_id=sh.det_id
join products pr on pr.izd_id=sh.izd_id;
-- ДЗ: 2. Вывести без повторений пары цвет детали – город, куда поставлена деталь.
select distinct p.color, pr.town
from shipments sh
join parts p on p.det_id=sh.det_id
join products pr on pr.izd_id=sh.izd_id;
-- -----------------------------------------------
-- -----------------------------------------------
-- 2. Выдать число изделий, для которых поставлялись детали из города, где проживает поставщик с максимальным рейтингом.
-- города поставщиков с максимальным рейтингом
select town
from suppliers
where rating in (select max(rating) 
from suppliers);
-- Выведем информацию о поставках и деталях из тех городов, где поставщики имеют максимальный рейтинг
select *
from shipments sh
join parts p on p.det_id=sh.det_id
where p.town in (select town
from suppliers
where rating in (select max(rating) 
from suppliers));
-- Окончательный запрос: # РАЗЛИЧНЫХ id изделий
select count(distinct sh.izd_id)
from shipments sh
join parts p on p.det_id=sh.det_id
where p.town in (select town
from suppliers
where rating in (select max(rating) 
from suppliers));
-- ДЗ: Определить средний вес поставки в город, где производят изделие с самым длинным названием.
-- самое длинное название изделия
select max(CHAR_LENGTH(name))
from products;
-- город, где производится изделие с самым длинным названием
select town from products
where CHAR_LENGTH(name) in (select max(CHAR_LENGTH(name)) from products);
--
select sh.*, pr.town, p.weight from shipments sh
join parts p on p.det_id=sh.det_id
join products pr on pr.izd_id=sh.izd_id
where pr.town in 
(select town from products
where CHAR_LENGTH(name) in (select max(CHAR_LENGTH(name)) from products));
-- Окончательное решение
select avg(p.weight*sh.amount) from shipments sh
join parts p on p.det_id=sh.det_id
join products pr on pr.izd_id=sh.izd_id
where pr.town in 
(select town from products
where CHAR_LENGTH(name) in (select max(CHAR_LENGTH(name)) from products));
-- -----------------------------------------------
-- -----------------------------------------------
-- 3. Выбрать изделия, для которых поставлялись красные детали, поставлявшиеся для изделия c названием длиной больше 11
-- изделия с длиной названия больше 11
select *, CHAR_LENGTH(TRIM(name))
from products 
where CHAR_LENGTH(TRIM(name))>11;
-- Красные детали
select *
from parts
where color='Красный';
-- Детали, поставлявшиеся для изделий с именем длины >11.
select distinct sh.det_id
from shipments sh
join products pr on pr.izd_id=sh.izd_id
where char_length(TRIM(pr.name))>11;
-- Красные детали, поставлявшиеся для изделий с именем длины >11.
select sh.det_id
from shipments sh
join products pr on pr.izd_id=sh.izd_id
JOIN parts p on p.det_id=sh.det_id
where char_length(TRIM(pr.name))>11
and p.color='Красный';
-- Окончательный ответ
select distinct t.izd_id
from shipments t
where t.det_id in
(select sh.det_id
from shipments sh
join products pr on pr.izd_id=sh.izd_id
JOIN parts p on p.det_id=sh.det_id
where char_length(TRIM(pr.name))>11
and p.color='Красный');
-- ДЗ: Выбрать поставщиков, которые поставляли детали с весом > 17, поставлявшиеся для изделий из Афин.
-- поставки деталей весом>17
select *
from shipments sh
join parts p on p.det_id=sh.det_id
where p.weight>17;
-- Изделия из Афин 
select izd_id
from products
where town='Афины';
-- Детали поставлявшиеся для изделий из афин
select distinct post_id
from shipments sh
join products pr on pr.izd_id=sh.det_id
join parts p on p.det_id=sh.det_id
where pr.town='Афины' and 
post_id in (select distinct post_id
from shipments sh
join products pr on pr.izd_id=sh.det_id
join parts p on p.det_id=sh.det_id
where weight>17);
-- -----------------------------------------------
-- -----------------------------------------------
-- 4. Выдать число деталей, поставлявшихся поставщиками, проживающими в городе, где собирают изделие с буквой «ф» в названии. 
-- Города где собирают изделия с буквой "ф"
select *
from products
where lower(name) like '%ф%';
-- Поставщики из города, где собирают изделие с буквой "ф"
select *
from suppliers s
where s.town in 
(select pr.town
from products pr
where lower(pr.name) like '%ф%');
-- Поставки от этих поставщиков
select *
from shipments
where post_id in
(select post_id
from suppliers 
where post_id in
(select s.post_id
from suppliers s
where s.town in 
(select p.town
from products p
where lower(p.name) like '%ф%')));
-- Окончательный ответ
select count(distinct det_id)
from shipments
where post_id in
(select post_id
from suppliers 
where post_id in
(select s.post_id
from suppliers s
where s.town in 
(select p.town
from products p
where lower(p.name) like '%ф%')));
-- ДЗ: Выдать число городов, в которые выполняли поставки поставщики, поставлявшие какую-либо зеленую деталь. 
-- Зеленые детали
select *
from parts
where color='Зеленый';
-- Поставки зеленых деталей (только 1 поставщик зеленых деталей)
select count(distinct pr.town)
from shipments sh
join parts p on p.det_id=sh.det_id
join products pr on pr.izd_id=sh.izd_id
where p.color='Зеленый';
-- -----------------------------------------------
-- -----------------------------------------------
-- 5. Построить таблицу со списком городов таких, что в городе вместе с поставщиком размещаются либо только детали, либо только изделия, но не то и другое вместе. 
-- города поставщиков и деталями
SELECT distinct town FROM SUPPLIERS
where town in (select town from parts);
-- города поставщиков и изделий
SELECT distinct town FROM SUPPLIERS
where town in (select town from products);
-- города поставщиков + деталей + изделий
SELECT distinct town FROM SUPPLIERS
where town in (select town from parts where town in (select town from products));
-- окончательное решение 
select * from
(SELECT distinct town FROM SUPPLIERS
where town in (select town from parts)
union all
SELECT distinct town FROM SUPPLIERS
where town in (select town from products)) x
where town not in (SELECT distinct town FROM SUPPLIERS
where town in (select town from parts where town in (select town from products)));
-- ДЗ: Построить таблицу с упорядоченным списком городов таких, что в городе размещается более одного поставщика и производится какая-либо деталь, но не собирается ни одно изделие.
-- Измените данные таким образом, чтобы запрос давал другой результат.
-- города с 2мя поставщиками
SELECT town
FROM SUPPLIERS
group by town
having COUNT(*)>1;
-- Окончательное решение
select distinct town
from suppliers
where town in 
(SELECT town
FROM SUPPLIERS
group by town
having COUNT(POST_ID)>1)
and
town in
(select town from parts)
and town not in (select town from products);
-- -----------------------------------------------
-- -----------------------------------------------
-- 5. Получить список деталей, которые поставляли ТОЛЬКО поставщики, выполнившие поставки в Рим.
-- поставки в рим
select *, p.town to_town from parts
join shipments using(det_id)
join suppliers using(post_id)
join products p using(izd_id)
having to_town='Рим';
-- детали 
-- окончательный ответ


select distinct town from products order by 1;
select distinct town from suppliers order by 1;
select distinct town from parts order by 1;

--
select * from shipments;
select * from products;
select * from suppliers;
select * from parts;
-- 
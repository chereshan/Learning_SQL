
use billing_simple;
select * from billing;

select payer_email, sum, currency
from billing
	where sum>900 and currency='CHF';

select payer_email, sum, currency
from billing
	where sum>900 and currency IN ('CHF', 'GBP');
    
--

use project_simple;
select * from project; 
-- number of raws
select count(1) from project;
-- average
select avg(budget) from project;

-- how many days in average spend on project
select 
avg(datediff(p.project_finish, p.project_start)),
max(datediff(p.project_finish, p.project_start)) as max_days,
min(datediff(p.project_finish, p.project_start)),
p.client_name
from project p
where project_finish is not null
group by p.client_name
order by max_days desc
limit 10;

use store_simple;
select * from store;

select category, count(1) from store
group by category
order by category;

-- revenue
select sum(price*sold_num)
from store;

-- most popular categories
select category, sum(sold_num) as s
from store
group by category
order by s desc
limit 10;

--
SELECT MAX(datediff(return_date,rental_date))
from rental;

use sakila;
select * from rental;

SELECT MAX(datediff(return_date,rental_date))
 FROM rental;
 
 SELECT extract(YEAR FROM rental_date) year,
 COUNT(*) how_many
FROM rental
GROUP BY extract(YEAR FROM rental_date);

SELECT fa.actor_id, f.rating, count(*) num
FROM film_actor fa
INNER JOIN film f
ON fa.film_id = f.film_id
GROUP BY fa.actor_id, f.rating WITH ROLLUP;

--
SELECT fa.actor_id, f.rating, count(*)
FROM film_actor fa
INNER JOIN film f
ON fa.film_id = f.film_id
WHERE f.rating IN ('G','PG')
GROUP BY fa.actor_id, f.rating
HAVING count(*) > 9;


-- ----------------------------------------------------
-- STEPIK: ИНТЕРАКТИВНЫЙ ТРЕНАЖЕР ПО SQL
CREATE DATABASE stepik;
USE STEPIK;
CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author NVARCHAR(50)
);

INSERT INTO author (name_author)
VALUES ('Булгаков М.А.'),
       ('Достоевский Ф.М.'),
       ('Есенин С.А.'),
       ('Пастернак Б.Л.'),
       ('Лермонтов М.Ю.');

CREATE TABLE genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name_genre NVARCHAR(30)
);

INSERT INTO genre(name_genre)
VALUES ('Роман'),
       ('Поэзия'),
       ('Приключения');

CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title NVARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8, 2),
    amount INT,
    FOREIGN KEY (author_id)
        REFERENCES author (author_id)
        ON DELETE CASCADE,
    FOREIGN KEY (genre_id)
        REFERENCES genre (genre_id)
        ON DELETE SET NULL
);

INSERT INTO book (title, author_id, genre_id, price, amount)
VALUES  ('Мастер и Маргарита', 1, 1, 670.99, 3),
        ('Белая гвардия ', 1, 1, 540.50, 5),
        ('Идиот', 2, 1, 460.00, 10),
        ('Братья Карамазовы', 2, 1, 799.01, 2),
        ('Игрок', 2, 1, 480.50, 10),
        ('Стихотворения и поэмы', 3, 2, 650.00, 15),
        ('Черный человек', 3, 2, 570.20, 6),
        ('Лирика', 4, 2, 518.99, 2);

CREATE TABLE city (
    city_id INT PRIMARY KEY AUTO_INCREMENT,
    name_city NVARCHAR(30),
    days_delivery INT
);

INSERT INTO city(name_city, days_delivery)
VALUES ('Москва', 5),
       ('Санкт-Петербург', 3),
       ('Владивосток', 12);

CREATE TABLE client (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    name_client NVARCHAR(50),
    city_id INT,
    email VARCHAR(30),
    FOREIGN KEY (city_id) REFERENCES city (city_id)
);

INSERT INTO client(name_client, city_id, email)
VALUES ('Баранов Павел', 3, 'baranov@test'),
       ('Абрамова Катя', 1, 'abramova@test'),
       ('Семенонов Иван', 2, 'semenov@test'),
       ('Яковлева Галина', 1, 'yakovleva@test');

CREATE TABLE buy(
    buy_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_description NVARCHAR(100),
    client_id INT,
    FOREIGN KEY (client_id) REFERENCES client (client_id)
);

INSERT INTO buy (buy_description, client_id)
VALUES ('Доставка только вечером', 1),
       (NULL, 3),
       ('Упаковать каждую книгу по отдельности', 2),
       (NULL, 1);

CREATE TABLE buy_book (
    buy_book_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_id INT,
    book_id INT,
    amount INT,
    FOREIGN KEY (buy_id) REFERENCES buy (buy_id),
    FOREIGN KEY (book_id) REFERENCES book (book_id)
);

INSERT INTO buy_book(buy_id, book_id, amount)
VALUES (1, 1, 1),
       (1, 7, 2),
       (1, 3, 1),
       (2, 8, 2),
       (3, 3, 2),
       (3, 2, 1),
       (3, 1, 1),
       (4, 5, 1);

CREATE TABLE step (
    step_id INT PRIMARY KEY AUTO_INCREMENT,
    name_step NVARCHAR(30)
);

INSERT INTO step(name_step)
VALUES ('Оплата'),
       ('Упаковка'),
       ('Транспортировка'),
       ('Доставка');

CREATE TABLE buy_step (
    buy_step_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_id INT,
    step_id INT,
    date_step_beg DATE,
    date_step_end DATE,
    FOREIGN KEY (buy_id) REFERENCES buy (buy_id),
    FOREIGN KEY (step_id) REFERENCES step (step_id)
);

INSERT INTO buy_step(buy_id, step_id, date_step_beg, date_step_end)
VALUES (1, 1, '2020-02-20', '2020-02-20'),
       (1, 2, '2020-02-20', '2020-02-21'),
       (1, 3, '2020-02-22', '2020-03-07'),
       (1, 4, '2020-03-08', '2020-03-08'),
       (2, 1, '2020-02-28', '2020-02-28'),
       (2, 2, '2020-02-29', '2020-03-01'),
       (2, 3, '2020-03-02', NULL),
       (2, 4, NULL, NULL),
       (3, 1, '2020-03-05', '2020-03-05'),
       (3, 2, '2020-03-05', '2020-03-06'),
       (3, 3, '2020-03-06', '2020-03-10'),
       (3, 4, '2020-03-11', NULL),
       (4, 1, '2020-03-20', NULL),
       (4, 2, NULL, NULL),
       (4, 3, NULL, NULL),
       (4, 4, NULL, NULL);
       
DROP TABLE IF EXISTS buy_archive;
CREATE TABLE buy_archive
(
    buy_archive_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_id         INT,
    client_id      INT,
    book_id        INT,
    date_payment   DATE,
    price          DECIMAL(8, 2),
    amount         INT
);

INSERT INTO buy_archive (buy_id, client_id, book_id, date_payment, amount, price)
VALUES (2, 1, 1, '2019-02-21', 2, 670.60),
       (2, 1, 3, '2019-02-21', 1, 450.90),
       (1, 2, 2, '2019-02-10', 2, 520.30),
       (1, 2, 4, '2019-02-10', 3, 780.90),
       (1, 2, 3, '2019-02-10', 1, 450.90),
       (3, 4, 4, '2019-03-05', 4, 780.90),
       (3, 4, 5, '2019-03-05', 2, 480.90),
       (4, 1, 6, '2019-03-12', 1, 650.00),
       (5, 2, 1, '2019-03-18', 2, 670.60),
       (5, 2, 4, '2019-03-18', 1, 780.90);       
       
       
-- Вывести все заказы Баранова Павла (``id`` заказа, какие книги, по какой цене и в каком количестве он заказал) в отсортированном по номеру заказа и названиям книг виде.
SELECT b.buy_id, book.title, book.price, bb.amount
FROM client c
RIGHT JOIN buy b on b.client_id=c.client_id
right join buy_book bb on bb.buy_id=b.buy_id
right join book on book.book_id=bb.book_id
WHERE NAME_CLIENT='Баранов Павел'
order by 1, 2;
-- Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора (нужно посчитать, в каком количестве заказов фигурирует каждая книга).  Вывести фамилию и инициалы автора, название книги, последний столбец назвать Количество. Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.
SELECT a.name_author, b.title, sum(if(bb.buy_book_id is null, 0, 1)) as Количество
from buy_book bb
right outer join book b on b.book_id=bb.book_id 
left outer join author a on a.author_id=b.author_id
group by a.name_author, b.title
order by 1,2;
-- Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. Указать количество заказов в каждый город, этот столбец назвать Количество. Информацию вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.
select *
from city
right join client using(city_id);
select name_city, count(buy_id) as Количество
from city
right join client using(city_id)
right join buy using(client_id)
group by name_city;
-- Вывести номера всех оплаченных заказов и даты, когда они были оплачены.
select buy_id, date_step_end
from buy b
right join 
(select *
from buy_step
where step_id=1 and date_step_end is not null) x using(buy_id);
-- Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость (сумма произведений количества заказанных книг и их цены), в отсортированном по номеру заказа виде. Последний столбец назвать Стоимость.
select buy_id, name_client, sum(price*buy_book.amount) Стоимость
from buy
left join client using(client_id)
left join buy_book using(buy_id)
left join book using(book_id)
group by buy_id
order by 1;
-- Вывести номера заказов (buy_id) и названия этапов,  на которых они в данный момент находятся. Если заказ доставлен –  информацию о нем не выводить. Информацию отсортировать по возрастанию buy_id.
select buy_id, name_step
from buy
right join 
(select *
from buy_step
where date_step_beg is not null and date_step_end is null) x 
using(buy_id)
left join step using(step_id);
-- последний этап
select *
from buy_step
where date_step_beg is not null and date_step_end is null;
-- В таблице city для каждого города указано количество дней, за которые заказ может быть доставлен в этот город (рассматривается только этап "Транспортировка"). Для тех заказов, которые прошли этап транспортировки, вывести количество дней за которое заказ реально доставлен в город. А также, если заказ доставлен с опозданием, указать количество дней задержки, в противном случае вывести 0. В результат включить номер заказа (buy_id), а также вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в отсортированном по номеру заказа виде.
SELECT *
FROM CITY;

-- ЗАКАЗЫ ПРОШЕДШИЕ ЭТАП ТРАНСОПРТИРОВКИ
select buy_id, datediff(date_step_end, date_step_beg) Количество_дней,
IF(datediff(date_step_end, date_step_beg)-city.days_delivery>=0,datediff(date_step_end, date_step_beg)-city.days_delivery, 0 ) Опоздание
from buy_step
JOIN STEP USING(STEP_ID)
left join buy using(buy_id)
left join client using(client_id)
left join city using (city_id)
WHERE NAME_STEP='Транспортировка' and date_step_beg is not null and date_step_end is not null;
-- Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту виде. В решении используйте фамилию автора, а не его id.
select distinct name_client 
from client
right join buy using(client_id)
right join buy_book using(buy_id)
left join book using(book_id)
left join author using(author_id)
where name_author like 'Достоевский%'
order by 1;
-- Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, указать это количество. Последний столбец назвать Количество.
select name_genre, Количество
from
(select name_genre, sum(buy_book.amount) Количество
from buy
left join buy_book using(buy_id)
left join book using(book_id)
left join genre using(genre_id)
group by name_genre) xt

where Количество>=all(select sum(buy_book.amount)
from buy
left join buy_book using(buy_id)
left join book using(book_id)
left join genre using(genre_id)
group by name_genre)
;
-- Сравнить ежемесячную выручку от продажи книг за текущий и предыдущий годы. Для этого вывести год, месяц, сумму выручки в отсортированном сначала по возрастанию месяцев, затем по возрастанию лет виде. Название столбцов: Год, Месяц, Сумма.
select *
from buy;
-- Выручка по оплаченным заказам 2020
(select  year(date_step_end) Год, monthname(date_step_end) Месяц, sum(price*buy_book.amount) Сумма
from buy
left join buy_step using(buy_id)
left join buy_book using(buy_id)
left join book using(book_id)
where step_id=1 and date_step_end is not null
group by Год, Месяц)
union
(select year(date_payment) Год, monthname(date_payment) Месяц, sum(price*amount) Сумма
from buy_archive
group by Год, Месяц)
order by 2, 1 asc;
-- Для каждой отдельной книги необходимо вывести информацию о количестве проданных экземпляров и их стоимости за 2020 и 2019 год. Вычисляемые столбцы назвать Количество и Сумма. Информацию отсортировать по убыванию стоимости.
select title, sum(Количество) Количество, sum(Сумма) Сумма
from
((select book.title title, buy_book.amount Количество, book.price*buy_book.amount Сумма
from buy
left join buy_step using(buy_id)
left join buy_book using(buy_id)
left join book using(book_id)
where step_id=1 and date_step_end is not null)
union all
(select book.title, buy_archive.amount Количество, buy_archive.price*buy_archive.amount Сумма
from buy_archive
left join book using (book_id))) x
group by title
order by Сумма desc;
-- Вывести названия книг, которые ни разу не были заказаны, отсортировав в алфавитном порядке.
select title
from book
left outer join buy_book using(book_id)
where buy_book_id is null;
-- 
select amount-coalesce(sec_sum, 0)
from 
(select book_id, sum(amount) sec_sum
from buy_book
group by book_id) x
right join book using(book_id);
--

-- пункт 3

create database online_test_stepik;
use online_test_stepik;

CREATE TABLE subject (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    name_subject nvarchar(30)
);

INSERT INTO subject (subject_id,name_subject) VALUES 
    (1,'Основы SQL'),
    (2,'Основы баз данных'),
    (3,'Физика');

CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name_student nvarchar(50)
);

INSERT INTO student (student_id,name_student) VALUES
    (1,'Баранов Павел'),
    (2,'Абрамова Катя'),
    (3,'Семенов Иван'),
    (4,'Яковлева Галина');

CREATE TABLE attempt (
    attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    subject_id INT,
    date_attempt date,
    result INT,
    FOREIGN KEY (student_id) REFERENCES student (student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
);

INSERT INTO attempt (attempt_id,student_id,subject_id,date_attempt,result) VALUES
    (1,1,2,'2020-03-23',67),
    (2,3,1,'2020-03-23',100),
    (3,4,2,'2020-03-26',0),
    (4,1,1,'2020-04-15',33),
    (5,3,1,'2020-04-15',67),
    (6,4,2,'2020-04-21',100),
    (7,3,1,'2020-05-17',33);

CREATE TABLE question (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    name_question nvarchar(100), 
    subject_id INT,
    FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
);

INSERT INTO question (question_id,name_question,subject_id) VALUES
    (1,'Запрос на выборку начинается с ключевого слова:',1),
    (2,'Условие, по которому отбираются записи, задается после ключевого слова:',1),
    (3,'Для сортировки используется:',1),
    (4,'Какой запрос выбирает все записи из таблицы student:',1),
    (5,'Для внутреннего соединения таблиц используется оператор:',1),
    (6,'База данных - это:',2),
    (7,'Отношение - это:',2),
    (8,'Концептуальная модель используется для',2),
    (9,'Какой тип данных не допустим в реляционной таблице?',2);

CREATE TABLE answer (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    name_answer nvarchar(100),
    question_id INT,
    is_correct BOOLEAN,
    CONSTRAINT answer_ibfk_1 FOREIGN KEY (question_id) REFERENCES question (question_id) ON DELETE CASCADE
);

INSERT INTO answer (answer_id,name_answer,question_id,is_correct) VALUES
    (1,'UPDATE',1,FALSE),
    (2,'SELECT',1,TRUE),
    (3,'INSERT',1,FALSE),
    (4,'GROUP BY',2,FALSE),
    (5,'FROM',2,FALSE),
    (6,'WHERE',2,TRUE),
    (7,'SELECT',2,FALSE),
    (8,'SORT',3,FALSE),
    (9,'ORDER BY',3,TRUE),
    (10,'RANG BY',3,FALSE),
    (11,'SELECT * FROM student',4,TRUE),
    (12,'SELECT student',4,FALSE),
    (13,'INNER JOIN',5,TRUE),
    (14,'LEFT JOIN',5,FALSE),
    (15,'RIGHT JOIN',5,FALSE),
    (16,'CROSS JOIN',5,FALSE),
    (17,'совокупность данных, организованных по определенным правилам',6,TRUE),
    (18,'совокупность программ для хранения и обработки больших массивов информации',6,FALSE),
    (19,'строка',7,FALSE),
    (20,'столбец',7,FALSE),
    (21,'таблица',7,TRUE),
    (22,'обобщенное представление пользователей о данных',8,TRUE),
    (23,'описание представления данных в памяти компьютера',8,FALSE),
    (24,'база данных',8,FALSE),
    (25,'file',9,TRUE),
    (26,'INT',9,FALSE),
    (27,'VARCHAR',9,FALSE),
    (28,'DATE',9,FALSE);

CREATE TABLE testing (
    testing_id INT PRIMARY KEY AUTO_INCREMENT,
    attempt_id INT,
    question_id INT,
    answer_id INT,
    FOREIGN KEY (attempt_id) REFERENCES attempt (attempt_id) ON DELETE CASCADE
);

INSERT INTO testing (testing_id,attempt_id,question_id,answer_id) VALUES
    (1,1,9,25),
    (2,1,7,19),
    (3,1,6,17),
    (4,2,3,9),
    (5,2,1,2),
    (6,2,4,11),
    (7,3,6,18),
    (8,3,8,24),
    (9,3,9,28),
    (10,4,1,2),
    (11,4,5,16),
    (12,4,3,10),
    (13,5,2,6),
    (14,5,1,2),
    (15,5,4,12),
    (16,6,6,17),
    (17,6,8,22),
    (18,6,7,21),
    (19,7,1,3),
    (20,7,4,11),
    (21,7,5,16);
-- Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат. Информацию вывести по убыванию результатов тестирования.
select name_student, date_attempt, result
from student
left join attempt using(student_id)
left join subject using(subject_id)
where name_subject='Основы баз данных'
order by result desc;
-- Вывести, сколько попыток сделали студенты по каждой дисциплине, а также средний результат попыток, который округлить до 2 знаков после запятой. Под результатом попытки понимается процент правильных ответов на вопросы теста, который занесен в столбец result.  В результат включить название дисциплины, а также вычисляемые столбцы Количество и Среднее. Информацию вывести по убыванию средних результатов.
select name_subject, sum(IF(attempt_id is null, 0, 1)) Количество, round(AVG(result),2) Среднее
from subject
left join attempt using(subject_id)
group by name_subject
;
-- Вывести студентов (различных студентов), имеющих максимальные результаты попыток. Информацию отсортировать в алфавитном порядке по фамилии студента.
-- Максимальный результат не обязательно будет 100%, поэтому явно это значение в запросе не задавать.
select name_student, max(result) result
from student
left join attempt using(student_id)
group by name_student
having result in (select max(result) from attempt);
-- Если студент совершал несколько попыток по одной и той же дисциплине, то вывести разницу в днях между первой и последней попыткой. В результат включить фамилию и имя студента, название дисциплины и вычисляемый столбец Интервал. Информацию вывести по возрастанию разницы. Студентов, сделавших одну попытку по дисциплине, не учитывать. 
select name_student, name_subject, datediff(max(date_attempt), min(date_attempt)) Интервал
from attempt
right join student using(student_id)
right join subject using(subject_id)
group by name_student, name_subject
having count(date_attempt)>1
order by 3
; 
-- Студенты могут тестироваться по одной или нескольким дисциплинам (не обязательно по всем). Вывести дисциплину и количество уникальных студентов (столбец назвать Количество), которые по ней проходили тестирование . Информацию отсортировать сначала по убыванию количества, а потом по названию дисциплины. В результат включить и дисциплины, тестирование по которым студенты еще не проходили, в этом случае указать количество студентов 0
select name_subject, count(distinct student_id) Количество
from subject
left join attempt using(subject_id)
group by name_subject
order by 2 desc, 1;
-- Случайным образом отберите 3 вопроса по дисциплине «Основы баз данных». В результат включите столбцы question_id и name_question.
select question_id, name_question
from question
left join subject using(subject_id)
where name_subject='Основы баз данных'
order by rand()
limit 3;
-- Вывести вопросы, которые были включены в тест для Семенова Ивана по дисциплине «Основы SQL» 2020-05-17  (значение attempt_id для этой попытки равно 7). Указать, какой ответ дал студент и правильный он или нет (вывести Верно или Неверно). В результат включить вопрос, ответ и вычисляемый столбец  Результат.
select name_question, name_answer, if(is_correct=1, 'Верно', 'Неверно') Результат
from question
left join subject using(subject_id)
left join testing using(question_id)
left join answer using(answer_id)
where name_subject='Основы SQL' AND ATTEMPT_ID=7;
-- Посчитать результаты тестирования. Результат попытки вычислить как количество правильных ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до двух знаков после запятой. Вывести фамилию студента, название предмета, дату и результат. Последний столбец назвать Результат. Информацию отсортировать сначала по фамилии студента, потом по убыванию даты попытки.
select name_student, name_subject, date_attempt, round(sum(is_correct/3*100),2) Результат
from testing t
join attempt using(attempt_id)
join student using(student_id)
join subject using(subject_id)
join answer a on t.answer_id=a.answer_id
group by name_student, name_subject, date_attempt
order by 1, 3 desc;
-- Для каждого вопроса вывести процент успешных решений, то есть отношение количества верных ответов к общему количеству ответов, значение округлить до 2-х знаков после запятой. Также вывести название предмета, к которому относится вопрос, и общее количество ответов на этот вопрос. В результат включить название дисциплины, вопросы по ней (столбец назвать Вопрос), а также два вычисляемых столбца Всего_ответов и Успешность. Информацию отсортировать сначала по названию дисциплины, потом по убыванию успешности, а потом по тексту вопроса в алфавитном порядке.
-- Поскольку тексты вопросов могут быть длинными, обрезать их 30 символов и добавить многоточие "...".
select name_subject, CONCAT(LEFT(name_question,30),'...') Вопрос, count(is_correct) Всего_ответов, round(sum(is_correct)/count(is_correct)*100,2) Успешность
from question 
LEFT join subject using(subject_id)
left join answer a using(question_id)
right join testing t on t.answer_id=a.answer_id
group by name_subject, Вопрос
order by 1, 4 desc, 2;
-- Найти вопрос, на который было дано максимальное количество правильных ответов - "Самый легкий" и вопрос, на который было дано минимальное количество правильных ответов - "Самый сложный". (исходя из доли верных)
select name_subject, CONCAT(LEFT(name_question,30),'...') Вопрос,  round(sum(is_correct)/count(is_correct)*100,2) Успешность
from question 
LEFT join subject using(subject_id)
left join answer a using(question_id)
right join testing t on t.answer_id=a.answer_id
group by name_subject, Вопрос
order by 3 desc;
--
select name_subject, name_question Вопрос,  round(sum(is_correct)/count(is_correct)*100,2) Успешность
from question 
LEFT join subject using(subject_id)
left join answer a using(question_id)
right join testing t on t.answer_id=a.answer_id
group by name_subject, Вопрос
order by 3 desc;
select name_subject, name_question,  round(sum(is_correct)/count(is_correct)*100,2) Успешность
from question 
LEFT join subject using(subject_id)
left join answer a using(question_id)
right join testing t on t.answer_id=a.answer_id
group by name_subject, name_question
having Успешность=(select max(Успешность)
from
select name_subject, name_question
(
select name_subject, name_question,  round(sum(is_correct)/count(is_correct)*100,2) Успешность
from question 
LEFT join subject using(subject_id)
left join answer a using(question_id)
right join testing t on t.answer_id=a.answer_id
group by name_subject, name_question) t1)
OR
Успешность=
(select min(Успешность)
from
(
select name_subject, name_question,  round(sum(is_correct)/count(is_correct)*100,2) Успешность
from question 
LEFT join subject using(subject_id)
left join answer a using(question_id)
right join testing t on t.answer_id=a.answer_id
group by name_subject, name_question) t2)
;
-- 
select round(sum(is_correct/3*100)) Результат
from testing t
join answer a on t.answer_id=a.answer_id
group by attempt_id
having attempt_id=7;
-- ------------------------------------------------------------------------------------------------------------
-- drop database applicant_stepik;
create database applicant_stepik;
use applicant_stepik;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS subject;
DROP TABLE IF EXISTS program;
DROP TABLE IF EXISTS enrollee;
DROP TABLE IF EXISTS achievement;
DROP TABLE IF EXISTS enrollee_achievement;
DROP TABLE IF EXISTS program_subject;
DROP TABLE IF EXISTS program_enrollee;
DROP TABLE IF EXISTS enrollee_subject;

CREATE TABLE department(
    department_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_department NVARCHAR(30)
);
INSERT INTO department(name_department)
VALUES
    ('Инженерная школа'),
    ('Школа естественных наук');

CREATE TABLE subject(
    subject_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_subject NVARCHAR(30)
);
INSERT INTO subject(name_subject)
VALUES
    ('Русский язык'),
    ('Математика'),
    ('Физика'),
    ('Информатика');

CREATE TABLE program(
    program_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_program NVARCHAR(50),
    department_id INT,
    plan INT,
    FOREIGN KEY department(department_id) REFERENCES department(department_id) ON DELETE CASCADE
);
INSERT INTO program(name_program, department_id, plan)
VALUES
    ('Прикладная математика и информатика', 2, 2),
    ('Математика и компьютерные науки', 2, 1),
    ('Прикладная механика', 1, 2),
    ('Мехатроника и робототехника', 1, 3);

CREATE TABLE enrollee(
    enrollee_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_enrollee NVARCHAR(50)
);
INSERT INTO enrollee(name_enrollee)
VALUES
    ('Баранов Павел'),
    ('Абрамова Катя'),
    ('Семенов Иван'),
    ('Яковлева Галина'),
    ('Попов Илья'),
    ('Степанова Дарья');

CREATE TABLE achievement(
    achievement_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_achievement NVARCHAR(30),
    bonus INT
);
INSERT INTO achievement(name_achievement, bonus)
VALUES
    ('Золотая медаль', 5),
    ('Серебряная медаль', 3),
    ('Золотой значок ГТО', 3),
    ('Серебряный значок ГТО    ', 1);

CREATE TABLE enrollee_achievement(
    enrollee_achiev_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    enrollee_id INT,
    achievement_id INT,
    FOREIGN KEY enrollee(enrollee_id) REFERENCES enrollee(enrollee_id) ON DELETE CASCADE,
    FOREIGN KEY achievement(achievement_id) REFERENCES achievement(achievement_id) ON DELETE CASCADE
);
INSERT INTO enrollee_achievement(enrollee_id, achievement_id)
VALUES
    (1, 2),
    (1, 3),
    (3, 1),
    (4, 4),
    (5, 1),
    (5, 3);

CREATE TABLE program_subject(
    program_subject_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    program_id INT,
    subject_id INT,
    min_result INT,
    FOREIGN KEY program(program_id) REFERENCES program(program_id) ON DELETE CASCADE,
    FOREIGN KEY subject(subject_id) REFERENCES subject(subject_id) ON DELETE CASCADE
);
INSERT INTO program_subject(program_id, subject_id, min_result)
VALUES
    (1, 1, 40),
    (1, 2, 50),
    (1, 4, 60),
    (2, 1, 30),
    (2, 2, 50),
    (2, 4, 60),
    (3, 1, 30),
    (3, 2, 45),
    (3, 3, 45),
    (4, 1, 40),
    (4, 2, 45),
    (4, 3, 45);

CREATE TABLE program_enrollee(
    program_enrollee_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    program_id INT,
    enrollee_id INT,
    FOREIGN KEY program(program_id) REFERENCES program(program_id) ON DELETE CASCADE,
    FOREIGN KEY enrollee(enrollee_id) REFERENCES enrollee(enrollee_id) ON DELETE CASCADE
);
INSERT INTO program_enrollee(program_id, enrollee_id)
VALUES
    (3, 1),
    (4, 1),
    (1, 1),
    (2, 2),
    (1, 2),
    (1, 3),
    (2, 3),
    (4, 3),
    (3, 4),
    (3, 5),
    (4, 5),
    (2, 6),
    (3, 6),
    (4, 6);

CREATE TABLE enrollee_subject(
    enrollee_subject_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    enrollee_id INT,
    subject_id INT,
    result INT,
    FOREIGN KEY enrollee(enrollee_id) REFERENCES enrollee(enrollee_id) ON DELETE CASCADE,
    FOREIGN KEY subject(subject_id) REFERENCES subject(subject_id) ON DELETE CASCADE
);
INSERT INTO enrollee_subject(enrollee_id, subject_id, result)
VALUES
    (1, 1, 68),
    (1, 2, 70),
    (1, 3, 41),
    (1, 4, 75),
    (2, 1, 75),
    (2, 2, 70),
    (2, 4, 81),
    (3, 1, 85),
    (3, 2, 67),
    (3, 3, 90),
    (3, 4, 78),
    (4, 1, 82),
    (4, 2, 86),
    (4, 3, 70),
    (5, 1, 65),
    (5, 2, 67),
    (5, 3, 60),
    (6, 1, 90),
    (6, 2, 92),
    (6, 3, 88),
    (6, 4, 94);
--  ---------------------------------------------------------------------
-- Вывести абитуриентов, которые хотят поступать на образовательную программу «Мехатроника и робототехника» в отсортированном по фамилиям виде.
SELECT name_enrollee
FROM ENROLLEE
LEFT JOIN PROGRAM_ENROLLEE USING(ENROLLEE_ID)
LEFT JOIN PROGRAM USING(PROGRAM_ID)
WHERE NAME_PROGRAM='Мехатроника и робототехника';
-- Вывести образовательные программы, на которые для поступления необходим предмет «Информатика». Программы отсортировать в обратном алфавитном порядке.
select name_program
from program
left join program_subject using(program_id)
left join subject using(subject_id)
where name_subject='Информатика'
order by name_program desc;
-- Выведите количество абитуриентов, сдавших ЕГЭ по каждому предмету, максимальное, минимальное и среднее значение баллов по предмету ЕГЭ. Вычисляемые столбцы назвать Количество, Максимум, Минимум, Среднее. Информацию отсортировать по названию предмета в алфавитном порядке, среднее значение округлить до одного знака после запятой.
select name_subject, count(enrollee_id) Количество, max(result) Максимум, min(result) Минимум,
round(avg(result), 1) Среднее
from enrollee_subject
left join subject using(subject_id)
group by name_subject
order by 1;
-- Вывести образовательные программы, для которых минимальный балл ЕГЭ по каждому предмету больше или равен 40 баллам. Программы вывести в отсортированном по алфавиту виде
select name_program
from program_subject 
left join program using(program_id)
where min_result>=40
group by name_program
having count(*)=3
order by 1;
-- Вывести образовательные программы, которые имеют самый большой план набора,  вместе с этой величиной.
select name_program, plan
from program
where plan=(select max(plan) from program);
-- Посчитать, сколько дополнительных баллов получит каждый абитуриент. Столбец с дополнительными баллами назвать Бонус. Информацию вывести в отсортированном по фамилиям виде.
select name_enrollee, sum(coalesce(bonus,0)) Бонус
from enrollee
left join enrollee_achievement using(enrollee_id)
left join achievement using(achievement_id)
group by name_enrollee
order by 1;
-- Выведите сколько человек подало заявление на каждую образовательную программу и конкурс на нее (число поданных заявлений деленное на количество мест по плану), округленный до 2-х знаков после запятой. В запросе вывести название факультета, к которому относится образовательная программа, название образовательной программы, план набора абитуриентов на образовательную программу (plan), количество поданных заявлений (Количество) и Конкурс. Информацию отсортировать в порядке убывания конкурса.
select name_department, name_program, plan, count(enrollee_id) Количество, round(count(enrollee_id)/plan, 2) Конкурс
from program_enrollee
left join program using(program_id)
left join department using(department_id)
group by name_department, name_program, plan
order by 5 desc
;
select *
from program_enrollee
left join program using(program_id)
left join department using(department_id);
-- Вывести образовательные программы, на которые для поступления необходимы предмет «Информатика» и «Математика» в отсортированном по названию программ виде.
select name_program
from program
left join program_subject using(program_id)
left join subject using(subject_id)
group by name_program
having sum(if(name_subject='Информатика', 1, 0)) + sum(if(name_subject='Математика', 1, 0))=2
order by 1;
-- Посчитать количество баллов каждого абитуриента на каждую образовательную программу, на которую он подал заявление, по результатам ЕГЭ. В результат включить название образовательной программы, фамилию и имя абитуриента, а также столбец с суммой баллов, который назвать itog. Информацию вывести в отсортированном сначала по образовательной программе, а потом по убыванию суммы баллов виде.
select name_program, name_enrollee, sum(result) itog
from enrollee
left join program_enrollee using(enrollee_id) 
left join program using(program_id)
left join program_subject ps using(program_id)
left join enrollee_subject es on es.enrollee_id=enrollee.enrollee_id and es.subject_id=ps.subject_id
group by name_program, name_enrollee
order by 1, 3 desc;
-- Вывести название образовательной программы и фамилию тех абитуриентов, которые подавали документы на эту образовательную программу, но не могут быть зачислены на нее. Эти абитуриенты имеют результат по одному или нескольким предметам ЕГЭ, необходимым для поступления на эту образовательную программу, меньше минимального балла. Информацию вывести в отсортированном сначала по программам, а потом по фамилиям абитуриентов виде.
-- Например, Баранов Павел по «Физике» набрал 41 балл, а  для образовательной программы «Прикладная механика» минимальный балл по этому предмету определен в 45 баллов. Следовательно, абитуриент на данную программу не может поступить.
INSERT INTO enrollee_subject (enrollee_id, subject_id, result) VALUES (2, 3, 41);

select name_program, name_enrollee
from enrollee
left join program_enrollee using(enrollee_id) 
left join program using(program_id)
left join program_subject ps using(program_id)
left join enrollee_subject es on es.enrollee_id=enrollee.enrollee_id and es.subject_id=ps.subject_id
group by name_program, name_enrollee
having sum(if(min_result>result, 1, 0))>0
order by 1,2;
-- program_id | enrollee_id | itog 
select program_id,enrollee.enrollee_id, sum(result) itog
from enrollee
left join program_enrollee using(enrollee_id) 
left join program using(program_id)
left join program_subject ps using(program_id)
left join enrollee_subject es on es.enrollee_id=enrollee.enrollee_id and es.subject_id=ps.subject_id
group by enrollee.enrollee_id, program_id
order by 1, 3 desc
;
-- Из таблицы applicant, созданной на предыдущем шаге, удалить записи, если абитуриент на выбранную образовательную программу не набрал минимального балла хотя бы по одному предмету (использовать запрос из предыдущего урока)
select program_id, enrollee.enrollee_id
from enrollee
left join program_enrollee using(enrollee_id) 
left join program using(program_id)
left join program_subject ps using(program_id)
left join enrollee_subject es on es.enrollee_id=enrollee.enrollee_id and es.subject_id=ps.subject_id
where ps.min_result>result;
-- Повысить итоговые баллы абитуриентов в таблице applicant на значения дополнительных баллов (использовать запрос из предыдущего урока).
select enrollee_id, sum(coalesce(bonus,0)) Бонус
from enrollee
left join enrollee_achievement using(enrollee_id)
left join achievement using(achievement_id)
group by enrollee_id
order by 1;
-- Вывести имена студентов и названия программ, на которые они НЕ подавали документы.
select name_enrollee, name_program
from enrollee
cross join (select program_id, name_program from program) x
left outer join program_enrollee pe on x.program_id=pe.program_id and enrollee.enrollee_id=pe.enrollee_id
where pe.program_id is null
;
-- 
CREATE DATABASE stepik_analytics;
USE stepik_analytics;
CREATE TABLE module
(
    module_id   INT PRIMARY KEY AUTO_INCREMENT,
    module_name NVARCHAR(64)
);

INSERT INTO module (module_name)
VALUES ('Основы реляционной модели и SQL'),
       ('Запросы SQL к связанным таблицам');

CREATE TABLE lesson
(
    lesson_id       INT PRIMARY KEY AUTO_INCREMENT,
    lesson_name     NVARCHAR(50),
    module_id       INT,
    lesson_position INT,
    FOREIGN KEY (module_id) REFERENCES module (module_id) ON DELETE CASCADE
);

INSERT INTO lesson(lesson_name, module_id, lesson_position)
VALUES ('Отношение(таблица)', 1, 1),
       ('Выборка данных', 1, 2),
       ('Таблица "Командировки", запросы на выборку', 1, 6),
       ('Вложенные запросы', 1, 4);

CREATE TABLE step
(
    step_id       INT PRIMARY KEY AUTO_INCREMENT,
    step_name     NVARCHAR(256),
    step_type     VARCHAR(16),
    lesson_id     INT,
    step_position INT,
    FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id) ON DELETE CASCADE
);

INSERT INTO step(step_name, step_type, lesson_id, step_position)
VALUES ('Структура уроков курса', 'text', 1, 1),
       ('Содержание урока', 'text', 1, 2),
       ('Реляционная модель, основные положения', 'table', 1, 3),
       ('Отношение, реляционная модель', 'choice', 1, 4);

CREATE TABLE keyword
(
    keyword_id   INT PRIMARY KEY AUTO_INCREMENT,
    keyword_name VARCHAR(16)
);

INSERT INTO keyword(keyword_name)
VALUES ('SELECT'),
       ('FROM');

CREATE TABLE step_keyword
(
    step_id    INT,
    keyword_id INT,
    PRIMARY KEY (step_id, keyword_id),
    FOREIGN KEY (step_id) REFERENCES step (step_id) ON DELETE CASCADE,
    FOREIGN KEY (keyword_id) REFERENCES keyword (keyword_id) ON DELETE CASCADE
);

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO step_keyword (step_id, keyword_id) VALUE (38, 1);
INSERT INTO step_keyword (step_id, keyword_id) VALUE (81, 3);

CREATE TABLE student
(
    student_id   INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(64)
);

INSERT INTO student(student_name)
VALUES ('student_1'),
       ('student_2');

CREATE TABLE step_student
(
    step_student_id INT PRIMARY KEY AUTO_INCREMENT,
    step_id         INT,
    student_id      INT,
    attempt_time    INT,
    submission_time INT,
    result          VARCHAR(16),
    FOREIGN KEY (student_id) REFERENCES student (student_id) ON DELETE CASCADE,
    FOREIGN KEY (step_id) REFERENCES step (step_id) ON DELETE CASCADE
);

INSERT INTO step_student (step_id, student_id, attempt_time, submission_time, result)
VALUES (10, 52, 1598291444, 1598291490, 'correct'),
       (10, 11, 1593291995, 1593292031, 'correct'),
       (10, 19, 1591017571, 1591017743, 'wrong'),
       (10, 4, 1590254781, 1590254800, 'correct');

/*включаем проверку*/
SET FOREIGN_KEY_CHECKS = 1;
--  Отобрать все шаги, в которых рассматриваются вложенные запросы (то есть в названии шага упоминаются вложенные запросы). Указать к какому уроку и модулю они относятся. Для этого вывести 3 поля:
-- в поле Модуль указать номер модуля и его название через пробел;
-- в поле Урок указать номер модуля, порядковый номер урока (lesson_position) через точку и название урока через пробел;
-- в поле Шаг указать номер модуля, порядковый номер урока (lesson_position) через точку, порядковый номер шага (step_position) через точку и название шага через пробел.
-- Длину полей Модуль и Урок ограничить 19 символами, при этом слишком длинные надписи обозначить многоточием в конце (16 символов - это номер модуля или урока, пробел и  название Урока или Модуля,к ним присоединить "..."). Информацию отсортировать по возрастанию номеров модулей, порядковых номеров уроков и порядковых номеров шагов.
select IF(CHAR_LENGTH(concat(module_id, ' ', module_name))>19, CONCAT(LEFT(concat(module_id, ' ', module_name),16), '...'), concat(module_id, ' ', module_name)) Модуль,
IF(CHAR_LENGTH(concat(module_id, '.',lesson_position,' ', lesson_name))>19, CONCAT(LEFT(concat(module_id, '.',lesson_position,' ', lesson_name),16), '...'), concat(module_id, '.',lesson_position,' ', lesson_name)) Урок, 
concat(module_id, '.',lesson_position, '.', step_position, ' ', step_name) Шаг
from step
left join lesson using(lesson_id)
left join module using(module_id)
-- where lower(step_name) like '%вложенн%_запрос%'
order by 1,2,3
;
select * from step;
-- Заполнить таблицу step_keyword следующим образом: если ключевое слово есть в названии шага, то включить в step_keyword строку с id шага и id ключевого слова. 

select step_id, keyword_id 
from step
cross join keyword
where REGEXP_INSTR(lower(step_name), concat('\\b',lower(keyword_name), '\\b'))!=0
order by 2;
;

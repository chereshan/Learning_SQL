/*1. Создать таблицу с выручкой по трекам
2. Какой покупатель сделал больше всего покупок/на большую сумму
3. Из какой страны пришло больше выручки
4. В какой месяц было продано больше всего треков
5. Какой менеджер продаж работал эффективнее всего
6. Обновить все цены на 1,99 */

/*1. Создать таблицу с выручкой по трекам*/
SELECT name, sum(il.Quantity*il.UnitPrice) as revenue
FROM InvoiceLine il 
left join Track 
On il.TrackId =Track.TrackId 
Group by il.TrackId 
ORDER by revenue DESC;


/*2. Какой покупатель сделал 
больше всего покупок/на большую сумму*/

SELECT C.FirstName,
C.LastName,
C.CustomerId,
SUM(il.Quantity*il.UnitPrice) as tot,
count(i.InvoiceId) as qty,
sum(i.Total)
FROM Customer C
LEFT JOIN Invoice i
ON C.CustomerId=i.CustomerId 
LEFT JOIN InvoiceLine il 
ON i.InvoiceId =il.InvoiceId
GROUP by i.CustomerId
order by qty DESC ;

--правильное решение
SELECT FirstName, LastName, 
SUM(Total) as TR, COUNT(i.InvoiceId) as qty  
FROM Invoice i   
left join Customer c  
on i.CustomerId =  c.CustomerId  
group by  i.CustomerId 
order by qty  DESC;

/*3. Из какой страны пришло больше выручки*/
select C.Country,SUM(il.Quantity*il.UnitPrice) as revenue
from Customer C
LEFT JOIN Invoice i
ON C.CustomerId=i.CustomerId 
--GROUP by C.LastName;
LEFT JOIN InvoiceLine il 
ON i.InvoiceId =il.InvoiceId
GROUP by C.Country
ORDER by revenue DESC;

/*4. В какой месяц было продано 
 больше всего треков*/
SELECT strftime('%m', i.InvoiceDate) AS month1,
sum(il.Quantity) as tot
FROM Invoice i
LEFT JOIN InvoiceLine il 
ON i.InvoiceId =il.InvoiceId
GROUP BY month1
ORDER by tot DESC;

--Проверка
SELECT strftime('%m', i.InvoiceDate) AS month1, sum(il.Quantity) as tot
FROM Invoice i
LEFT JOIN InvoiceLine il 
ON i.InvoiceId =il.InvoiceId
where month1 = '10'


/*5. Какой менеджер продаж работал
  эффективнее всего*/
/*Почему-то в БД только 1 менеджер по продажам?*/
--C.SupportReplId - номер менеджера

--МОЕ РЕШЕНИЕ
select e.EmployeeId, sum(i.Total) as tot, e.FirstName ,e.LastName 
from Employee3 e 
left join Customer c
on c.SupportRepId=e.EmployeeId 
left join Invoice i 
on i.CustomerId=c.CustomerId
group by e.EmployeeId
ORDER by tot DESC;

--РЕШЕНИЕ САШИ ТКАЧЕНКО
SELECT sum(i.Total) as tot, e.LastName ,e.FirstName 
FROM Invoice i
left join Customer c on i.CustomerId =c.CustomerId 
LEFT JOIN Employee3 e  
ON  c.SupportRepId = e.EmployeeId 
group by c.SupportRepId 
order by tot;



/*6. Обновить все цены на 1,99 */
UPDATE Track 
set UnitPrice=1.99
where UnitPrice>5

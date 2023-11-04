USE CHINOOK;
-- 1. Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
select CustomerId, concat(FirstName, ' ', LastName) fullname, Country
from customer
where Country!='USA';
-- 2. Provide a query only showing the Customers from Brazil.
select *
from customer
where Country='Brazil';
-- 3. Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer’s full name, Invoice ID, Date of the invoice and billing country.
select concat(c.FirstName, ' ', c.LastName) fullname,i.InvoiceId, i.InvoiceDate, i.BillingCountry
from invoice i
left join customer c on c.CustomerId=i.CustomerId
where c.Country='Brazil';
-- 4. Provide a query showing only the Employees who are Sales Agents.
select *
from employee
where title='Sales Support Agent';
-- 5. Provide a query showing a unique list of billing countries from the Invoice table.
select distinct BillingCountry
from invoice;
-- 6. Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent’s full name.
select concat(e.FirstName, ' ', e.LastName) agents_fullname, i.*
from customer c
join employee e on c.SupportRepId=e.EmployeeId
join invoice i on i.CustomerId=c.CustomerId;
-- 7. Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
select i.Total, concat(c.FirstName, ' ', c.LastName) customer_name, c.Country,
 concat(e.FirstName, ' ', e.LastName) agent_name
from invoice i
left join customer c on c.CustomerId=i.CustomerId
left join employee e on e.EmployeeId=c.SupportRepId;
-- 8. How many Invoices were there in 2009 and 2011? What are the respective total sales for each of those years?
select year(InvoiceDate) year, sum(i.Total), count(*)
from invoice i
group by year
having year=2009 or year=2011;
-- 9. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
select count(*)
from invoiceline
where InvoiceId=37;
-- 10. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
select InvoiceId, count(*)
from invoiceline
group by InvoiceId;
select *
from invoiceline;
-- Use the Chinook Database and the DB Browser for your Database Server For each of the following exercises, provide the appropriate query (or some queries). Obviously provide results for each query! Keep your successful queries in a task3.sql file with comments.
-- 1. Provide a query that includes the track name with each invoice line item.
select t.Name, il.*
from invoiceline il
join track t on t.TrackId=il.TrackId;
-- 2. Provide a query that includes the purchased track name AND artist name with each invoice line item.
select t.Name trackname,art.name artist_name, il.*
from invoiceline il
join track t on t.TrackId=il.TrackId
join album a on a.albumid=t.AlbumId
join artist art on art.ArtistId=a.ArtistId;
-- 3. Provide a query that shows the # of invoices per country. HINT: GROUP BY
select billingcountry, count(*)
from invoice
group by billingcountry;
-- 4. Provide a query that shows the total number of tracks in each playlist. The Playlist name should be included on the resultant table.
select *
from playlist;
select pt.PlaylistId, p.Name, count(*)
from playlisttrack pt
join playlist p on p.PlaylistId=pt.PlaylistId
group by PlaylistId;
-- 5. Provide a query that shows all the Tracks, but displays no IDs. The resultant table should include the Album name, Media type and Genre.
select t.Name trackname, a.Title albumname,m.name mediatypename, g.Name genrename
from track t
join album a on a.AlbumId=t.AlbumId
join artist art on art.ArtistId=a.ArtistId
join genre g on g.GenreId=t.GenreId
join mediatype m on m.MediaTypeId=t.MediaTypeId;
-- 6. Provide a query that shows all Invoices but includes the # of invoice line items.
select i.*,count(*)
from invoice i
join invoiceline il on il.InvoiceId=i.InvoiceId
group by i.InvoiceId;
-- 7. Provide a query that shows total sales made by each sales agent.
select concat(e.firstname,' ', e.lastname) agent_name, sum(i.Total)
from invoice i
join customer c on c.CustomerId=i.CustomerId
join employee e on e.EmployeeId=c.SupportRepId
group by agent_name;
-- 8. Which sales agent made the most in sales in 2009?
select concat(e.firstname,' ', e.lastname) agent_name, sum(i.Total) totalsum
from invoice i
join customer c on c.CustomerId=i.CustomerId
join employee e on e.EmployeeId=c.SupportRepId
where year(i.invoicedate)=2009
group by agent_name
order by totalsum desc
limit 1;
-- 9. Which sales agent made the most in sales in 2010?
select concat(e.firstname,' ', e.lastname) agent_name, sum(i.Total) totalsum
from invoice i
join customer c on c.CustomerId=i.CustomerId
join employee e on e.EmployeeId=c.SupportRepId
where year(i.invoicedate)=2010
group by agent_name
order by totalsum desc
limit 1;
-- 10. Which sales agent made the most in sales over all?
select concat(e.firstname,' ', e.lastname) agent_name, sum(i.Total) totalsum
from invoice i
join customer c on c.CustomerId=i.CustomerId
join employee e on e.EmployeeId=c.SupportRepId
group by agent_name
order by totalsum desc
limit 1;
-- Use the Chinook Database and the DB Browser for your Database Server For each of the following exercises, provide the appropriate query (or some queries). Obviously provide results for each query! Keep your successful queries in a task4.sql file with comments
-- 1. Provide a query that shows the # of customers assigned to each sales agent.
select concat(e.firstname,' ', e.lastname) agent_name, count(distinct c.CustomerId)
from employee e
join customer c on e.EmployeeId=c.SupportRepId
group by e.EmployeeId;
-- 2. Provide a query that shows the total sales per country.
select i.BillingCountry, sum(i.total)
from invoice i
group by i.BillingCountry
order by 2 desc;
-- 3. Which country’s customers spent the most?
select c.Country, sum(i.total) sumtotal
from invoice i
join customer c on c.CustomerId=i.CustomerId
group by c.Country
order by sumtotal desc;
-- 4. Provide a query that shows the most purchased track of 2013.
select t.name, count(*)
from invoice i
join invoiceline il on il.InvoiceId=i.InvoiceId
join track t on t.TrackId=il.TrackId
where year(i.invoicedate)=2013
group by t.name
order by 2 desc
limit 1;
-- 5. Provide a query that shows the top 5 most purchased tracks over all.
select t.name, count(*)
from invoice i
join invoiceline il on il.InvoiceId=i.InvoiceId
join track t on t.TrackId=il.TrackId
group by t.name
order by 2 desc
limit 5;
-- 6. Provide a query that shows the top 3 best selling artists.
select art.name artist_name, count(*), sum(i.total) sumtot
from invoice i
join invoiceline il on il.InvoiceId=i.InvoiceId
join track t on t.TrackId=il.TrackId
join album a on a.AlbumId=t.AlbumId
join artist art on art.ArtistId=a.ArtistId
group by art.name
order by sumtot desc
limit 3;
-- 7. Provide a query that shows the most purchased Media Type.
select m.name, sum(i.total) sumt, count(*)
from invoice i
left join invoiceline il on il.InvoiceId=i.InvoiceId
left join track t on t.TrackId=il.TrackId
left join mediatype m on m.MediaTypeId=t.MediaTypeId
group by m.MediaTypeId
limit 1;
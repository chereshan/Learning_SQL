/* **Task # 1: Prerequisites**

1. Download Chinook Database script for yours DBMS. Use this [link](https://github.com/lerocha/chinook-database) for Chinook repository
2. Install it
3. Build an ERD
4. Write report with info about tables (names and types of columns and number of rows in each) */

/* **Task # 2: Query Practice (part 1)**

Use the Chinook Database and the DB Browser for your Database Server
For each of the following exercises, provide the appropriate query (or some queries).
Obviously provide results for each query!
Keep your successful queries in a task2.sql file with comments.*/

/*1. Provide a query showing Customers (just their full names, customer ID and country) who are
not in the US.*/
SELECT c.FirstName, c.LastName, c.CustomerId ,c.Country
FROM Customer c 
where c.Country!='USA';

/*2. Provide a query only showing the Customers from Brazil.*/
SELECT *
FROM Customer c 
where c.Country='Brazil';

/*3. Provide a query showing the Invoices of customers who are from Brazil. The resultant table
should show the customer’s full name, Invoice ID, Date of the invoice and billing country.*/
select c.FirstName, c.LastName, i.InvoiceId, i.InvoiceDate, i.BillingCountry 
from Customer c 
left join Invoice i 
on c.CustomerId=i.CustomerId;

/*4. Provide a query showing only the Employees who are Sales Agents.*/
select *
from Employee3 e
where e.Title='Sales Support Agent';

/*5. Provide a query showing a unique list of billing countries from the Invoice table.*/
select DISTINCT i.BillingCountry 
from Invoice i;

/*6. Provide a query that shows the invoices associated with each sales agent. The resultant table
should include the Sales Agent’s full name.
??????????????????????????????????????????????????????*/
select e.FirstName, e.LastName, i.InvoiceId 
from Employee3 e 
left join Invoice i
where e.Title='Sales Support Agent';


/*7. Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for
all invoices and customers.
?????????????????????????????????*/

select i.Total, c.FirstName ,c.LastName c.Country ,e.FirstName , e.LastName 
from Invoice i 
left join Customer c  
on c.CustomerId=i.CustomerId 
left join Employee3 e  
on e.EmployeeId =c.SupportRepId;


/*8. How many Invoices were there in 2009 and 2011? What are the respective total sales for each of
those years?
9. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for
Invoice ID 37.
10. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for
each Invoice. HINT: GROUP BY*/

/* **Task # 3: Query Practice (part 2)**

Use the Chinook Database and the DB Browser for your Database Server
For each of the following exercises, provide the appropriate query (or some queries).
Obviously provide results for each query!
Keep your successful queries in a task3.sql file with comments.
1. Provide a query that includes the track name with each invoice line item.
2. Provide a query that includes the purchased track name AND artist name with each invoice line
item.
3. Provide a query that shows the # of invoices per country. HINT: GROUP BY
4. Provide a query that shows the total number of tracks in each playlist. The Playlist name should
be included on the resultant table.
5. Provide a query that shows all the Tracks, but displays no IDs. The resultant table should
include the Album name, Media type and Genre.
6. Provide a query that shows all Invoices but includes the # of invoice line items.
7. Provide a query that shows total sales made by each sales agent.
8. Which sales agent made the most in sales in 2009?
9. Which sales agent made the most in sales in 2010?
10. Which sales agent made the most in sales over all?*/

/* **Task # 4: Query Practice (part 3)**

Use the Chinook Database and the DB Browser for your Database Server
For each of the following exercises, provide the appropriate query (or some queries).
Obviously provide results for each query!
Keep your successful queries in a task4.sql file with comments.
1. Provide a query that shows the # of customers assigned to each sales agent.
2. Provide a query that shows the total sales per country.
3. Which country’s customers spent the most?
4. Provide a query that shows the most purchased track of 2013.
5. Provide a query that shows the top 5 most purchased tracks over all.
6. Provide a query that shows the top 3 best selling artists.
7. Provide a query that shows the most purchased Media Type.
*/

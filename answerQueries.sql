/* Q1: Who is the senior most employee based on job title? */

select title, last_name, first_name 
from employee
order by levels desc
limit 1


/* Q2: Which countries have the most Invoices? */

select count(*) as c, billing_country 
from invoice
group by billing_country
order by c desc


/* Q3: What are top 3 values of total invoice? */

select total 
from invoice
order by total desc


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made
the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the 
city name & sum of all invoice totals */

select billing_city,sum(total) as InvoiceTotal
from invoice
group by billing_city
order by InvoiceTotal desc
limit 1;


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select customer.customer_id, first_name, last_name, sum(total) as total_spending
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total_spending desc
limit 1;

/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select distinct email as Email,first_name as FirstName, last_name as LastName, genre.name as Name
from customer
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
where genre.name = 'Rock'
order by email;


/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.artist_id, artist.name,count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;


/* Q8: Return all the track names that have a song length longer than the average song length. Return the Name and 
Milliseconds for each track. order by the song length with the longest songs listed first. */

select name,milliseconds
from track
where milliseconds > (
	select AVG(milliseconds) as avg_track_length
	from track )
order by milliseconds desc;


/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name
and total spent */
--- using CTE method ---

with best_selling_artist as(
	select artist.artist_id , artist.name as artist_name , sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
	join track on track.track_id = invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by 1
	order by 3 desc
	limit 1
)
select customer.customer_id , customer.first_name , customer.last_name , best_selling_artist.artist_name , 
	sum(invoice_line.unit_price*invoice_line.quantity) as total_spent
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join best_selling_artist on album.artist_id = best_selling_artist.artist_id
group by 1,2,3,4
order by 5 desc






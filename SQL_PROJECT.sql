1. WHO IS THE SENIOR MOST EMPLOYEE BASED ON JOB TITLE?

SELECT * FROM EMPLOYEE
ORDER BY LEVELS DESC
LIMIT 1;

2. Which countries have the most Invoices?

SELECT COUNT(*) AS C,BILLING_COUNTRY FROM INVOICE
GROUP BY BILLING_COUNTRY
ORDER BY C DESC;

3. What are top 3 values of total invoice?

SELECT TOTAL FROM INVOICE
ORDER BY TOTAL DESC 
LIMIT 3;

4. Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals


SELECT SUM(TOTAL) AS INVOICE_TOTAL,
BILLING_CITY FROM INVOICE
GROUP BY BILLING_CITY
ORDER BY  INVOICE_TOTAL DESC;


5. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money

SELECT C.CUSTOMER_ID,C.FIRST_NAME,C.LAST_NAME,SUM(I.TOTAL) AS TOTAL_MONEY_SPENT FROM CUSTOMER C
JOIN INVOICE  I ON
C.CUSTOMER_ID=I.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY TOTAL_MONEY_SPENT DESC
LIMIT 1;


--(6.Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A)--



SELECT distinct EMAIL,FIRST_NAME,LAST_NAME
FROM CUSTOMER C
JOIN INVOICE I ON C.CUSTOMER_ID=I.CUSTOMER_ID
JOIN INVOICE_LINE L  ON I.INVOICE_ID=L.INVOICE_ID
WHERE  TRACK_ID IN(
SELECT TRACK_ID FROM TRACK 
JOIN GENRE ON TRACK.GENRE_ID=GENRE.GENRE_ID
WHERE GENRE.NAME LIKE 'Rock'
)
ORDER BY EMAIL;

--7.(Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands)



SELECT AR.ARTIST_ID,AR.NAME,COUNT(AR.ARTIST_ID) AS NUMBER_OF_SONGS
FROM TRACK T
JOIN ALBUM A ON A.ALBUM_ID=T.ALBUM_ID
JOIN ARTIST AR ON AR.ARTIST_ID=A.ARTIST_ID
JOIN GENRE G ON G.GENRE_ID=T.GENRE_ID
WHERE G.NAME LIKE 'Rock'
GROUP BY AR.ARTIST_ID
ORDER BY NUMBER_OF_SONGS DESC
LIMIT 10;


--8. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first

SELECT NAME,MILLISECONDS
FROM TRACK 
WHERE MILLISECONDS> (SELECT AVG(MILLISECONDS) AS AVG_SONG_LENGTH
					 FROM TRACK)
					ORDER BY MILLISECONDS DESC;
					
					
					
					
					
					
---9.Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent


with best_selling_artist as(
select a.artist_id ,a.name,
sum(il.unit_price*il.quantity) as total_sales
	from invoice_line il
	join track t on t.track_id=il.track_id
	join album ab on ab.album_id=t.album_id
	join artist a on a.artist_id=ab.artist_id
	group by 1
	order by 3 desc
	limit 1
	)
	select c.customer_id,c.first_name,c.last_name,bsa.name as artist_name,
	sum(il.unit_price*il.quantity) as total_sales
	from invoice i
	join customer c on c.customer_id=i.customer_id
	join invoice_line il on il.invoice_id=i.invoice_id
	join track t on t.track_id= il.track_id
	join album ab on ab.album_id=t.album_id
	join best_selling_artist  bsa on bsa.artist_id=ab.artist_id
	group by 1,2,3,4
	order by 5 desc;
	
	
	
--10. We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres



  with popular_genre as 
  (
  select count(il.quantity) as purchases, c.country,g.name,g.genre_id,
	  row_number() over(partition by c.country order by count(il.quantity) desc) as RowNo
	  from invoice_line il
	  join invoice i on i.invoice_id=il.invoice_id
	  join customer c on c.customer_id=i.customer_id
	  join track t on t.track_id=il.track_id
	  join genre g on g.genre_id=t.genre_id
	  group by 2,3,4
	  order by 2 asc,1 desc
	  )
	 select * from popular_genre
	 where RowNo <=1;
	 
	 
	 
---11. Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all 
customers who spent this amount
	
	with customer_with_country as(
	select c.customer_id,first_name,last_name,billing_country,
	sum(total) as total_spending,
	row_number() over (partition by billing_country order by sum(total) desc) as RowNo
		from invoice i
		join customer c on c.customer_id=i.customer_id
		group by 1,2,3,4
		order by 4 asc,5 desc
	)
		select * from customer_with_country
		where RowNo <=1;
	
	
	










					
					

































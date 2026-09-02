USE music_store;

-- Q1. Who is the senior-most employee based on job title?
SELECT *
FROM employee
ORDER BY levels DESC
LIMIT 1;

-- Q2. Which countries have the most Invoices?

SELECT billing_country,
       COUNT(invoice_id) AS invoice_count
FROM invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;

-- Q3. What are top 3 values of total invoice?

SELECT *
FROM invoice
ORDER BY total DESC
LIMIT 3;

-- Q4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
--     Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.

SELECT billing_city,
       SUM(total) AS invoice_total
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC
LIMIT 1;

-- Q5. Who is the best customer? The customer who has spent the most money will be declared the best customer. 
--     Write a query that returns the person who has spent the most money.

SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 1;

-- Q6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A 

SELECT DISTINCT
    c.email,
    c.first_name,
    c.last_name
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
JOIN invoice_line il
    ON i.invoice_id = il.invoice_id
JOIN track t
    ON il.track_id = t.track_id
JOIN genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email;

-- Q7. Let's invite the artists who have written the most rock music in our dataset. 
--     Write a query that returns the Artist name and total track count of the top 10 rock bands.

SELECT
    ar.artist_id,
    ar.name AS artist_name,
    COUNT(t.track_id) AS num_of_songs
FROM artist ar
JOIN album a
    ON a.artist_id = ar.artist_id
JOIN track t
    ON t.album_id = a.album_id
JOIN genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.artist_id, ar.name
ORDER BY num_of_songs DESC
LIMIT 10;

-- Q8. Return all the track names that have a song length longer than the average song length. 
--     Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

SELECT name, milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds)
    FROM track
)
ORDER BY milliseconds DESC;

-- Q9. Find how much amount spent by each customer on artists. Write a query to return the customer name, artist name, and total spent.

WITH best_selling_artist AS (
    SELECT
        ar.artist_id,
        ar.name AS artist_name,
        SUM(il.unit_price * il.quantity) AS total_spent
    FROM invoice_line il
    JOIN track t
        ON t.track_id = il.track_id
    JOIN album al
        ON al.album_id = t.album_id
    JOIN artist ar
        ON ar.artist_id = al.artist_id
    GROUP BY ar.artist_id, ar.name
)
SELECT
    c.customer_id,
    c.first_name AS name,
    bsa.artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM invoice i
JOIN customer c
    ON c.customer_id = i.customer_id
JOIN invoice_line il
    ON il.invoice_id = i.invoice_id
JOIN track t
    ON t.track_id = il.track_id
JOIN album al
    ON al.album_id = t.album_id
JOIN best_selling_artist bsa
    ON bsa.artist_id = al.artist_id
GROUP BY
    c.customer_id,
    c.first_name,
    bsa.artist_name
ORDER BY total_spent DESC;

-- Q10. We want to find out the most popular music Genre for each country. 
--      We determine the most popular genre as the genre with the highest amount of purchases. 
--      Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres.

WITH popular_genre AS (
    SELECT
        c.country,
        g.name AS genre_name,
        COUNT(il.quantity) AS purchases,
        RANK() OVER (
            PARTITION BY c.country
            ORDER BY COUNT(il.quantity) DESC
        ) AS rank_num
    FROM invoice_line il
    JOIN invoice i
        ON i.invoice_id = il.invoice_id
    JOIN customer c
        ON c.customer_id = i.customer_id
    JOIN track t
        ON t.track_id = il.track_id
    JOIN genre g
        ON g.genre_id = t.genre_id
    GROUP BY c.country, g.name
)
SELECT
    country,
    genre_name,
    purchases
FROM popular_genre
WHERE rank_num = 1;

-- Q11. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.

WITH customer_with_country AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        i.billing_country,
        SUM(i.total) AS total_spent,
        RANK() OVER (
            PARTITION BY i.billing_country
            ORDER BY SUM(i.total) DESC
        ) AS rank_num
    FROM invoice i
    JOIN customer c
        ON c.customer_id = i.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        i.billing_country
)
SELECT
    customer_id,
    first_name,
    last_name,
    billing_country,
    total_spent
FROM customer_with_country
WHERE rank_num = 1;

-- Q12. Who are the most popular artists?

SELECT
    ar.artist_id,
    ar.name AS artist_name,
    SUM(il.quantity) AS purchases
FROM invoice_line il
JOIN track t
    ON t.track_id = il.track_id
JOIN album al
    ON al.album_id = t.album_id
JOIN artist ar
    ON ar.artist_id = al.artist_id
GROUP BY ar.artist_id, ar.name
ORDER BY purchases DESC;

-- Q13. Which is the most popular song?

SELECT
    t.track_id,
    t.name AS song_name,
    SUM(il.quantity) AS purchases
FROM invoice_line il
JOIN track t
    ON t.track_id = il.track_id
GROUP BY t.track_id, t.name
ORDER BY purchases DESC;

-- Q14. What are the average prices of different types of music?

SELECT
    g.name AS genre,
    ROUND(AVG(t.unit_price), 2) AS average_price
FROM track t
JOIN genre g
    ON g.genre_id = t.genre_id
GROUP BY g.genre_id, g.name
ORDER BY average_price;

-- Q15. What are the most popular countries for music purchases?

SELECT
    c.country,
    SUM(il.quantity) AS purchases
FROM invoice_line il
JOIN invoice i
    ON i.invoice_id = il.invoice_id
JOIN customer c
    ON c.customer_id = i.customer_id
GROUP BY c.country
ORDER BY purchases DESC;

-- Q16. Which customers generate the most revenue?
-- Business purpose: Identify high-value customers who contribute the most to store revenue.

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT i.invoice_id) AS total_orders,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i
    ON i.customer_id = c.customer_id
JOIN invoice_line il
    ON il.invoice_id = i.invoice_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC;

SELECT * FROM invoice_line;

-- Q17. What percentage of total revenue comes from the top 10 customers?
-- Business purpose: Measure how dependent the store is on its highest-value customers.

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(il.unit_price * il.quantity) AS total_spent
    FROM customer c
    JOIN invoice i
        ON i.customer_id = c.customer_id
    JOIN invoice_line il
        ON il.invoice_id = i.invoice_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
ranked_customers AS (
    SELECT
        *,
        RANK() OVER (ORDER BY total_spent DESC) AS revenue_rank
    FROM customer_revenue
)
SELECT
    ROUND(
        100 * SUM(CASE WHEN revenue_rank <= 10 THEN total_spent ELSE 0 END)
        / SUM(total_spent),
        2
    ) AS top_10_revenue_percentage
FROM ranked_customers;

-- Q18. Which countries generate the highest revenue and average order value?
-- Business purpose: Find geographically strong markets and distinguish high-volume markets from high-value markets.

SELECT
    i.billing_country AS country,
    COUNT(DISTINCT i.invoice_id) AS total_orders,
    SUM(i.total) AS total_revenue,
    ROUND(AVG(i.total), 2) AS average_order_value
FROM invoice i
GROUP BY i.billing_country
ORDER BY total_revenue DESC;

-- Q19. Which genres generate the most revenue?
-- Business purpose: Identify the music categories contributing most to revenue.

SELECT
    g.genre_id,
    g.name AS genre,
    SUM(il.unit_price * il.quantity) AS total_revenue,
    SUM(il.quantity) AS units_sold
FROM invoice_line il
JOIN track t
    ON t.track_id = il.track_id
JOIN genre g
    ON g.genre_id = t.genre_id
GROUP BY g.genre_id, g.name
ORDER BY total_revenue DESC;

-- Q20. What percentage of total revenue does each genre contribute?
-- Business purpose: Understand the store's revenue mix.

WITH genre_revenue AS (
    SELECT
        g.genre_id,
        g.name AS genre,
        SUM(il.unit_price * il.quantity) AS revenue
    FROM invoice_line il
    JOIN track t
        ON t.track_id = il.track_id
    JOIN genre g
        ON g.genre_id = t.genre_id
    GROUP BY g.genre_id, g.name
)
SELECT
    genre,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        100 * revenue / SUM(revenue) OVER (),
        2
    ) AS revenue_percentage
FROM genre_revenue
ORDER BY revenue DESC;

-- Q21. Which artists generate the highest revenue?
-- Business purpose: Identify the most commercially successful artists.

SELECT
    ar.artist_id,
    ar.name AS artist_name,
    SUM(il.quantity) AS units_sold,
    SUM(il.unit_price * il.quantity) AS total_revenue
FROM invoice_line il
JOIN track t
    ON t.track_id = il.track_id
JOIN album al
    ON al.album_id = t.album_id
JOIN artist ar
    ON ar.artist_id = al.artist_id
GROUP BY ar.artist_id, ar.name
ORDER BY total_revenue DESC
LIMIT 10;

-- Q22. Which songs generate the highest revenue?
-- Business purpose: Identify individual tracks that are commercially successful.

SELECT
    t.track_id,
    t.name AS song_name,
    SUM(il.quantity) AS units_sold,
    SUM(il.unit_price * il.quantity) AS total_revenue
FROM invoice_line il
JOIN track t
    ON t.track_id = il.track_id
GROUP BY t.track_id, t.name
ORDER BY total_revenue DESC
LIMIT 10;

-- Q23. Which artists perform strongly in both sales volume and revenue?
-- Business purpose: Revenue alone can favor expensive products, while quantity alone can favor cheap products. 
-- This identifies artists strong on both metrics.

WITH artist_sales AS (
    SELECT
        ar.artist_id,
        ar.name AS artist_name,
        SUM(il.quantity) AS units_sold,
        SUM(il.unit_price * il.quantity) AS revenue
    FROM invoice_line il
    JOIN track t
        ON t.track_id = il.track_id
    JOIN album al
        ON al.album_id = t.album_id
    JOIN artist ar
        ON ar.artist_id = al.artist_id
    GROUP BY ar.artist_id, ar.name
),
ranked_artists AS (
    SELECT
        *,
        RANK() OVER (ORDER BY units_sold DESC) AS sales_rank,
        RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
    FROM artist_sales
)
SELECT
    artist_id,
    artist_name,
    units_sold,
    ROUND(revenue, 2) AS revenue,
    sales_rank,
    revenue_rank
FROM ranked_artists
WHERE sales_rank <= 10
   OR revenue_rank <= 10
ORDER BY revenue DESC;

-- Q24. What are the top 3 genres in each country by number of purchases?
-- Business purpose: Understand regional music preferences and identify opportunities for localized recommendations.

WITH genre_country_sales AS (
    SELECT
        c.country,
        g.name AS genre,
        SUM(il.quantity) AS purchases
    FROM invoice_line il
    JOIN invoice i
        ON i.invoice_id = il.invoice_id
    JOIN customer c
        ON c.customer_id = i.customer_id
    JOIN track t
        ON t.track_id = il.track_id
    JOIN genre g
        ON g.genre_id = t.genre_id
    GROUP BY c.country, g.genre_id, g.name
),
ranked_genres AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY country
            ORDER BY purchases DESC
        ) AS genre_rank
    FROM genre_country_sales
)
SELECT
    country,
    genre,
    purchases,
    genre_rank
FROM ranked_genres
WHERE genre_rank <= 3
ORDER BY country, genre_rank;

-- Q25. Who is the highest-spending customer in each country?
-- Business purpose: Identify the most valuable customer in every market.

WITH customer_spending AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.country,
        SUM(i.total) AS total_spent
    FROM customer c
    JOIN invoice i
        ON i.customer_id = c.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country
),
ranked_customers AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY country
            ORDER BY total_spent DESC
        ) AS customer_rank
    FROM customer_spending
)
SELECT
    country,
    customer_id,
    customer_name,
    ROUND(total_spent, 2) AS total_spent
FROM ranked_customers
WHERE customer_rank = 1
ORDER BY country;

-- Q26. Which customers spend more than the average customer?
-- Business purpose: Find customers whose spending is above the store-wide customer average.

WITH customer_spending AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(i.total) AS total_spent
    FROM customer c
    JOIN invoice i
        ON i.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spent, 2) AS total_spent
FROM customer_spending
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM customer_spending
)
ORDER BY total_spent DESC;

-- Q27. What is the monthly revenue trend?
-- Business purpose: Identify periods of high/low sales and demonstrate time-based business analysis.alter

SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS month,
    COUNT(invoice_id) AS total_orders,
    ROUND(SUM(total), 2) AS total_revenue
FROM invoice
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY month;

-- Q28. Which genres have high sales volume but relatively low revenue?
-- Business purpose: Find genres that sell frequently but generate comparatively less revenue—potentially useful for pricing or promotional decisions.

WITH genre_sales AS (
    SELECT
        g.genre_id,
        g.name AS genre,
        SUM(il.quantity) AS units_sold,
        SUM(il.unit_price * il.quantity) AS revenue
    FROM invoice_line il
    JOIN track t
        ON t.track_id = il.track_id
    JOIN genre g
        ON g.genre_id = t.genre_id
    GROUP BY g.genre_id, g.name
)
SELECT
    genre,
    units_sold,
    ROUND(revenue, 2) AS revenue,
    ROUND(revenue / units_sold, 2) AS revenue_per_unit
FROM genre_sales
ORDER BY units_sold DESC, revenue_per_unit ASC;

-- Q29. What are the top 5 artists within each genre by revenue?
-- Business purpose: Instead of only asking which artists are globally successful, identify the leaders within each music category.


WITH artist_genre_revenue AS (
    SELECT
        g.genre_id,
        g.name AS genre,
        ar.artist_id,
        ar.name AS artist_name,
        SUM(il.unit_price * il.quantity) AS revenue
    FROM invoice_line il
    JOIN track t
        ON t.track_id = il.track_id
    JOIN genre g
        ON g.genre_id = t.genre_id
    JOIN album al
        ON al.album_id = t.album_id
    JOIN artist ar
        ON ar.artist_id = al.artist_id
    GROUP BY
        g.genre_id,
        g.name,
        ar.artist_id,
        ar.name
),
ranked_artists AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY genre_id
            ORDER BY revenue DESC
        ) AS artist_rank
    FROM artist_genre_revenue
)
SELECT
    genre,
    artist_name,
    ROUND(revenue, 2) AS revenue,
    artist_rank
FROM ranked_artists
WHERE artist_rank <= 5
ORDER BY genre, artist_rank;

-- Q30. How concentrated is the store's revenue among its top artists?
-- Business purpose: Determine whether revenue is diversified or heavily dependent on a small number of artists.

WITH artist_revenue AS (
    SELECT
        ar.artist_id,
        ar.name AS artist_name,
        SUM(il.unit_price * il.quantity) AS revenue
    FROM invoice_line il
    JOIN track t
        ON t.track_id = il.track_id
    JOIN album al
        ON al.album_id = t.album_id
    JOIN artist ar
        ON ar.artist_id = al.artist_id
    GROUP BY ar.artist_id, ar.name
),
ranked_artists AS (
    SELECT
        *,
        RANK() OVER (ORDER BY revenue DESC) AS artist_rank
    FROM artist_revenue
)
SELECT
    ROUND(
        100 * SUM(
            CASE WHEN artist_rank <= 10
                 THEN revenue
                 ELSE 0
            END
        ) / SUM(revenue),
        2
    ) AS top_10_artists_revenue_percentage
FROM ranked_artists;

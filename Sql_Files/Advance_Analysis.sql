-- Command To Use Database

USE music_store;

-- Monthly Revenue & Month-over-Month Growth
-- How has the store's revenue changed month over month?

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS month,
        SUM(total) AS revenue
    FROM invoice
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        100 * (
            revenue - LAG(revenue) OVER (ORDER BY month)
        ) / LAG(revenue) OVER (ORDER BY month),
        2
    ) AS mom_growth_percentage
FROM monthly_revenue
ORDER BY month;

-- Customer Segmentation
-- How can customers be segmented based on their total spending?

WITH customer_spending AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(i.total) AS total_spent
    FROM customer c
    JOIN invoice i
        ON i.customer_id = c.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spent, 2) AS total_spent,
    CASE
        WHEN total_spent >= 100 THEN 'High Value'
        WHEN total_spent >= 50 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_spending
ORDER BY total_spent DESC;

-- Revenue Concentration by Customers
-- How dependent is the store on its highest-value customers?

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(i.total) AS revenue
    FROM customer c
    JOIN invoice i
        ON i.customer_id = c.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),
ranked_customers AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY revenue DESC) AS customer_rank
    FROM customer_revenue
)
SELECT
    ROUND(
        100 * SUM(
            CASE
                WHEN customer_rank <= 10 THEN revenue
                ELSE 0
            END
        ) / SUM(revenue),
        2
    ) AS top_10_customer_revenue_percentage
FROM ranked_customers;

-- Genre Performance
-- Which genres are strongest when considering both sales volume and revenue?

SELECT
    g.genre_id,
    g.name AS genre,
    SUM(il.quantity) AS units_sold,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS revenue,
    ROUND(
        SUM(il.unit_price * il.quantity) / SUM(il.quantity),
        2
    ) AS revenue_per_unit
FROM invoice_line il
JOIN track t
    ON t.track_id = il.track_id
JOIN genre g
    ON g.genre_id = t.genre_id
GROUP BY
    g.genre_id,
    g.name
ORDER BY revenue DESC;

-- Country Market Opportunity
-- Which countries generate high revenue per customer, indicating potentially valuable markets?

SELECT
    c.country,
    COUNT(DISTINCT c.customer_id) AS customers,
    ROUND(SUM(i.total), 2) AS total_revenue,
    ROUND(
        SUM(i.total) / COUNT(DISTINCT c.customer_id),
        2
    ) AS revenue_per_customer
FROM customer c
JOIN invoice i
    ON i.customer_id = c.customer_id
GROUP BY c.country
HAVING COUNT(DISTINCT c.customer_id) >= 2
ORDER BY revenue_per_customer DESC;

-- Top Artists Within Each Genre
-- Who are the top-performing artists within each music genre?

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

-- Revenue vs Sales Volume
-- Which artists have strong sales volume but relatively low revenue, and which generate high revenue with fewer sales?

WITH artist_performance AS (
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
    GROUP BY
        ar.artist_id,
        ar.name
)
SELECT
    artist_name,
    units_sold,
    ROUND(revenue, 2) AS revenue,
    ROUND(revenue / units_sold, 2) AS revenue_per_unit
FROM artist_performance
ORDER BY revenue DESC;
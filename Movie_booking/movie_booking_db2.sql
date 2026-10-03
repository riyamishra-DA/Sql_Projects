USE movie_booking_db;
select * from bookings;

-- 1 total bookings
select count(*) from  bookings;

-- 2 total tickets sold
select sum(seats_booked) from bookings
where seats_booked="confirmed";

-- 3 What is the total revenue generated from all bookings?
select sum(ticket_amount) from bookings
where booking_status="confirmed";

-- 4 Avereage tickets price
select round(sum(ticket_amount)/sum(seats_booked),2) as avg_ticket_price
from bookings
where booking_status="confirmed";

-- 5 Average booking value
select round(avg(ticket_amount),2) as avg_booking_value
from bookings 
where booking_status="confirmed";

-- 6 booking cancellation rate

select round(count(case when booking_status="cancelled"then 1 end)*100/
count(*),2) as cancellation_rate_pct
from bookings;

-- 7 Occupancy Rate

select sum(b.seats_booked)*100/sum(t.total_seats) as occupancy_rate_pct
from bookings b
join theatres t on t.theatre_id= b.theatre_id
where b.booking_status= "Confirmed";

-- 8 Revenue by Movie

SELECT 
    m.movie_name,
    SUM(b.ticket_amount) AS total_revenue
FROM bookings b
JOIN movies m 
    ON b.movie_id = m.movie_id
WHERE b.booking_status = 'Confirmed'
GROUP BY m.movie_id, m.movie_name
ORDER BY total_revenue DESC;

-- 9 Revenue by Theatre

SELECT 
    t.theatre_name,
    SUM(b.ticket_amount) AS total_revenue
FROM bookings b
JOIN theatres t 
    ON b.theatre_id = t.theatre_id
WHERE b.booking_status = 'Confirmed'
GROUP BY t.theatre_id, t.theatre_name
ORDER BY total_revenue DESC;

-- 10 Revenue by City 
SELECT 
    t.city,
    SUM(b.ticket_amount) AS total_revenue
FROM bookings b
JOIN theatres t 
    ON b.theatre_id = t.theatre_id
WHERE b.booking_status = 'Confirmed'
GROUP BY t.city
ORDER BY total_revenue DESC; 

-- 11 Most Popular Movie
SELECT 
    m.movie_name,
    COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN movies m 
    ON b.movie_id = m.movie_id
WHERE b.booking_status = 'Confirmed'
GROUP BY m.movie_id, m.movie_name
ORDER BY total_bookings DESC
LIMIT 1;
-- Agar tickets/seats ke basis par popularity chahiye:
SELECT 
    m.movie_name,
    SUM(b.seats_booked) AS tickets_sold
FROM bookings b
JOIN movies m 
    ON b.movie_id = m.movie_id
WHERE b.booking_status = 'Confirmed'
GROUP BY m.movie_id, m.movie_name
ORDER BY tickets_sold DESC
LIMIT 1;

-- 12 Most Popular Genre
SELECT 
    m.genre,
    SUM(b.seats_booked) AS tickets_sold
FROM bookings b
JOIN movies m 
    ON b.movie_id = m.movie_id
WHERE b.booking_status = 'Confirmed'
GROUP BY m.genre
ORDER BY tickets_sold DESC
LIMIT 1;
13. Peak Booking Hours ⏰
SELECT 
    HOUR(show_date) AS booking_hour,
    COUNT(*) AS total_bookings
FROM bookings
GROUP BY HOUR(show_date)
ORDER BY total_bookings DESC;
Top hour only:
SELECT 
    HOUR(show_date) AS peak_hour,
    COUNT(*) AS total_bookings
FROM bookings
GROUP BY HOUR(show_date)
ORDER BY total_bookings DESC
LIMIT 1;


-- 14 Peak Show Timings
SELECT 
    HOUR(show_date) AS show_hour,
    COUNT(*) AS total_bookings
FROM bookings
GROUP BY HOUR(show_date)
ORDER BY total_bookings DESC;


-- 15 Weekend vs Weekday Bookings
SELECT
    CASE
        WHEN DAYOFWEEK(show_date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS total_bookings,
    SUM(seats_booked) AS total_tickets
FROM bookings
WHERE booking_status = 'Confirmed'
GROUP BY day_type;

-- 16 Payment Method Distribution 
SELECT 
    payment_method,
    COUNT(*) AS total_bookings,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings),
        2
    ) AS percentage
FROM bookings
GROUP BY payment_method
ORDER BY total_bookings DESC;


-- 17 Customer Retention Rate
SELECT 
    ROUND(
        COUNT(DISTINCT CASE 
            WHEN booking_count > 1 THEN customer_id 
        END) * 100.0 
        / COUNT(DISTINCT customer_id),
        2
    ) AS customer_retention_rate
FROM (
    SELECT 
        customer_id,
        COUNT(*) AS booking_count
    FROM bookings
    GROUP BY customer_id
) AS customer_data;


-- 18 Repeat Customers
SELECT 
    COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM bookings
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) AS repeat_data;

-- 19 Top Spending Customers 💰
SELECT 
    customer_id,
    SUM(ticket_amount) AS total_spending
FROM bookings
WHERE booking_status = 'Confirmed'
GROUP BY customer_id
ORDER BY total_spending DESC
LIMIT 10;

-- 20 Theatre Utilization
SELECT 
    t.theatre_name,
    t.total_seats,
    SUM(b.seats_booked) AS seats_booked,
    ROUND(
        SUM(b.seats_booked) * 100.0 / t.total_seats,
        2
    ) AS utilization_percentage
FROM bookings b
JOIN theatres t 
    ON b.theatre_id = t.theatre_id
WHERE b.booking_status = 'Confirmed'
GROUP BY t.theatre_id, t.theatre_name, t.total_seats
ORDER BY utilization_percentage DESC;

-- 21 Language-wise Revenue
SELECT 
    m.language,
    SUM(b.ticket_amount) AS total_revenue
FROM bookings b
JOIN movies m 
    ON b.movie_id = m.movie_id
WHERE b.booking_status = 'Confirmed'
GROUP BY m.language
ORDER BY total_revenue DESC;


-- 22 Monthly Revenue Trend 
SELECT 
    DATE_FORMAT(show_date, '%Y-%m') AS month,
    SUM(ticket_amount) AS monthly_revenue
FROM bookings
WHERE booking_status = 'Confirmed'
GROUP BY DATE_FORMAT(show_date, '%Y-%m')
ORDER BY month;


-- 23 Movie Performance Dashboard

SELECT 
    m.movie_name,
    m.genre,
    m.language,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.seats_booked) AS tickets_sold,
    SUM(b.ticket_amount) AS total_revenue,
    ROUND(AVG(b.ticket_amount), 2) AS average_booking_value
FROM movies m
LEFT JOIN bookings b 
    ON m.movie_id = b.movie_id
    AND b.booking_status = 'Confirmed'
GROUP BY 
    m.movie_id,
    m.movie_name,
    m.genre,
    m.language
ORDER BY total_revenue DESC;

-- 24 Executive Booking Dashboard 

SELECT
    COUNT(*) AS total_bookings,
    SUM(seats_booked) AS total_tickets_sold,
    SUM(ticket_amount) AS total_revenue,
    ROUND(AVG(ticket_amount), 2) AS average_booking_value,
    ROUND(
        SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM bookings;


-- 25 Movie-wise Tickets Sold
SELECT 
    m.movie_name,
    SUM(b.seats_booked) AS tickets_sold
FROM bookings b
JOIN movies m 
    ON b.movie_id = m.movie_id
WHERE b.booking_status = 'Confirmed'
GROUP BY m.movie_id, m.movie_name
ORDER BY tickets_sold DESC;


-- 26 Theatre-wise Tickets Sold
SELECT 
    t.theatre_name,
    SUM(b.seats_booked) AS tickets_sold
FROM bookings b
JOIN theatres t 
    ON b.theatre_id = t.theatre_id
WHERE b.booking_status = 'Confirmed'
GROUP BY t.theatre_id, t.theatre_name
ORDER BY tickets_sold DESC;


-- 27 City-wise Number of Bookings
SELECT 
    t.city,
    COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN theatres t 
    ON b.theatre_id = t.theatre_id
WHERE b.booking_status = 'Confirmed'
GROUP BY t.city
ORDER BY total_bookings DESC;


-- 28 City-wise Tickets Sold
SELECT 
    t.city,
    SUM(b.seats_booked) AS tickets_sold
FROM bookings b
JOIN theatres t 
    ON b.theatre_id = t.theatre_id
WHERE b.booking_status = 'Confirmed'
GROUP BY t.city
ORDER BY tickets_sold DESC;


-- 29 Booking Status Distribution
SELECT 
    booking_status,
    COUNT(*) AS total_bookings,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings),
        2
    ) AS percentage
FROM bookings
GROUP BY booking_status;


-- 30 Average Tickets per Booking
SELECT 
    ROUND(AVG(seats_booked), 2) AS average_tickets_per_booking
FROM bookings
WHERE booking_status = 'Confirmed';


-- 31 Highest Value Booking
SELECT 
    booking_id,
    customer_id,
    movie_id,
    theatre_id,
    seats_booked,
    ticket_amount
FROM bookings
ORDER BY ticket_amount DESC
LIMIT 1;


-- 32 Lowest Value Booking
SELECT 
    booking_id,
    customer_id,
    movie_id,
    theatre_id,
    seats_booked,
    ticket_amount
FROM bookings
ORDER BY ticket_amount ASC
LIMIT 1;


-- 33 Most Popular Language
SELECT 
    m.language,
    SUM(b.seats_booked) AS tickets_sold
FROM bookings b
JOIN movies m 
    ON b.movie_id = m.movie_id
WHERE b.booking_status = 'Confirmed'
GROUP BY m.language
ORDER BY tickets_sold DESC
LIMIT 1;


-- 34 Most Popular Theatre
SELECT 
    t.theatre_name,
    COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN theatres t 
    ON b.theatre_id = t.theatre_id
WHERE b.booking_status = 'Confirmed'
GROUP BY t.theatre_id, t.theatre_name
ORDER BY total_bookings DESC
LIMIT 1;


-- 35 Most Popular City
SELECT 
    t.city,
    COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN theatres t 
    ON b.theatre_id = t.theatre_id
WHERE b.booking_status = 'Confirmed'
GROUP BY t.city
ORDER BY total_bookings DESC
LIMIT 1;


-- 36 Daily Booking Trend
SELECT 
    DATE(show_date) AS booking_date,
    COUNT(*) AS total_bookings,
    SUM(seats_booked) AS tickets_sold
FROM bookings
WHERE booking_status = 'Confirmed'
GROUP BY DATE(show_date)
ORDER BY booking_date;


-- 37 Average Revenue per Ticket
SELECT 
    ROUND(
        SUM(ticket_amount) / SUM(seats_booked),
        2
    ) AS average_revenue_per_ticket
FROM bookings
WHERE booking_status = 'Confirmed';


-- 8 Movie + Theatre Performance

SELECT 
    m.movie_name,
    t.theatre_name,
    t.city,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.seats_booked) AS tickets_sold,
    SUM(b.ticket_amount) AS total_revenue
FROM bookings b
JOIN movies m 
    ON b.movie_id = m.movie_id
JOIN theatres t 
    ON b.theatre_id = t.theatre_id
WHERE b.booking_status = 'Confirmed'
GROUP BY 
m.movie_id,m.movie_name,t.theatre_id,
t.theatre_name,t.city
ORDER BY total_revenue DESC;

-- 39 Movie-wise Cancellation Count
SELECT 
m.movie_name,
COUNT(*) AS cancelled_bookings
FROM bookings b
JOIN movies m 
ON b.movie_id = m.movie_id
WHERE b.booking_status = 'Cancelled'
GROUP BY m.movie_id, m.movie_name
ORDER BY cancelled_bookings DESC;


-- 40 Payment Method-wise Revenue
SELECT 
payment_method,
SUM(ticket_amount) AS total_revenue,
COUNT(*) AS total_bookings
FROM bookings
WHERE booking_status = 'Confirmed'
GROUP BY payment_method
ORDER BY total_revenue DESC;



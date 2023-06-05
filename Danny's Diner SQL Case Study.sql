-- SOURCE -> https://8weeksqlchallenge.com/case-study-1/

-- ------------------ PROBLEM STATEMENT -------------------------

-- Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, 
-- how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better 
-- and more personalised experience for his loyal customers. He plans on using these insights to help him decide whether he should expand the existing customer 
-- loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.
-- Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough 
-- for you to write fully functioning SQL queries to help him answer his questions!

-- Danny has shared with you 3 key datasets for this case study:
     -- sales
     -- menu
     -- members

-- The sales table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.
-- The menu table maps the product_id to the actual product_name and price of each menu item.
-- The final members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.


--------------------------------- SOLUTION ----------------------------

CREATE SCHEMA dannys_diner;

use dannys_diner;

CREATE TABLE sales (
customer_id VARCHAR(20), 
order_date DATE, 
product_id INTEGER );


INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
SELECT 
    *
FROM
    sales;
SELECT 
    *
FROM
    menu;
SELECT 
    *
FROM
    members;
  
-- Each of the following case study questions can be answered using a single SQL statement:

-- 1. What is the total amount each customer spent at the restaurant?

SELECT 
    s.customer_id, SUM(m.price) AS total_amount
FROM
    sales s
        INNER JOIN
    menu m ON m.product_id = s.product_id
GROUP BY customer_id;


-- 2. How many days has each customer visited the restaurant?

SELECT 
    customer_id, COUNT(order_date) AS visit_days
FROM
    sales
GROUP BY customer_id;


-- 3. What was the first item from the menu purchased by each customer?

SELECT 
    s.customer_id,
    MIN(s.order_date) AS first_order_date,
    m.product_name
FROM
    sales s
        INNER JOIN
    menu m ON s.product_id = m.product_id
GROUP BY customer_id;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
    m.product_name, COUNT(s.product_id) AS count_purchase
FROM
    sales s
        INNER JOIN
    menu m ON m.product_id = s.product_id
GROUP BY s.product_id , m.product_name
ORDER BY count_purchase DESC
LIMIT 1;


-- 5. Which item was the most popular for each customer?

SELECT customer_id, product_name, purchase_count
FROM (
  SELECT s.customer_id, m.product_name, COUNT(*) AS purchase_count,
    ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS rankk
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  GROUP BY s.customer_id, m.product_name
) sub
WHERE rankk = 1;


-- 6. Which item was purchased first by the customer after they became a member?

SELECT 
    s.customer_id,
    m.product_name,
    mm.join_date,
    MIN(s.order_date) AS first_purchase_date
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
        JOIN
    members mm ON mm.customer_id = s.customer_id
WHERE
    s.order_date > mm.join_date
GROUP BY s.customer_id
;


-- 7. Which item was purchased just before the customer became a member?

SELECT 
    s.customer_id,
    m.product_name,
    mm.join_date,
    MAX(s.order_date) AS last_purchase_date
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
        JOIN
    members mm ON mm.customer_id = s.customer_id
WHERE
    s.order_date < mm.join_date
GROUP BY s.customer_id
;

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT 
    s.customer_id, COUNT(s.product_id) as total_items , SUM(m.price) as amount_spent
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
        JOIN
    members mm ON mm.customer_id = s.customer_id
WHERE
    s.order_date < mm.join_date
GROUP BY s.customer_id;


-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT 
    s.customer_id,
    SUM(m.price) AS amount_spent,
    SUM(CASE
        WHEN m.product_name = 'sushi' THEN m.price * 20
        ELSE m.price * 10
    END) AS points
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT s.customer_id,
       SUM(CASE
           WHEN (s.order_date >= mm.join_date AND s.order_date < DATE_ADD(mm.join_date, INTERVAL 1 WEEK))
           THEN m.price * 2
           ELSE m.price
       END) * 10 AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mm ON s.customer_id = mm.customer_id
WHERE (s.order_date >= mm.join_date AND s.order_date <= '2021-01-31')
GROUP BY s.customer_id;


-- 11. The following query is for Danny and his team so they can use to quickly derive insights without needing to join the underlying tables using SQL.

SELECT 
    s.customer_id,
    s.order_date,
    m.product_name,
    m.price,
    CASE
        WHEN mem.join_date <= s.order_date THEN 'Y'
        ELSE 'N'
    END AS member
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
        LEFT JOIN
    members mem ON s.customer_id = mem.customer_id;

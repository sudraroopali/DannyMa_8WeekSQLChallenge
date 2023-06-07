-- SOURCE -> https://8weeksqlchallenge.com/case-study-2/

 -- ------------------ PROBLEM STATEMENT -------------------------

-- Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”
-- Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - 
-- so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!
-- Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and 
-- also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.


-- Table 1: runners - The runners table shows the registration_date for each new runner
-- Table 2: customer_orders - Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order.
-- The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and 
-- the extras are the ingredient_id values which need to be added to the pizza.
-- Note that customers can order multiple pizzas in a single order with varying exclusions and extras values even if the pizza is the same type!
-- The exclusions and extras columns will need to be cleaned up before using them in your queries.
-- Table 3: runner_orders - After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.
-- The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields 
-- are related to how far and long the runner had to travel to deliver the order to the respective customer.
-- There are some known data issues with this table so be careful when using this in your queries - make sure to check the data types for each column in the schema SQL!
-- Table 4: pizza_names - At the moment - Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!
-- Table 5: pizza_recipes - Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.
-- Table 6: pizza_toppings - This table contains all of the topping_name values with their corresponding topping_id value 


CREATE DATABASE dannys_pizzarunner;
USE dannys_pizzarunner;

CREATE TABLE runners (
  runner_id INTEGER,
  registration_date DATE
);

INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);

INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);

INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


CREATE TABLE pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);

INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);


INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
  select * from customer_orders;
  select * from pizza_names;
  select * from pizza_recipes;
  select * from pizza_toppings;
  select * from runner_orders;
  select * from runners;
  
  -- ------------------- DATA CLEANING -------------------------

 -- Customer Orders Table
 
UPDATE customer_orders 
SET 
    exclusions = NULL
WHERE
    exclusions LIKE '%null%'
        OR exclusions = '';

UPDATE customer_orders 
SET 
    extras = NULL
WHERE
    extras LIKE '%null%' OR extras = '';
    
-- Runner Orders Table

UPDATE runner_orders 
SET 
    pickup_time = NULL,
    distance = NULL,
    duration = NULL
WHERE
    cancellation LIKE '%Cancellation%';


UPDATE runner_orders 
SET 
    cancellation = NULL
WHERE
    cancellation NOT LIKE '%Cancellation%';
         
-- Removed km and minute symbols
UPDATE runner_orders 
SET 
    duration = TRIM(SUBSTRING(duration,
            1,
            INSTR(duration, 'm') - 1))
WHERE
    duration LIKE '%min%';


UPDATE runner_orders 
SET 
    distance = TRIM(SUBSTRING(distance,
            1,
            INSTR(distance, 'km') - 1))
WHERE
    distance LIKE '%km%';

         
-- Changed Data Type
ALTER TABLE runner_orders
MODIFY distance FLOAT;
         
ALTER TABLE runner_orders
MODIFY duration FLOAT;

-- Pizza Name Table
ALTER TABLE pizza_names
MODIFY pizza_name VARCHAR(30);
 
 -- Pizza Recipes
ALTER TABLE pizza_recipes
MODIFY toppings VARCHAR(30);
 
 -- Pizza Toppings
ALTER TABLE pizza_toppings
MODIFY topping_name VARCHAR(30);

-- --------------------------------- DATA ANALYSIS --------------------------------------
  
#PART 1 Pizza Metrics

-- 1.How many pizzas were ordered?
SELECT COUNT(*) as total_order
from customer_orders;

describe customer_orders;

-- 2.How many unique customer orders were made?

SELECT 
    COUNT(*) AS Number_of_Distinct_Orders
FROM
    (SELECT DISTINCT
        *
    FROM
        customer_orders) AS sq;


-- 3.How many successful orders were delivered by each runner?

select * from runner_orders;

SELECT 
    runner_id, COUNT(order_id) AS total_orders
FROM
    runner_orders
WHERE
    cancellation IS NULL
GROUP BY runner_id;


-- 4.How many of each type of pizza was delivered?

SELECT 
    co.pizza_id, COUNT(co.order_id) AS pizza_delivered
FROM
    customer_orders co
        JOIN
    runner_orders ro ON ro.order_id = co.order_id
WHERE
    cancellation IS NULL
GROUP BY pizza_id;


-- 5.How many Vegetarian and Meatlovers were ordered by each customer?

SELECT 
    pn.pizza_name, COUNT(co.order_id) AS total_pizza
FROM
    customer_orders co
        JOIN
    pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY co.pizza_id;


-- 6.What was the maximum number of pizzas delivered in a single order?

SELECT MAX(pizza_count) AS Maximum_Pizzas_Delivered
FROM (
  SELECT order_id, COUNT(*) AS pizza_count
  FROM customer_orders
  GROUP BY order_id
) AS order_counts;

-- 7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

#at least one change
SELECT DISTINCT
    co.customer_id, COUNT(*) AS one_change
FROM
    customer_orders co
        JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    (co.exclusions IS NULL
        OR co.extras IS NULL)
        AND ro.cancellation IS NULL
GROUP BY co.customer_id;

#no change
SELECT DISTINCT
    co.customer_id, COUNT(*) AS no_change
FROM
    customer_orders co
        JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    (co.exclusions IS NULL
        AND co.extras IS NULL)
        AND ro.cancellation IS NULL
GROUP BY co.customer_id;


-- 8.How many pizzas were delivered that had both exclusions and extras?

SELECT DISTINCT
    co.customer_id, COUNT(*) AS changes
FROM
    customer_orders co
        JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    (co.exclusions IS NOT NULL
        AND co.extras IS NOT NULL)
        AND ro.cancellation IS NULL
GROUP BY co.customer_id;


-- 9.What was the total volume of pizzas ordered for each hour of the day?

SELECT 
    HOUR(order_time) AS Time, COUNT(*) AS `Volume Ordered`
FROM
    customer_orders
GROUP BY HOUR(order_time);


-- 10.What was the volume of orders for each day of the week?

SELECT DAYNAME(order_time) as DayofWeek, COUNT(*) as volume_orders
from customer_orders
group by DAYNAME(order_time);

///////////////////////////////////////////////////////////////////////////////////////////////////

#PART 2 - Runner and Customer Experience

-- 1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT WEEK(registration_date) AS Week, COUNT(*) AS `No of Registrants`
FROM runners
GROUP BY WEEK(registration_date);


-- 2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT 
    ro.runner_id,
    AVG(TIMESTAMPDIFF(MINUTE,
        order_time,
        pickup_time)) AS average_time_minutes
FROM
    customer_orders co
        JOIN
    runner_orders ro ON co.order_id = ro.order_id
GROUP BY ro.runner_id;


-- 3.Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT ro.order_id, COUNT(*) AS `# of Orders`, AVG(TIMESTAMPDIFF(MINUTE, co.order_time, ro.pickup_time)) AS `Preparation Time`
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY ro.order_id;


-- 4.What was the average distance travelled for each customer?

SELECT 
    co.customer_id,
    AVG(ro.distance) AS avg_distance_per_customer
FROM
    customer_orders co
        JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    cancellation IS NULL
GROUP BY co.customer_id;


-- 5.What was the difference between the longest and shortest delivery times for all orders?

SELECT 
    (MAX(duration) - MIN(duration)) AS delivery_range
FROM
    runner_orders;


-- 6.What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT 
    ro.runner_id,
    ro.order_id,
    ro.distance,
    ro.duration,
    (ro.distance / ro.duration) AS average_speed
FROM
    runner_orders ro
WHERE
    ro.duration IS NOT NULL
ORDER BY ro.runner_id;

#Runner 1 has varying average speeds for different orders.
#Runner 2 generally has higher average speeds across their deliveries. 
#Runner 3 has a consistent average speed for their single delivery.


-- 7.What is the successful delivery percentage for each runner?

SELECT 
    runner_id,
    COUNT(*) AS total_orders,
    SUM(CASE
        WHEN cancellation IS NULL THEN 1
        ELSE 0
    END) AS successful_orders,
    (SUM(CASE
        WHEN cancellation IS NULL THEN 1
        ELSE 0
    END)) / COUNT(*) * 100 AS sucess_perct
FROM
    runner_orders
GROUP BY runner_id;
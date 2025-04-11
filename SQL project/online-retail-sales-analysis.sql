CREATE DATABASE online_retail;
USE online_retail;

-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    location VARCHAR(100)
);

-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);



-- 1. customers

INSERT INTO customers (customer_id, name, email, location) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'New York'),
(2, 'Bob Smith', 'bob@example.com', 'Los Angeles'),
(3, 'Charlie Lee', 'charlie@example.com', 'Chicago'),
(4, 'Diana Patel', 'diana@example.com', 'Houston'),
(5, 'Ethan Brown', 'ethan@example.com', 'Phoenix');



-- 2. products
INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Wireless Mouse', 'Electronics', 25.00),
(2, 'Bluetooth Headphones', 'Electronics', 45.00),
(3, 'Yoga Mat', 'Sports', 20.00),
(4, 'Running Shoes', 'Sports', 60.00),
(5, 'Desk Lamp', 'Home & Living', 30.00),
(6, 'Cookware Set', 'Home & Living', 80.00),
(7, 'Smartphone Stand', 'Accessories', 15.00),
(8, 'Notebook', 'Stationery', 5.00);




INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2024-01-15', 70.00),
(2, 2, '2024-02-10', 90.00),
(3, 3, '2024-03-05', 50.00),
(4, 1, '2024-03-20', 60.00),
(5, 4, '2024-04-01', 100.00),
(6, 5, '2024-04-18', 45.00),
(7, 2, '2024-04-22', 130.00);




INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 2, 25.00),  -- Wireless Mouse
(2, 1, 8, 4, 5.00),   -- Notebook

(3, 2, 2, 2, 45.00),  -- Bluetooth Headphones

(4, 3, 3, 1, 20.00),  -- Yoga Mat
(5, 3, 7, 2, 15.00),  -- Smartphone Stand

(6, 4, 4, 1, 60.00),  -- Running Shoes

(7, 5, 6, 1, 80.00),  -- Cookware Set
(8, 5, 5, 2, 30.00),  -- Desk Lamp

(9, 6, 1, 1, 25.00),  -- Wireless Mouse
(10, 6, 7, 2, 10.00), -- Smartphone Stand

(11, 7, 4, 2, 60.00), -- Running Shoes
(12, 7, 3, 1, 20.00); -- Yoga Mat

select*from products;





-- Total customers
SELECT COUNT(*) AS total_customers FROM customers;

-- Product categories
SELECT DISTINCT category FROM products;

-- Top 10 products by total quantity sold
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 10;

-- Customer with highest spending
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;


SELECT 
  p.category,
  SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


SELECT AVG(total_amount) AS avg_order_value FROM orders;

SELECT 
  c.location,
  SUM(o.total_amount) AS location_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.location
ORDER BY location_revenue DESC;


SELECT DISTINCT c.name, c.email
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.product_name = 'Running Shoes';




DELIMITER //

CREATE PROCEDURE GetCustomerReport(IN customer_id_input INT)
BEGIN
    SELECT 
        c.name,
        COUNT(o.order_id) AS total_orders,
        SUM(o.total_amount) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE c.customer_id = customer_id_input
    GROUP BY c.name;
END //

DELIMITER ;

CALL GetCustomerReport(1);

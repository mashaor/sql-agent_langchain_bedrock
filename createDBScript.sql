-- Create the database
CREATE DATABASE SalesDB;

-- Use the database
USE SalesDB;

-- Create customer table
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

-- Create invoice table
CREATE TABLE invoice (
    invoice_id INT PRIMARY KEY,
    customer_id INT,
    invoice_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- Create order table
CREATE TABLE `orders` (
    order_id INT PRIMARY KEY,
    invoice_id INT,
    product_name VARCHAR(100),
    quantity INT,
    price_per_unit DECIMAL(10, 2),
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id)
);

-- Insert data into customer table
INSERT INTO customer (customer_id, name, email, phone) VALUES
(1, 'John Doe', 'john.doe@example.com', '555-1234'),
(2, 'Jane Smith', 'jane.smith@example.com', '555-5678'),
(3, 'Alice Johnson', 'alice.johnson@example.com', '555-8765'),
(4, 'Bob Brown', 'bob.brown@example.com', '555-4321'),
(5, 'Charlie Davis', 'charlie.davis@example.com', '555-9876'),
(6, 'Diana Evans', 'diana.evans@example.com', '555-6543'),
(7, 'Eve Foster', 'eve.foster@example.com', '555-3210'),
(8, 'Frank Green', 'frank.green@example.com', '555-7890'),
(9, 'Grace Harris', 'grace.harris@example.com', '555-4567'),
(10, 'Henry Irvine', 'henry.irvine@example.com', '555-0123');

-- Insert data into invoice table
INSERT INTO invoice (invoice_id, customer_id, invoice_date, total_amount) VALUES
(1, 1, '2024-01-01', 100.00),
(2, 2, '2024-01-02', 200.00),
(3, 3, '2024-01-03', 150.00),
(4, 4, '2024-01-04', 250.00),
(5, 5, '2024-01-05', 300.00),
(6, 6, '2024-01-06', 350.00),
(7, 7, '2024-01-07', 400.00),
(8, 8, '2024-01-08', 450.00),
(9, 9, '2024-01-09', 500.00),
(10, 10, '2024-01-10', 550.00);

-- Insert data into order table
INSERT INTO `orders` (order_id, invoice_id, product_name, quantity, price_per_unit) VALUES
(1, 1, 'Product A', 1, 100.00),
(2, 2, 'Product B', 2, 100.00),
(3, 3, 'Product C', 1, 150.00),
(4, 4, 'Product D', 5, 50.00),
(5, 5, 'Product E', 3, 100.00),
(6, 6, 'Product F', 7, 50.00),
(7, 7, 'Product G', 4, 100.00),
(8, 8, 'Product H', 9, 50.00),
(9, 9, 'Product I', 5, 100.00),
(10, 10, 'Product J', 11, 50.00);

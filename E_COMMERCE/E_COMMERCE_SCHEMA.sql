-- Language : PostgreSQL
-- 스키마
-- 외래 키 설정은 맨 아래

-- CUSTOMERS
CREATE TABLE customers (
    Customer_id VARCHAR(20) NOT NULL,
    Customer_unique_id VARCHAR(30) NOT NULL,
    Customer_zipcode_prefix INTEGER NOT NULL,
    Customer_city VARCHAR(255) NOT NULL,
    Customer_state VARCHAR(5) NOT NULL,
    PRIMARY KEY (Customer_id)
);

SELECT * FROM customers;

-- ORDER_ITEMS
CREATE TABLE order_items (
  Order_id VARCHAR(20),
  Order_item_id VARCHAR(20),
  Product_id VARCHAR(20),
  Seller_id VARCHAR(20),
  Price DECIMAL(10, 2),
  Freight_value DECIMAL(10, 2),
  PRIMARY KEY (order_id, order_item_id)
);

SELECT * FROM order_items;

-- ORDERS
CREATE TABLE orders (
  Order_id VARCHAR(20),
  Customer_id VARCHAR(20),
  Order_status VARCHAR(20),
  Order_purchase_timestamp TIMESTAMP,
  Order_delivered_carrier_date TIMESTAMP,
  Order_delivered_customer_date TIMESTAMP,
  Order_estimated_delivery_date DATE,
  PRIMARY KEY (Order_id)
);

SELECT * FROM ORDERS;

-- PAYMENTS
CREATE TABLE payments (	
	Order_id VARCHAR(20),
	Payment_sequential INTEGER,
	Payment_type VARCHAR(20),
	Payment_installments INTEGER,
	Payment_value DECIMAL(10, 2),
	PRIMARY KEY (Order_id, Payment_sequential)
);
 
SELECT * FROM payments;

-- PRODUCTS
-- 이상한 값 존재하는 상태 & 규격 컬럼들이 object 타입인 상태
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    Product_id VARCHAR(30),	
    Product_category_name VARCHAR(255),
    Product_weight_g VARCHAR,
    Product_length_cm VARCHAR,
    Product_height_cm VARCHAR,
    Product_width_cm VARCHAR,
	PRIMARY KEY (Product_id)
);

SELECT * FROM PRODUCTS;

-- 이상한 값 알아보기
SELECT * FROM products 
WHERE NOT (Product_width_cm ~ '^[0-9]*\.?[0-9]+$') 
   OR NOT (Product_height_cm ~ '^[0-9]*\.?[0-9]+$') 
   OR NOT (Product_length_cm ~ '^[0-9]*\.?[0-9]+$')
   OR NOT (Product_weight_g ~ '^[0-9]*\.?[0-9]+$');

-- UNKNOWN 발견 : 해당 행은 NULL로 계산
UPDATE products
SET Product_width_cm = NULL
WHERE NOT (Product_width_cm ~ '^[0-9]*\.?[0-9]+$');

UPDATE products
SET Product_height_cm = NULL
WHERE NOT (Product_height_cm ~ '^[0-9]*\.?[0-9]+$');

UPDATE products
SET Product_length_cm = NULL
WHERE NOT (Product_length_cm ~ '^[0-9]*\.?[0-9]+$');

UPDATE products
SET Product_weight_g = NULL
WHERE NOT (Product_weight_g ~ '^[0-9]*\.?[0-9]+$');

-- 수치 계산을 위해 FLOAT로 바꿔줌
ALTER TABLE products
ALTER COLUMN Product_width_cm TYPE FLOAT USING Product_width_cm::FLOAT,
ALTER COLUMN Product_height_cm TYPE FLOAT USING Product_height_cm::FLOAT,
ALTER COLUMN Product_length_cm TYPE FLOAT USING Product_height_cm::FLOAT,
ALTER COLUMN Product_weight_g TYPE FLOAT USING Product_weight_g::FLOAT;

-- REVIEWS
CREATE TABLE reviews (
	Review_id VARCHAR(20),
	Order_id VARCHAR(20),
	Review_score INTEGER,
	Review_creation_date TIMESTAMP,
	Review_answer_timestamp TIMESTAMP,
	PRIMARY KEY (Review_id, Order_id)
);

SELECT * FROM REVIEWS;

--SELLERS
DROP TABLE IF EXISTS sellers CASCADE;
CREATE TABLE sellers (
    Seller_id VARCHAR(20) NOT NULL,
    Seller_zipcode_prefix INTEGER NOT NULL,
    Seller_city VARCHAR(255) NOT NULL,
    Seller_state VARCHAR(5) NOT NULL,
    PRIMARY KEY (Seller_id)
);

SELECT * FROM SELLERS;

-- 외래 키 설정

ALTER TABLE reviews ADD FOREIGN KEY (Order_id) REFERENCES orders (Order_id);
ALTER TABLE payments ADD FOREIGN KEY (Order_id) REFERENCES orders (Order_id);
ALTER TABLE order_items ADD FOREIGN KEY (Order_id) REFERENCES orders (Order_id);
ALTER TABLE order_items ADD FOREIGN KEY (Seller_id) REFERENCES sellers (Seller_id);
ALTER TABLE order_items ADD FOREIGN KEY (Product_id) REFERENCES products (Product_id);
ALTER TABLE orders ADD FOREIGN KEY (Customer_id) REFERENCES customers(Customer_id);


-- Exported from : dbdiagram.io

CREATE TABLE "customers" (
  "Customer_id" varchar PRIMARY KEY,
  "Customer_unique_id" varchar,
  "Customer_zipcode_prefix" integer,
  "Customer_city" varchar,
  "Customer_state" varchar
);

CREATE TABLE "locations" (
  "Geolocation_zipcode_prefix" integer,
  "Geolocation_lat" float,
  "Geolocation_lng" float,
  "Geolocation_city" varchar,
  "Geolocation_state" char,
  PRIMARY KEY ("Geolocation_zipcode_prefix", "Geolocation_lat", "Geolocation_lng")
);

CREATE TABLE "order_items" (
  "Order_id" varchar,
  "Order_item_id" varchar,
  "Product_id" varchar,
  "Seller_id" varchar,
  "Price" decimal,
  "Freight_value" decimal,
  PRIMARY KEY ("Order_id", "Order_item_id")
);

CREATE TABLE "orders" (
  "Order_id" varchar PRIMARY KEY,
  "Customer_id" varchar,
  "Order_status" varchar,
  "Order_purchase_timestamp" timestamp,
  "Order_delivered_carrier_date" timestamp,
  "Order_delivered_customer_date" timestamp,
  "Order_estimated_delivery_date" timestamp
);

CREATE TABLE "payments" (
  "Order_id" varchar,
  "Payment_sequential" integer,
  "Payment_type" varchar,
  "Payment_installments" integer,
  "Payment_value" float,
  PRIMARY KEY ("Order_id", "Payment_sequential")
);

CREATE TABLE "products" (
  "Product_id" varchar,
  "Product_item_id" varchar,
  "Product_category_name" varchar,
  "Product_weight_g" float,
  "Product_length_cm" float,
  "Product_height_cm" float,
  "Product_width_cm" float,
  PRIMARY KEY ("Product_id", "Product_item_id")
);

CREATE TABLE "reviews" (
  "Review_id" varchar PRIMARY KEY,
  "Order_id" varchar,
  "Review_score" integer,
  "Review_creation_date" timestamp,
  "Review_answer_timestamp" timestamp
);

CREATE TABLE "sellers" (
  "Seller_id" varchar PRIMARY KEY,
  "Seller_zipcode_prefix" integer,
  "Seller_city" varchar,
  "Seller_state" char
);

ALTER TABLE "reviews" ADD FOREIGN KEY ("Order_id") REFERENCES "orders" ("Order_id");

ALTER TABLE "order_items" ADD FOREIGN KEY ("Order_id") REFERENCES "orders" ("Order_id");

ALTER TABLE "order_items" ADD FOREIGN KEY ("Seller_id") REFERENCES "sellers" ("Seller_id");

ALTER TABLE "order_items" ADD FOREIGN KEY ("Product_id") REFERENCES "products" ("Product_id");

ALTER TABLE "payments" ADD FOREIGN KEY ("Order_id") REFERENCES "orders" ("Order_id");

ALTER TABLE "customers" ADD FOREIGN KEY ("Customer_id") REFERENCES "orders" ("Customer_id");

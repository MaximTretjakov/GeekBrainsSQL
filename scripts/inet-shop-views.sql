-- 1. list info about product and category.

CREATE OR REPLACE VIEW product_info (name, description, price, catalog_name) AS
SELECT	products.name,
		products.description,
		products.price,
		catalogs.name 
FROM products JOIN catalogs 
ON products.catalog_id = catalogs.id 
;

SELECT * FROM product_info;

-- 2. list all orders for all clients.

CREATE OR REPLACE VIEW all_clients_orders (user_name, created_at, `count`, product_name, product_description) AS
SELECT	users.name, 
		orders.created_at,
		orders_products.total,
		products.name,
		products.description
FROM	users 
		JOIN orders
			ON users.id = orders.user_id
		JOIN orders_products 
			ON orders_products.order_id = orders.id 
		JOIN products 
			ON orders_products.order_id = products.id 
ORDER BY users.name 
;

SELECT * FROM all_clients_orders;




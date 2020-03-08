/*
	“Сложные запросы”
	 
	1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
*/


SELECT id, name 
FROM users
WHERE id IN (SELECT user_id from orders WHERE orders.user_id = users.id)
;

SELECT DISTINCT users.id, users.name
FROM users JOIN orders 
ON users.id = orders.user_id 
;


/*
	2. Выведите список товаров products и разделов catalogs, который соответствует товару.
*/


SELECT products.name AS product_name, 
       catalogs.name AS catalog_name
FROM products JOIN catalogs 
ON products.catalog_id = catalogs.id 
;




















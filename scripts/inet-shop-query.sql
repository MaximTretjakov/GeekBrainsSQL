/*
	Тема работы - "Интернет магазин".
	
	В рамках курсовой была создана и описана модель хранения данных, которая включает в себя:
	1. таблицы.
	2. представления.
	3. хранимые процедуры и триггеры.
	4. скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы).
	5. ERDiagram'у связей в БД.
	
	
	БД реализует бизнесс процессы типичного интернет магазина.
	1. ввод данных.
	2. дополнение, удаление, изменение данных.
	3. сортировка, выборка данных.
	4. предоставление аналитики.
	5. продажа, учет товара.
*/


-- скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы).
-- get orders count for user

SELECT  COUNT(id),
	    user_id 
FROM orders 
GROUP BY user_id
;

-- get user name and order details

SELECT 	users.name,
		users.phone,
		orders.created_at,
		orders_products.status,
		products.name,
		products.description 
FROM orders JOIN users 
ON orders.user_id = users.id
JOIN orders_products
ON orders.id = orders_products.id 
JOIN products 
ON orders_products.product_id = products.id 
WHERE users.id = 2
;




















-- 1. users table

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  phone BIGINT,
  address VARCHAR(255),
  email VARCHAR(50),
  birthday_at DATE ,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Clients';

INSERT INTO users (name, phone, address, email, birthday_at) VALUES
  ('Геннадий', 7773444567, 'г.Симферополь, ул.Ленина, д.32, кв.4', 'gena@lucky.mail.ru', '1990-10-05'),
  ('Наталья', 5775451227, 'г.Москва, Лялин пер, д.26, кв.38', 'natasha@lucky.mail.ru', '1985-12-31'),
  ('Александр', 7373341516, 'г.Сызрань, ул.Бутлерова, д.12, кв.1', 'alex@lucky.mail.ru', '1950-07-15'),
  ('Сергей', 5573045527, 'г.Анапа, ул.Маршала Жукова, д.34, кв.142', 'sergey@yandex.mail.ru', '1992-05-25'),
  ('Иван', 7003049507, 'г.Мурманск, ул.Путина, д.59, кв.9', 'ivan@gmail.com', '1980-09-05'),
  ('Мария', 7563000001, 'г.Москва, пр.Нахимова, д.11, кв.24', 'mary@lucky.mail.ru', '1992-08-02');
 
-- 2. catalogs table

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  UNIQUE unique_name(name(10))
) COMMENT = 'catalogs';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

-- 3. sale event table

DROP TABLE IF EXISTS event;
CREATE TABLE event (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id BIGINT UNSIGNED,
  discount FLOAT UNSIGNED,
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id),
  
  
  FOREIGN KEY (product_id)
   	REFERENCES products(id)
   		ON UPDATE CASCADE 
   		ON DELETE RESTRICT
  
) COMMENT = 'sale event';

INSERT INTO event (user_id, product_id, discount, started_at, finished_at) VALUES
  (1, 1, 0.9, NULL, NULL),
  (1, 2, 0.8, NULL, NULL),
  (1, 5, 0.7, NULL, NULL);
 
-- 4. products table

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  description TEXT,
  price DECIMAL (11,2),
  catalog_id BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id),
  
	FOREIGN KEY (catalog_id)
       REFERENCES catalogs(id)
			ON UPDATE CASCADE 
       		ON DELETE RESTRICT
  
) COMMENT = 'products';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);


-- 5. orders table
 
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  
   FOREIGN KEY (user_id)
       REFERENCES users(id)
       ON UPDATE CASCADE 
       ON DELETE RESTRICT
  
  
) COMMENT = 'orders';

INSERT INTO orders
  (user_id)
VALUES
  (1),
  (2),
  (3),
  (1),
  (5),
  (6);

 
-- 6. orders products table

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id BIGINT UNSIGNED,
  product_id BIGINT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  status BIT COMMENT 'Статус заказа. Подтвержден или нет.',
  outlet_id BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  
 	FOREIGN KEY (order_id)
  		REFERENCES orders(id)
    		ON UPDATE CASCADE 
    		ON DELETE RESTRICT,
    	
    	
    	
	FOREIGN KEY (product_id)
  		REFERENCES products(id)
    		ON UPDATE CASCADE 
    		ON DELETE RESTRICT,
    		
   	FOREIGN KEY (outlet_id)
  		REFERENCES outlets(id)
    		ON UPDATE CASCADE 
    		ON DELETE RESTRICT
  
) COMMENT = 'orders_products';


INSERT INTO orders_products
  (order_id, product_id, total, status, outlet_id)
VALUES
  (1, 1, 1, 0, 2),
  (2, 3, 2, 1, 1),
  (3, 7, 1, 0, 4),
  (1, 2, 1, 0, 4),
  (5, 4, 5, 0, 3),
  (6, 5, 3, 0, 2);


-- 7. storehouses table

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  address VARCHAR(100),
  phone BIGINT,
  storehouses_products_id BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  
  FOREIGN KEY (storehouses_products_id)
	  REFERENCES storehouses_products(id)
		  ON UPDATE CASCADE 
    	  ON DELETE RESTRICT
  
) COMMENT = 'storehouses';


INSERT INTO storehouses (name, address, phone, storehouses_products_id) VALUES
  ('Склад - 1', 'г.Складовой, ул.Складская 1а', 1008562594, 1),
  ('Склад - 2', 'г.Складовой, ул.Складская 2с', 1508562594, 2),
  ('Склад - 3', 'г.Складовой, ул.Складская 1а', 2018562554, 3),
  ('Склад - 4', 'г.Складовой, ул.Ивана Сусанина 9', 1998562594, 4),
  ('Склад - 5', 'г.Складовой, ул.Вишневая 10', 3008562594, 5),
  ('Склад - 6', 'г.Складовой, ул.Марсианская 22', 2018562554, 6)
  ;


-- 8. storehouses products table

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'storehouses products';

INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
  ('1', '1', '1'),
  ('2', '2', '0'),
  ('3', '3', '30'),
  ('4', '4', '0'),
  ('5', '5', '500'),
  ('6', '6', '2500');

 
-- 9. outlets

DROP TABLE IF EXISTS outlets;
CREATE TABLE outlets (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  address VARCHAR(100),
  phone BIGINT
) COMMENT = 'outlets';

INSERT INTO outlets (name, address, phone) VALUES
  ('торговая точка - 1', 'г.Складовой, ул.Торговая, владение 5', 1008562594),
  ('торговая точка - 2', 'г.Складовой, ул.Торговая, владение 12', 2008562594),
  ('торговая точка - 3', 'г.Складовой, ул.Объездная, владение 10', 1238532594),
  ('торговая точка - 4', 'г.Складовой, ул.Складская, владение 1', 1018222090);
 

-- 10. financial operations

DROP TABLE IF EXISTS accounting;
CREATE TABLE accounting (
  id SERIAL PRIMARY KEY,
  holder_name BIGINT UNSIGNED NOT NULL,
  card_number BIGINT UNSIGNED NOT NULL,
  balance decimal(15,2) NOT NULL,
  
  
  FOREIGN KEY (holder_name)
	  REFERENCES orders_products(order_id)
		  ON UPDATE CASCADE 
    	  ON DELETE RESTRICT
  
  
) COMMENT = 'accounting';

INSERT INTO accounting (holder_name, card_number, balance) VALUES
  (1, 7773444567000134, 10000.00),
  (2, 5775451227000131, 5000.00),
  (3, 7373341516000194, 570.12),
  (4, 5573045527000104, 120.35),
  (5, 7003049507000444, 3330.22),
  (6, 7563000001010134, 2954.45),
  (7, 7003049000000000, 0.0);
 


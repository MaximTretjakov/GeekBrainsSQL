/*
	“Транзакции, переменные, представления”
	
	1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
	Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
	Используйте транзакции.
*/

START TRANSACTION;

SELECT @name := name, @birthday_at := birthday_at
FROM shop.users
WHERE shop.users.id = 1
;

INSERT INTO sample.users (name, birthday_at) 
VALUES (@name, @birthday_at)
;

COMMIT;


/*
	1. Создайте представление, которое выводит название name товарной позиции из таблицы products 
	и соответствующее название каталога name из таблицы catalogs. 
*/


CREATE OR REPLACE VIEW product_info (name, catalog_name) AS
SELECT products.name, catalogs.name 
FROM products JOIN catalogs 
ON products.catalog_id = catalogs.id 
;

SELECT * FROM product_info;

/*
	“Хранимые процедуры и функции, триггеры"
	
	1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
	С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
	с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
	с 18:00 до 00:00 — "Добрый вечер", 
	с 00:00 до 6:00 — "Доброй ночи".
*/


DELIMITER //
DROP PROCEDURE IF EXISTS HELLO//
CREATE PROCEDURE HELLO(IN cur_hour INT)
BEGIN
	IF(cur_hour >= 6 and cur_hour <= 12) THEN
    	SELECT 'Доброе утро';
  	END IF;
  	IF(cur_hour >= 12 and cur_hour <= 18) THEN
    	SELECT 'Добрый день';
  	END IF;
  	IF(cur_hour >= 18 and cur_hour <= 24) THEN
    	SELECT 'Добрый вечер';
  	END IF;
  	IF(cur_hour <= 24 and cur_hour <= 6) THEN
    	SELECT 'Доброй ночи';
  	END IF;
END//

CALL HELLO(2)//
-- CALL HELLO(15)//
-- CALL HELLO(21)//
-- CALL HELLO(2)//

/*
	2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
	Допустимо присутствие обоих полей или одно из них. 
	Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
	Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
	При попытке присвоить полям NULL-значение необходимо отменить операцию.
*/


DELIMITER //
DROP TRIGGER IF EXISTS check_products_insert//
CREATE TRIGGER check_products_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  SET NEW.name = COALESCE(NEW.name, 'default_name');
  SET NEW.description = COALESCE(NEW.description, 'default_name');
END//

DELIMITER //
DROP TRIGGER IF EXISTS check_products_update//
CREATE TRIGGER check_products_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  SET NEW.name = COALESCE(NEW.name, OLD.name, 'default_name');
  SET NEW.description = COALESCE(NEW.description, OLD.description, 'default_name');
END//




























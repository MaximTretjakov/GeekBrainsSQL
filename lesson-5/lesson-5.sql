/*
	---	Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение” ---
		
	1.	Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
		Заполните их текущими датой и временем.
*/

USE shop;

UPDATE users SET created_at = NOW(), updated_at = NOW();

/*
	2.  Таблица users была неудачно спроектирована. 
		Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время 
		помещались значения в формате "20.10.2017 8:10". 
		Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
*/

SELECT STR_TO_DATE(created_at, '%d.%m.%Y %H:%m') as created_at, 
	   STR_TO_DATE(updated_at, '%d.%m.%Y %H:%m') as updated_at
	   FROM users_bad;

UPDATE users_bad SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%m'),
	   				 updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%m');

ALTER TABLE users_bad MODIFY COLUMN created_at DATETIME;
ALTER TABLE users_bad MODIFY COLUMN updated_at DATETIME;

/*
	3.	В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
		0, если товар закончился и выше нуля, если на складе имеются запасы. 
		Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
		Однако, нулевые запасы должны выводиться в конце, после всех записей. 
*/

SELECT * FROM storehouses_products  
ORDER BY value = 0;




/*
	--- Практическое задание теме “Агрегация данных” ---
	
	1.	Подсчитайте средний возраст пользователей в таблице users
*/


SELECT name, TIMESTAMPDIFF(YEAR, birthday_at, NOW()) AS age
FROM users;






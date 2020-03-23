DELIMITER //

-- calculate all orders for given user.

DROP PROCEDURE IF EXISTS ALL_ORDERS//
CREATE PROCEDURE ALL_ORDERS(IN target_user_id INT)
BEGIN
	SELECT	users.name,
			COUNT(user_id) AS orders_count 
	FROM orders JOIN users 
	ON orders.user_id = users.id 
	WHERE user_id = target_user_id
	GROUP BY user_id
	;
END//

CALL ALL_ORDERS(1)//


DELIMITER //

-- calculate discount.

DROP PROCEDURE IF EXISTS CALC_DISCOUNT//
CREATE PROCEDURE CALC_DISCOUNT(IN discount_persent FLOAT, IN cat_id INT, IN price_value INT)
BEGIN
	UPDATE products SET price = price * discount_persent
	WHERE catalog_id = cat_id AND price > price_value
	;
END//

CALL CALC_DISCOUNT(0.5, 1, 5000)//


DELIMITER //

-- accounts. financial calculations.

DROP PROCEDURE IF EXISTS ACCOUNTS//
CREATE PROCEDURE ACCOUNTS(IN user_id INT, IN to_shop INT, OUT tran_result VARCHAR(200))
BEGIN
	DECLARE `_rollback` BIT DEFAULT 0;
	DECLARE code VARCHAR(100);
	DECLARE error_string VARCHAR(100);

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		SET `_rollback` = 1;
		GET stacked DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
		SET tran_result := CONCAT('Error occured. Code: ', code, ' Text: ', error_string);
	END;

	START TRANSACTION;

		-- get product price
		SELECT @prod_price := products.price
		FROM orders_products JOIN products 
		ON orders_products.product_id = products.id
		AND orders_products.order_id = user_id
		LIMIT 1;
		
		-- get user balance
		SELECT @accounting_bal := accounting.balance 
		FROM orders_products JOIN accounting
		ON orders_products.order_id = accounting.holder_name 
		AND orders_products.order_id = user_id
		LIMIT 1;
		
		-- if user balance >= product price in order products, update user balance and inet-shop balance.
		-- if not rise exception and rollback transaction.
		IF(@accounting_bal >= @prod_price) THEN
    		UPDATE accounting SET balance = balance - @prod_price 
    		WHERE holder_name = user_id;
    	
    		UPDATE accounting SET balance = balance + @prod_price
    		WHERE holder_name = to_shop;
  		ELSE
  			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Для совершения операции недостаточно средств на счете.';
			ROLLBACK;
  		END IF;
		
	
	IF `_rollback` THEN
		ROLLBACK;
	ELSE
		SET tran_result = 'OK';
		COMMIT;
	END IF;	
END//

DELIMITER ;

CALL ACCOUNTS(1, 7, @tran_result);
SELECT @tran_result;

























DELIMITER //

-- field name in product table must have any not null value.
 
DROP TRIGGER IF EXISTS check_products_insert//
CREATE TRIGGER check_products_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  SET NEW.name = COALESCE(NEW.name, 'please fill this field!!!');
  SET NEW.description = COALESCE(NEW.description, 'please fill this field!!!');
END//

DELIMITER //
DROP TRIGGER IF EXISTS check_products_update//
CREATE TRIGGER check_products_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  SET NEW.name = COALESCE(NEW.name, OLD.name, 'please fill this field!!!');
  SET NEW.description = COALESCE(NEW.description, OLD.description, 'please fill this field!!!');
END//

DELIMITER ;
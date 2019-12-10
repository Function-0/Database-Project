---TESTING TRIGGERS---
---TESTING update_product_status_trg---
DECLARE
  lv_inventoryid inventory.inventoryid%TYPE := 1000000014;
  lv_productid product.productid%TYPE := 1000000006;
  lv_original_quantity inventory.quantity%TYPE;
  lv_new_quantity inventory.quantity%TYPE := 2;
  lv_original_product_status product.status%TYPE;
  lv_new_product_status product.status%TYPE;
BEGIN
  SELECT quantity
    INTO lv_original_quantity
    FROM inventory
    WHERE inventoryid = lv_inventoryid;
  SELECT status
    INTO lv_original_product_status
    FROM product
    WHERE productid = lv_productid;
  DBMS_OUTPUT.PUT_LINE('Product ID: ' || lv_productid);
  DBMS_OUTPUT.PUT_LINE('Inventory ID to remove stock from: ' || lv_inventoryid);
  DBMS_OUTPUT.PUT_LINE('Original Product Status: ' || lv_original_product_status);
  DBMS_OUTPUT.PUT_LINE('Original stock level of Inventory ID that corresponds to the Product ID: ' || lv_original_quantity);
  UPDATE inventory
    SET quantity = lv_new_quantity
    WHERE inventoryid = lv_inventoryid;
  SELECT quantity
    INTO lv_new_quantity
    FROM inventory
    WHERE inventoryid = lv_inventoryid;
  SELECT status
    INTO lv_new_product_status
    FROM product
    WHERE productid = lv_productid;
  DBMS_OUTPUT.PUT_LINE('New Product Status: ' || lv_new_product_status);
  DBMS_OUTPUT.PUT_LINE('New stock level of Inventory ID that corresponds to the Product ID: ' || lv_new_quantity);
  UPDATE inventory
    SET quantity = lv_original_quantity
    WHERE inventoryid = lv_inventoryid;
  SELECT quantity
    INTO lv_new_quantity
    FROM inventory
    WHERE inventoryid = lv_inventoryid;
  SELECT status
    INTO lv_new_product_status
    FROM product
    WHERE productid = lv_productid;
  DBMS_OUTPUT.PUT_LINE('Reverted Product Status: ' || lv_new_product_status);
  DBMS_OUTPUT.PUT_LINE('Reverted stock level of Inventory ID that corresponds to the Product ID: ' || lv_new_quantity);
END;
/
---TESTING update_stock_level_trg---
DECLARE
  lv_orderitemid orderitem.orderitemid%TYPE := 1000000000;
  lv_orderid orderitem.orderid%TYPE := 1000000000;
  lv_productid orderitem.productid%TYPE := 1000000000;
  lv_original_order_quantity orderitem.quantity%TYPE;
  lv_new_order_quantity orderitem.quantity%TYPE := 33;
  lv_original_product_quantity inventory.quantity%TYPE;
  lv_new_product_quantity inventory.quantity%TYPE;
BEGIN
  SELECT SUM(i.quantity) quantity
    INTO lv_original_product_quantity
    FROM inventory i JOIN warehouse w
    USING (inventoryid)
    WHERE inventoryid 
    IN (SELECT inventoryid
          FROM warehouse
          WHERE productid
          IN (SELECT productid
                FROM warehouse))
    GROUP BY w.productid
    HAVING w.productid = lv_productid;
  SELECT quantity
    INTO lv_original_order_quantity
    FROM orderitem
    WHERE orderitemid = lv_orderitemid;
  DBMS_OUTPUT.PUT_LINE('Orderitem ID: ' || lv_orderitemid);
  DBMS_OUTPUT.PUT_LINE('Order ID: ' || lv_orderid);
  DBMS_OUTPUT.PUT_LINE('Product ID: ' || lv_productid);
  DBMS_OUTPUT.PUT_LINE('Original order quantity: ' || lv_original_order_quantity);
  DBMS_OUTPUT.PUT_LINE('Original product quantity: ' || lv_original_product_quantity);
  UPDATE orderitem
    SET quantity = lv_new_order_quantity
    WHERE orderitemid = lv_orderitemid;
  SELECT SUM(i.quantity) quantity
    INTO lv_new_product_quantity
    FROM inventory i JOIN warehouse w
    USING (inventoryid)
    WHERE inventoryid 
    IN (SELECT inventoryid
          FROM warehouse
          WHERE productid
          IN (SELECT productid
                FROM warehouse))
    GROUP BY w.productid
    HAVING w.productid = lv_productid;
  SELECT quantity
    INTO lv_new_order_quantity
    FROM orderitem
    WHERE orderitemid = lv_orderitemid;
  DBMS_OUTPUT.PUT_LINE('New order quantity: ' || lv_new_order_quantity);
  DBMS_OUTPUT.PUT_LINE('New product quantity: ' || lv_new_product_quantity);
  UPDATE orderitem
    SET quantity = lv_original_order_quantity
    WHERE orderitemid = lv_orderitemid;
  SELECT SUM(i.quantity) quantity
    INTO lv_new_product_quantity
    FROM inventory i JOIN warehouse w
    USING (inventoryid)
    WHERE inventoryid 
    IN (SELECT inventoryid
          FROM warehouse
          WHERE productid
          IN (SELECT productid
                FROM warehouse))
    GROUP BY w.productid
    HAVING w.productid = lv_productid;
  SELECT quantity
    INTO lv_new_order_quantity
    FROM orderitem
    WHERE orderitemid = lv_orderitemid;
  DBMS_OUTPUT.PUT_LINE('Reverted order quantity: ' || lv_new_order_quantity);
  DBMS_OUTPUT.PUT_LINE('Reverted product quantity: ' || lv_new_product_quantity);
END;
/

---TESTING PROCEDURES---
---TESTING is_promo_code_valid_sp---
DECLARE
  lv_is_promo_code_valid BOOLEAN;
  lv_boolean_string VARCHAR2(10);
BEGIN
  is_promo_code_valid_sp('Headphones','TKi5WuTJKc', lv_is_promo_code_valid);
  IF (lv_is_promo_code_valid = TRUE) THEN
    lv_boolean_string := 'TRUE';
  ELSE
    lv_boolean_string := 'FALSE';
  END IF;
  DBMS_OUTPUT.PUT_LINE('Is Promo Valid?: ' || lv_boolean_string);
END;
/
---TESTING manual_discount_total_sp---
DECLARE
  lv_total NUMBER(10) := 643;
  lv_discount NUMBER(10) := 75;
  lv_final_total NUMBER(10);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Total without discount of ' || lv_discount || '% : ' || lv_total);
  manual_discount_total_sp(lv_total, lv_discount, lv_final_total);
  DBMS_OUTPUT.PUT_LINE('Total with discount of ' || lv_discount || '% : ' || lv_final_total);
END;
/

---TESTING FUNCTIONS---
---TESTING calculate_shipping_cost_sf---
DECLARE
  lv_total NUMBER(10) := 312;
  lv_shipping_cost NUMBER(10);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Total cost without shipping: ' || lv_total);
  lv_shipping_cost := calculate_shipping_cost_sf(lv_total);
  DBMS_OUTPUT.PUT_LINE('Shipping cost is: ' || lv_shipping_cost);
  lv_total := lv_total + lv_shipping_cost;
  DBMS_OUTPUT.PUT_LINE('Total cost with shipping: ' || lv_total);
END;
/
---TESTING calculate_order_total_sf
DECLARE
  lv_orderid orders.orderid%TYPE := 1000000001;
  lv_promocode promo.promocode%TYPE := 'TKi5WuTJKc';
  lv_promocode_uses promo.uses%TYPE;
  lv_productid product.productid%TYPE := 1000000004;
  lv_total NUMBER(10);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Order ID: ' || lv_orderid);
  DBMS_OUTPUT.PUT_LINE('Promo code: ' || lv_promocode);
  SELECT uses
    INTO lv_promocode_uses
    FROM promo
    WHERE promocode = lv_promocode;
  DBMS_OUTPUT.PUT_LINE('Promo code uses available before code is used: ' || lv_promocode_uses);
  DBMS_OUTPUT.PUT_LINE('Product ID to apply promo code: ' || lv_productid);
  lv_total := calculate_order_total_sf(lv_orderid, lv_promocode, lv_productid);
  DBMS_OUTPUT.PUT_LINE('Final cost of order, with shipping cost and promo discount: ' || lv_total);
  SELECT uses
    INTO lv_promocode_uses
    FROM promo
    WHERE promocode = lv_promocode;
  DBMS_OUTPUT.PUT_LINE('Promo code uses available after code was used: ' || lv_promocode_uses);
END;
/
SET SERVEROUTPUT ON;

---DROPPING EXISTING TABLES AND SEQUENCES---
DROP TABLE Address CASCADE CONSTRAINTS;
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE Inventory CASCADE CONSTRAINTS;
DROP TABLE OrderItem CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;
DROP TABLE Product CASCADE CONSTRAINTS;
DROP TABLE Promo CASCADE CONSTRAINTS;
DROP TABLE Review CASCADE CONSTRAINTS;
DROP TABLE Supplier CASCADE CONSTRAINTS;
DROP TABLE Warehouse CASCADE CONSTRAINTS;
DROP SEQUENCE addressid_seq;
DROP SEQUENCE customerid_seq;
DROP SEQUENCE inventoryid_seq;
DROP SEQUENCE orderid_seq;
DROP SEQUENCE orderitemid_seq;
DROP SEQUENCE productid_seq;
DROP SEQUENCE promoid_seq;
DROP SEQUENCE reviewid_seq;
DROP SEQUENCE supplierid_seq;
DROP SEQUENCE warehouseid_seq;

---CREATING TABLES AND SEQUENCES---
CREATE SEQUENCE addressid_seq START WITH 1000000000 INCREMENT BY 1;
CREATE SEQUENCE customerid_seq START WITH 1000000000 INCREMENT BY 1;
CREATE SEQUENCE inventoryid_seq START WITH 1000000000 INCREMENT BY 1;
CREATE SEQUENCE orderid_seq START WITH 1000000000 INCREMENT BY 1;
CREATE SEQUENCE orderitemid_seq START WITH 1000000000 INCREMENT BY 1;
CREATE SEQUENCE productid_seq START WITH 1000000000 INCREMENT BY 1;
CREATE SEQUENCE promoid_seq START WITH 1000000000 INCREMENT BY 1;
CREATE SEQUENCE reviewid_seq START WITH 1000000000 INCREMENT BY 1;
CREATE SEQUENCE supplierid_seq START WITH 1000000000 INCREMENT BY 1;
CREATE SEQUENCE warehouseid_seq START WITH 1000000000 INCREMENT BY 1;
CREATE TABLE Address (
  AddressId  number(10) NOT NULL, 
  CustomerId number(10) NOT NULL, 
  Address    varchar2(255), 
  City       varchar2(255), 
  State      varchar2(2), 
  Zip        varchar2(5), 
  PRIMARY KEY (AddressId), 
  CONSTRAINT address_zip_ck 
    CHECK (TRANSLATE(Zip, '123456789', '000000000') = '00000'), 
  CONSTRAINT address_state_ck 
    CHECK ((LENGTH(State) = 2) AND (State = UPPER(State))));
CREATE TABLE Customer (
  CustomerId       number(10) NOT NULL, 
  FirstName        varchar2(255), 
  LastName         varchar2(255), 
  Email            varchar2(255) NOT NULL, 
  Password         varchar2(255) NOT NULL, 
  SecurityQuestion varchar2(255) NOT NULL, 
  SecurityAnswer   varchar2(255) NOT NULL, 
  PRIMARY KEY (CustomerId));
CREATE TABLE Inventory (
  InventoryId      number(10) NOT NULL, 
  SupplierId       number(10) NOT NULL, 
  Quantity         number(10), 
  ShelvingLocation varchar2(9), 
  PRIMARY KEY (InventoryId), 
  CONSTRAINT inventory_shelvinglocation_ck 
    CHECK (TRANSLATE(ShelvingLocation, '123456789', '000000000') = 'Shelf 000'), 
  CONSTRAINT inventory_quantity_ck 
    CHECK (Quantity >= 0));
CREATE TABLE OrderItem (
  OrderItemId      number(10) NOT NULL, 
  OrderId          number(10) NOT NULL, 
  ProductId        number(10) NOT NULL, 
  Quantity         number(10) NOT NULL, 
  HistoricalRetail number(10, 2) NOT NULL, 
  PRIMARY KEY (OrderItemId), 
  CONSTRAINT orderitem_quantity_ck 
    CHECK (Quantity >= 1), 
  CONSTRAINT orderitem_historicalretail_ck 
    CHECK (HistoricalRetail >= 1));
CREATE TABLE Orders (
  OrderId     number(10) NOT NULL, 
  CustomerId  number(10) NOT NULL, 
  Status      varchar2(255) DEFAULT 'Inactive' NOT NULL, 
  PaymentType varchar2(255), 
  OrderDate   date DEFAULT SYSDATE, 
  ShipDate    date, 
  ShipStreet  varchar2(255), 
  ShipCity    varchar2(255), 
  ShipState   varchar2(2), 
  ShipZip     varchar2(5), 
  ShipCost    number(10, 2), 
  PRIMARY KEY (OrderId), 
  CONSTRAINT orders_shipdate_ck 
    CHECK (OrderDate <= ShipDate), 
  CONSTRAINT orders_paymenttype_ck 
    CHECK (PaymentType IN ('Debit', 'Credit', 'PayPal', 'Bitcoin')), 
  CONSTRAINT orders_status_ck 
    CHECK (Status IN ('Active', 'Inactive', 'Confirmed')), 
  CONSTRAINT orders_shipzip_ck 
    CHECK (TRANSLATE(ShipZip, '123456789', '000000000') = '00000'), 
  CONSTRAINT orders_shipcost_ck 
    CHECK (ShipCost >= 1), 
  CONSTRAINT orders_shipstate_ck 
    CHECK ((LENGTH(ShipState) = 2) AND (ShipState = UPPER(ShipState))));
CREATE TABLE Product (
  ProductId number(10) NOT NULL, 
  Title     varchar2(255), 
  Cost      number(10, 2), 
  Retail    number(10, 2), 
  Category  varchar2(255), 
  Summary   varchar2(255), 
  Status    varchar2(255), 
  PRIMARY KEY (ProductId), 
  CONSTRAINT product_retail_ck 
    CHECK (Retail >= 1), 
  CONSTRAINT product_cost_ck 
    CHECK (Cost >= 1), 
  CONSTRAINT product_status_ck 
    CHECK (Status IN ('High Stock Level', 'Average Stock Level', 'Low Stock Level', 'Limited Stock Level', 'Out of Stock')));
CREATE TABLE Promo (
  PromoId    number(10) NOT NULL, 
  Category   varchar2(255), 
  Discount   number(2), 
  Uses       number(5) DEFAULT 25, 
  PromoCode  varchar2(10) NOT NULL UNIQUE, 
  ActiveDate date, 
  ExpireDate date, 
  PRIMARY KEY (PromoId), 
  CONSTRAINT promo_expiredate_ck 
    CHECK (ActiveDate < ExpireDate), 
  CONSTRAINT promo_discount_ck 
    CHECK (Discount >= 1), 
  CONSTRAINT promo_uses_ck 
    CHECK (Uses >= 0));
CREATE TABLE Review (
  ReviewId   number(10) NOT NULL, 
  OrderId    number(10) NOT NULL, 
  CustomerId number(10) NOT NULL, 
  ProductId  number(10) NOT NULL, 
  Comments   varchar2(255) NOT NULL, 
  Rating     number(1) DEFAULT 5 NOT NULL, 
  PRIMARY KEY (ReviewId), 
  CONSTRAINT review_rating_ck 
    CHECK (Rating IN (1, 2, 3, 4, 5)));
CREATE TABLE Supplier (
  SupplierId number(10) NOT NULL, 
  Name       varchar2(255), 
  Email      varchar2(255), 
  Phone      varchar2(255), 
  PRIMARY KEY (SupplierId));
CREATE TABLE Warehouse (
  WarehouseId number(10) NOT NULL, 
  InventoryId number(10) NOT NULL, 
  ProductId   number(10) NOT NULL, 
  Name        varchar2(255), 
  Status      varchar2(255) DEFAULT 'Inactive' NOT NULL, 
  Address     varchar2(255), 
  City        varchar2(255), 
  State       varchar2(2), 
  Zip         varchar2(5), 
  PRIMARY KEY (WarehouseId, 
  InventoryId), 
  CONSTRAINT warehouse_state_ck 
    CHECK ((LENGTH(State) = 2) AND (State = UPPER(State))), 
  CONSTRAINT warehouse_status_ck 
    CHECK (Status IN ('Active', 'Inactive', 'Renovation', 'Repairs', 'Damaged')), 
  CONSTRAINT warehouse_zip_ck 
    CHECK (TRANSLATE(Zip, '123456789', '000000000') = '00000'));
CREATE INDEX Address_CustomerId 
  ON Address (CustomerId);
CREATE INDEX Address_Address 
  ON Address (Address);
CREATE INDEX Address_City 
  ON Address (City);
CREATE INDEX Address_State 
  ON Address (State);
CREATE INDEX Address_Zip 
  ON Address (Zip);
CREATE INDEX Customer_FirstName 
  ON Customer (FirstName);
CREATE INDEX Customer_LastName 
  ON Customer (LastName);
CREATE INDEX Inventory_SupplierId 
  ON Inventory (SupplierId);
CREATE INDEX OrderItem_OrderId 
  ON OrderItem (OrderId);
CREATE INDEX OrderItem_ProductId 
  ON OrderItem (ProductId);
CREATE INDEX Orders_CustomerId 
  ON Orders (CustomerId);
CREATE INDEX Promo_ActiveDate 
  ON Promo (ActiveDate);
CREATE INDEX Promo_ExpireDate 
  ON Promo (ExpireDate);
CREATE INDEX Review_OrderId 
  ON Review (OrderId);
CREATE INDEX Review_CustomerId 
  ON Review (CustomerId);
CREATE INDEX Review_ProductId 
  ON Review (ProductId);
CREATE INDEX Supplier_Name 
  ON Supplier (Name);
CREATE INDEX Warehouse_ProductId 
  ON Warehouse (ProductId);
CREATE INDEX Warehouse_Name 
  ON Warehouse (Name);
CREATE INDEX Warehouse_Address 
  ON Warehouse (Address);
CREATE INDEX Warehouse_City 
  ON Warehouse (City);
CREATE INDEX Warehouse_State 
  ON Warehouse (State);
CREATE INDEX Warehouse_Zip 
  ON Warehouse (Zip);

---CUSTOMER, ADDRESS TABLE DATA---
--Customer, Address 1
INSERT INTO Customer
  (CustomerId, 
  FirstName, 
  LastName, 
  Email, 
  Password, 
  SecurityQuestion, 
  SecurityAnswer) 
VALUES 
  (customerid_seq.NEXTVAL, 
  'Leila', 
  'Kane', 
  'rin6fokzro@classesmail.com', 
  STANDARD_HASH('yi4CheJah5g'), 
  'What is your cat''s name?', 
  'Hubi');
INSERT INTO Address
  (AddressId, 
  CustomerId, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (addressid_seq.NEXTVAL, 
  customerid_seq.CURRVAL, 
  '4611 Mapleview Drive', 
  'St Petersburg', 
  'FL', 
  '33701');
--Customer, Address 2
INSERT INTO Customer
  (CustomerId, 
  FirstName, 
  LastName, 
  Email, 
  Password, 
  SecurityQuestion, 
  SecurityAnswer) 
VALUES 
  (customerid_seq.NEXTVAL, 
  'Kenton', 
  'Hamann', 
  '94p8hm03sni@groupbuff.com', 
  STANDARD_HASH('reel5XahR'), 
  'What is your mother''s maiden name?', 
  'xristidi');
INSERT INTO Address
  (AddressId, 
  CustomerId, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (addressid_seq.NEXTVAL, 
  customerid_seq.CURRVAL, 
  '282 Bottom Lane', 
  'Tonawanda', 
  'NY', 
  '14150');
--Customer, Address 3
INSERT INTO Customer
  (CustomerId, 
  FirstName, 
  LastName, 
  Email, 
  Password, 
  SecurityQuestion, 
  SecurityAnswer) 
VALUES 
  (customerid_seq.NEXTVAL, 
  'Carlos', 
  'Quinn', 
  '0mv5g1ibwj1p@groupbuff.com', 
  STANDARD_HASH('azoo3oaJie'), 
  'What is your dog''s name?', 
  'zoda');
INSERT INTO Address
  (AddressId, 
  CustomerId, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (addressid_seq.NEXTVAL, 
  customerid_seq.CURRVAL, 
  '893 Thunder Road', 
  'San Francisco', 
  'CA', 
  '94111');
--Customer, Address 4
INSERT INTO Customer
  (CustomerId, 
  FirstName, 
  LastName, 
  Email, 
  Password, 
  SecurityQuestion, 
  SecurityAnswer) 
VALUES 
  (customerid_seq.NEXTVAL, 
  'Amy', 
  'Wright', 
  '2ana03c06tm@classesmail.com', 
  STANDARD_HASH('ieth9RahH5Th'), 
  'What is the last 4 of your SSN?', 
  '7422');
INSERT INTO Address
  (AddressId, 
  CustomerId, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (addressid_seq.NEXTVAL, 
  customerid_seq.CURRVAL, 
  '4770 Jefferson Street', 
  'Norfolk', 
  'VA', 
  '23510');
--Customer, Address 5
INSERT INTO Customer
  (CustomerId, 
  FirstName, 
  LastName, 
  Email, 
  Password, 
  SecurityQuestion, 
  SecurityAnswer) 
VALUES 
  (customerid_seq.NEXTVAL, 
  'Michael', 
  'Myers', 
  'qlw42gwkgkr@powerencry.com', 
  STANDARD_HASH('uu1een4Ohg'), 
  'What is your mother''s maiden name?', 
  'lacano');
INSERT INTO Address
  (AddressId, 
  CustomerId, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (addressid_seq.NEXTVAL, 
  customerid_seq.CURRVAL, 
  '2543 Vernon Street', 
  'La Mesa', 
  'CA', 
  '91941');
--Customer, Address 6
INSERT INTO Customer
  (CustomerId, 
  FirstName, 
  LastName, 
  Email, 
  Password, 
  SecurityQuestion, 
  SecurityAnswer) 
VALUES 
  (customerid_seq.NEXTVAL, 
  'Dominick', 
  'Salvador', 
  'vsrucy1qp2@powerencry.com', 
  STANDARD_HASH('lei2Sojai'), 
  'What is your dog''s name?', 
  'fletch');
INSERT INTO Address
  (AddressId, 
  CustomerId, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (addressid_seq.NEXTVAL, 
  customerid_seq.CURRVAL, 
  '3609 Linden Avenue', 
  'Buffalo', 
  'ND', 
  '58011');
--Customer, Address 7
INSERT INTO Customer
  (CustomerId, 
  FirstName, 
  LastName, 
  Email, 
  Password, 
  SecurityQuestion, 
  SecurityAnswer) 
VALUES 
  (customerid_seq.NEXTVAL, 
  'Kathryn', 
  'Nakano', 
  '0n0u1esukoaf@classesmail.com', 
  STANDARD_HASH('vohGhieSo8'), 
  'What is your mother''s maiden name?', 
  'tallec');
INSERT INTO Address
  (AddressId, 
  CustomerId, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (addressid_seq.NEXTVAL, 
  customerid_seq.CURRVAL, 
  '4557 Rafe Lane', 
  'Grand Junction', 
  'MS', 
  '38039');
--Customer, Address 8
INSERT INTO Customer
  (CustomerId, 
  FirstName, 
  LastName, 
  Email, 
  Password, 
  SecurityQuestion, 
  SecurityAnswer) 
VALUES 
  (customerid_seq.NEXTVAL, 
  'Ellis', 
  'Green', 
  'ok765oacfi@groupbuff.com', 
  STANDARD_HASH('kaiyeic6aG'), 
  'What is your mother''s maiden name?', 
  'bunning');
INSERT INTO Address
  (AddressId, 
  CustomerId, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (addressid_seq.NEXTVAL, 
  customerid_seq.CURRVAL, 
  '1181 Burke Street', 
  'Belmont', 
  'LA', 
  '71406');
--Customer, Address 9
INSERT INTO Customer
  (CustomerId, 
  FirstName, 
  LastName, 
  Email, 
  Password, 
  SecurityQuestion, 
  SecurityAnswer) 
VALUES 
  (customerid_seq.NEXTVAL, 
  'Jesse', 
  'Harpster', 
  'dmj680i3c2r@fakemailgenerator.net', 
  STANDARD_HASH('ooB1seihooK'), 
  'What is your mother''s maiden name?', 
  'eeeeeeeeeeee');
INSERT INTO Address
  (AddressId, 
  CustomerId, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (addressid_seq.NEXTVAL, 
  customerid_seq.CURRVAL, 
  '4415 Chenoweth Drive', 
  'Cookeville', 
  'TN', 
  '38501');
--Customer, Address 10
INSERT INTO Customer
  (CustomerId, 
  FirstName, 
  LastName, 
  Email, 
  Password, 
  SecurityQuestion, 
  SecurityAnswer) 
VALUES 
  (customerid_seq.NEXTVAL, 
  'Dian', 
  'Young', 
  'km83guq0fkd@groupbuff.com', 
  STANDARD_HASH('ohdeeN3eigh'), 
  'What is the last 4 of your SSN?', 
  'pray');
INSERT INTO Address
  (AddressId, 
  CustomerId, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (addressid_seq.NEXTVAL, 
  customerid_seq.CURRVAL, 
  '1597 Del Dew Drive', 
  'Oakland', 
  'NJ', 
  '07436');

---SUPPLIER, INVENTORY, PRODUCT, WAREHOUSE, PROMO DATA---
--Supplier, Inventory, Product, Warehouse, Promo 1
INSERT INTO Supplier
  (SupplierId, 
  Name, 
  Email, 
  Phone) 
VALUES 
  (supplierid_seq.NEXTVAL, 
  'Frontline Inc.', 
  '3udlmngk2dl@groupbuff.com', 
  '469-698-2605');
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  supplierid_seq.CURRVAL, 
  34, 
  'Shelf 017');
INSERT INTO Product
  (ProductId, 
  Title, 
  Cost, 
  Retail, 
  Category, 
  Summary, 
  Status) 
VALUES 
  (productid_seq.NEXTVAL, 
  'Lenovo Thinkpad T440 Notebook 14" Intel i5-4200U 8GB DDR3 128GB SSD Win 10 Pro 64', 
  159.00, 
  369.00, 
  'Notebooks', 
  'The ThinkPad T440 14" IPS laptop starts at just 4 lbs, and with a 0.8" profile at its thickest point, is mobile as well as powerful.', 
  'High Stock Level');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  productid_seq.CURRVAL, 
  'Warehouse Alpha', 
  'Active', 
  '4605 Thorn Street', 
  'Cheyenne', 
  'WY', 
  '82003');
INSERT INTO Promo
  (PromoId, 
  Category, 
  Discount, 
  Uses, 
  PromoCode, 
  ActiveDate, 
  ExpireDate) 
VALUES 
  (promoid_seq.NEXTVAL, 
  'Notebooks', 
  20, 
  13, 
  'AclnsKi6C0', 
  TO_DATE('2019-11-30', 'YYYY-MM-DD'), 
  TO_DATE('2019-11-30', 'YYYY-MM-DD') + 7);
--Supplier, Inventory, Product, Warehouse, Promo 2
INSERT INTO Supplier
  (SupplierId, 
  Name, 
  Email, 
  Phone) 
VALUES 
  (supplierid_seq.NEXTVAL, 
  'Alpha Innotech', 
  '8fycdixp62g@meantinc.com', 
  '727-569-4651');
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  supplierid_seq.CURRVAL, 
  20, 
  'Shelf 155');
INSERT INTO Product
  (ProductId, 
  Title, 
  Cost, 
  Retail, 
  Category, 
  Summary, 
  Status) 
VALUES 
  (productid_seq.NEXTVAL, 
  'HP ProBook 450 G6 Business Notebook Intel Core i5-8265U, 8GB DDR4, 256GB SSD, Intel UHD Graphics 620 Win 10 Pro', 
  701.00, 
  1179.99, 
  'Notebooks', 
  'Full-featured, thin, and light, the HP ProBook 450 lets professionals stay productive in the office and on the go.', 
  'High Stock Level');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.CURRVAL, 
  inventoryid_seq.CURRVAL, 
  productid_seq.CURRVAL, 
  'Warehouse Alpha', 
  'Active', 
  '4605 Thorn Street', 
  'Cheyenne', 
  'WY', 
  '82003');
INSERT INTO Promo
  (PromoId, 
  Category, 
  Discount, 
  Uses, 
  PromoCode, 
  ActiveDate, 
  ExpireDate) 
VALUES 
  (promoid_seq.NEXTVAL, 
  'Notebooks', 
  17, 
  1, 
  'SgRM1BUZTV', 
  TO_DATE('2019-12-01', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-01', 'YYYY-MM-DD') + 19);
--Supplier, Inventory, Product, Warehouse, Promo 3
INSERT INTO Supplier
  (SupplierId, 
  Name, 
  Email, 
  Phone) 
VALUES 
  (supplierid_seq.NEXTVAL, 
  'Hess Corporation', 
  'ekr0v44yuqv@meantinc.com', 
  '504-382-5302');
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  supplierid_seq.CURRVAL, 
  15, 
  'Shelf 964');
INSERT INTO Product
  (ProductId, 
  Title, 
  Cost, 
  Retail, 
  Category, 
  Summary, 
  Status) 
VALUES 
  (productid_seq.NEXTVAL, 
  'ASUS VP249HE Eye Care Monitor - 23.8 inch, Full HD, IPS, Frameless, Flicker Free, Blue Light Filter', 
  50.00, 
  149.99, 
  'Monitors', 
  'VP249HE 24" Full HD monitor with 100,000,000:1 high contrast ratio, ASUS-exclusive Splendid and VividPixel technologies are optimized for the finest image and color quality.', 
  'Average Stock Level');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.CURRVAL, 
  inventoryid_seq.CURRVAL, 
  productid_seq.CURRVAL, 
  'Warehouse Alpha', 
  'Active', 
  '4605 Thorn Street', 
  'Cheyenne', 
  'WY', 
  '82003');
INSERT INTO Promo
  (PromoId, 
  Category, 
  Discount, 
  Uses, 
  PromoCode, 
  ActiveDate, 
  ExpireDate) 
VALUES 
  (promoid_seq.NEXTVAL, 
  'Monitors', 
  5, 
  0, 
  'aoBP2K6xYu', 
  TO_DATE('2019-12-01', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-01', 'YYYY-MM-DD') + 5);
--Supplier, Inventory, Product, Warehouse, Promo 4
INSERT INTO Supplier
  (SupplierId, 
  Name, 
  Email, 
  Phone) 
VALUES 
  (supplierid_seq.NEXTVAL, 
  'Iron Mountain', 
  'h3ld2doe22g@powerencry.com', 
  '815-653-0623');
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  supplierid_seq.CURRVAL, 
  19, 
  'Shelf 269');
INSERT INTO Product
  (ProductId, 
  Title, 
  Cost, 
  Retail, 
  Category, 
  Summary, 
  Status) 
VALUES 
  (productid_seq.NEXTVAL, 
  'MSI Optix G24C 24" VA Curved FHD FreeSync LED Monitor I1920 x 1080, 144Hz, 1ms I HDMI, DVI, DisplayPort', 
  203.00, 
  269.99, 
  'Monitors', 
  'Optix G24C uses high quality Samsung curved panel. With lots of fantasy feature, Optix can help you have the better performance in the game.', 
  'Average Stock Level');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  productid_seq.CURRVAL, 
  'Warehouse Omega', 
  'Renovation', 
  '2309 West Fork Drive', 
  'Plantation', 
  'FL', 
  '33324');
INSERT INTO Promo
  (PromoId, 
  Category, 
  Discount, 
  Uses, 
  PromoCode, 
  ActiveDate, 
  ExpireDate) 
VALUES 
  (promoid_seq.NEXTVAL, 
  'Monitors', 
  20, 
  5, 
  'wzcoomzNxG', 
  TO_DATE('2019-12-03', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-03', 'YYYY-MM-DD') + 22);
--Supplier, Inventory, Product, Warehouse, Promo 5
INSERT INTO Supplier
  (SupplierId, 
  Name, 
  Email, 
  Phone) 
VALUES 
  (supplierid_seq.NEXTVAL, 
  'Imaxio', 
  '2mcaemj0tqy@powerencry.com', 
  '585-436-5058');
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  supplierid_seq.CURRVAL, 
  11, 
  'Shelf 277');
INSERT INTO Product
  (ProductId, 
  Title, 
  Cost, 
  Retail, 
  Category, 
  Summary, 
  Status) 
VALUES 
  (productid_seq.NEXTVAL, 
  'Jlab Audio - JBuds Air True Wireless (Black) - Charging Case', 
  43.00, 
  69.99, 
  'Headphones', 
  'Grab your JBuds Air True Wireless Earbuds as you head to work, get to the gym, or jump on an airplane.', 
  'Average Stock Level');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.CURRVAL, 
  inventoryid_seq.CURRVAL, 
  productid_seq.CURRVAL, 
  'Warehouse Omega', 
  'Renovation', 
  '2309 West Fork Drive', 
  'Plantation', 
  'FL', 
  '33324');
INSERT INTO Promo
  (PromoId, 
  Category, 
  Discount, 
  Uses, 
  PromoCode, 
  ActiveDate, 
  ExpireDate) 
VALUES 
  (promoid_seq.NEXTVAL, 
  'Headphones', 
  10, 
  14, 
  'TKi5WuTJKc', 
  TO_DATE('2019-12-03', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-03', 'YYYY-MM-DD') + 24);
--Supplier, Inventory, Product, Warehouse, Promo 6
INSERT INTO Supplier
  (SupplierId, 
  Name, 
  Email, 
  Phone) 
VALUES 
  (supplierid_seq.NEXTVAL, 
  'Harris Connect Inc.', 
  'wwau2qxz89e@meantinc.com', 
  '631-564-7947');
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  supplierid_seq.CURRVAL, 
  17, 
  'Shelf 219');
INSERT INTO Product
  (ProductId, 
  Title, 
  Cost, 
  Retail, 
  Category, 
  Summary, 
  Status) 
VALUES 
  (productid_seq.NEXTVAL, 
  'Sony WI-C310 Black - Earphones with mic - in-ear - Bluetooth', 
  12.00, 
  49.99, 
  'Headphones', 
  'Comfortable, versatile and practical, the WI-C310 wireless in-ear headphones will fit seamlessly and stylishly into your life.', 
  'Average Stock Level');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.CURRVAL, 
  inventoryid_seq.CURRVAL, 
  productid_seq.CURRVAL, 
  'Warehouse Omega', 
  'Renovation', 
  '2309 West Fork Drive', 
  'Plantation', 
  'FL', 
  '33324');
INSERT INTO Promo
  (PromoId, 
  Category, 
  Discount, 
  Uses, 
  PromoCode, 
  ActiveDate, 
  ExpireDate) 
VALUES 
  (promoid_seq.NEXTVAL, 
  'Headphones', 
  22, 
  25, 
  'mQza9BqwZu', 
  TO_DATE('2019-12-03', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-03', 'YYYY-MM-DD') + 16);
--Supplier, Inventory, Product, Warehouse, Promo 7
INSERT INTO Supplier
  (SupplierId, 
  Name, 
  Email, 
  Phone) 
VALUES 
  (supplierid_seq.NEXTVAL, 
  'Best Software', 
  'i1eoncxsvv@powerencry.com', 
  '336-488-9894');
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  supplierid_seq.CURRVAL, 
  4, 
  'Shelf 529');
INSERT INTO Product
  (ProductId, 
  Title, 
  Cost, 
  Retail, 
  Category, 
  Summary, 
  Status) 
VALUES 
  (productid_seq.NEXTVAL, 
  'Logitech G920 Driving Force Racing Wheel - Xbox One and PC (941-000121)', 
  100.00, 
  299.00, 
  'PC Gaming', 
  'Driving Force is designed for the latest Xbox One console racing game titles.', 
  'Low Stock Level');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  productid_seq.CURRVAL, 
  'Warehouse Mu', 
  'Repairs', 
  '2149 Lucky Duck Drive', 
  'Pittsburgh', 
  'PA', 
  '15222');
INSERT INTO Promo
  (PromoId, 
  Category, 
  Discount, 
  Uses, 
  PromoCode, 
  ActiveDate, 
  ExpireDate) 
VALUES 
  (promoid_seq.NEXTVAL, 
  'PC Gaming', 
  33, 
  21, 
  'DFGsgZT1Mg', 
  TO_DATE('2019-12-04', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-04', 'YYYY-MM-DD') + 30);
--Supplier, Inventory, Product, Warehouse, Promo 8
INSERT INTO Supplier
  (SupplierId, 
  Name, 
  Email, 
  Phone) 
VALUES 
  (supplierid_seq.NEXTVAL, 
  'Dot Hill Systems', 
  'eiv8g7rxal@classesmail.com', 
  '318-339-7003');
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  supplierid_seq.CURRVAL, 
  10, 
  'Shelf 044');
INSERT INTO Product
  (ProductId, 
  Title, 
  Cost, 
  Retail, 
  Category, 
  Summary, 
  Status) 
VALUES 
  (productid_seq.NEXTVAL, 
  'Kinesis Advantage2 Contoured Linear Force Keyboard for PC/Mac, Black, USB (KB600LF)', 
  308.00, 
  529.99, 
  'Keyboards', 
  'To encourage proper typing form, the Advantage2 features an optional electronic "click" that sounds right when a key press is registered.', 
  'Low Stock Level');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.CURRVAL, 
  inventoryid_seq.CURRVAL, 
  productid_seq.CURRVAL, 
  'Warehouse Mu', 
  'Repairs', 
  '2149 Lucky Duck Drive', 
  'Pittsburgh', 
  'PA', 
  '15222');
INSERT INTO Promo
  (PromoId, 
  Category, 
  Discount, 
  Uses, 
  PromoCode, 
  ActiveDate, 
  ExpireDate) 
VALUES 
  (promoid_seq.NEXTVAL, 
  'Keyboards', 
  46, 
  14, 
  'PDWQ19zfm6', 
  TO_DATE('2019-12-04', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-04', 'YYYY-MM-DD') + 22);
--Supplier, Inventory, Product, Warehouse, Promo 9
INSERT INTO Supplier
  (SupplierId, 
  Name, 
  Email, 
  Phone) 
VALUES 
  (supplierid_seq.NEXTVAL, 
  'Drew Scientific', 
  'styddyz1or@fakemailgenerator.net', 
  '207-493-7189');
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  supplierid_seq.CURRVAL, 
  1, 
  'Shelf 551');
INSERT INTO Product
  (ProductId, 
  Title, 
  Cost, 
  Retail, 
  Category, 
  Summary, 
  Status) 
VALUES 
  (productid_seq.NEXTVAL, 
  'SAMSUNG 970 EVO Plus M.2 NVMe PCI-E 500GB Solid State Drive, Read:3,500 MB/s, Write:3,300 MB/s (MZ-V7S500B/AM)', 
  35.00, 
  129.99, 
  'Solid State Drives (SSD)', 
  'Faster than the 970 EVO, the 970 EVO Plus is powered by the latest V-NAND technology and firmware optimization.', 
  'Limited Stock Level');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.CURRVAL, 
  inventoryid_seq.CURRVAL, 
  productid_seq.CURRVAL, 
  'Warehouse Mu', 
  'Repairs', 
  '2149 Lucky Duck Drive', 
  'Pittsburgh', 
  'PA', 
  '15222');
INSERT INTO Promo
  (PromoId, 
  Category, 
  Discount, 
  Uses, 
  PromoCode, 
  ActiveDate, 
  ExpireDate) 
VALUES 
  (promoid_seq.NEXTVAL, 
  'Solid State Drives (SSD)', 
  22, 
  13, 
  'Gk6uf2NCG1', 
  TO_DATE('2019-12-04', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-04', 'YYYY-MM-DD') + 14);
--Supplier, Inventory, Product, Warehouse, Promo 10
INSERT INTO Supplier
  (SupplierId, 
  Name, 
  Email, 
  Phone) 
VALUES 
  (supplierid_seq.NEXTVAL, 
  'Insight Public Sector', 
  'qd5bom67mr@classesmail.com', 
  '608-388-2984');
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  supplierid_seq.CURRVAL, 
  0, 
  'Shelf 281');
INSERT INTO Product
  (ProductId, 
  Title, 
  Cost, 
  Retail, 
  Category, 
  Summary, 
  Status) 
VALUES 
  (productid_seq.NEXTVAL, 
  'Cables To Go MTP 10Gb 50/125 OM3 Multimode PVC Fiber Optic Cable - Aqua 30m (31422)', 
  398.00, 
  803.99, 
  'Cables', 
  'Make MTP/MPO your choice for high density fiber networks; it''s specifically designed for fast ethernet, fiber channel, ATM and gigabit ethernet applications.', 
  'Out of Stock');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.CURRVAL, 
  inventoryid_seq.CURRVAL, 
  productid_seq.CURRVAL, 
  'Warehouse Mu', 
  'Repairs', 
  '2149 Lucky Duck Drive', 
  'Pittsburgh', 
  'PA', 
  '15222');
INSERT INTO Promo
  (PromoId, 
  Category, 
  Discount, 
  Uses, 
  PromoCode, 
  ActiveDate, 
  ExpireDate) 
VALUES 
  (promoid_seq.NEXTVAL, 
  'Cables', 
  42, 
  3, 
  'DDOFp0WBPC', 
  TO_DATE('2019-12-05', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-05', 'YYYY-MM-DD') + 1);

---ORDERS, ORDERITEM, REVIEW DATA---
--Orders, OrderItem, Review 1
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1000000000, 
  'Confirmed', 
  'Debit', 
  TO_DATE('2019-11-30', 'YYYY-MM-DD'), 
  TO_DATE('2019-11-30', 'YYYY-MM-DD') + 11, 
  '4611 Mapleview Drive', 
  'St Petersburg', 
  'FL', 
  '33701', 
  NULL);
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000000, 
  3, 
  369.00);
INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000000, 
  1000000000, 
  'Lenovo Thinkpad T440 Notebook 14" has really helped our business.', 
  5);
--Orders, OrderItem, Review 2
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1000000001, 
  'Confirmed', 
  'Debit', 
  TO_DATE('2019-11-30', 'YYYY-MM-DD'), 
  TO_DATE('2019-11-30', 'YYYY-MM-DD') + 6, 
  '282 Bottom Lane', 
  'Tonawanda', 
  'NY', 
  '14150', 
  NULL);
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000001, 
  2, 
  1179.99);
INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000001, 
  1000000001, 
  'I can''t say enough about HP ProBook 450 G6 Business Notebook. Not able to tell you how happy I am with HP ProBook 450 G6 Business Notebook. I use HP ProBook 450 G6 Business Notebook often. It''s really wonderful.', 
  5);
--Orders, OrderItem, Review 3
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1000000002, 
  'Confirmed', 
  'Credit', 
  TO_DATE('2019-12-01', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-01', 'YYYY-MM-DD') + 24, 
  '893 Thunder Road', 
  'San Francisco', 
  'CA', 
  '94111', 
  NULL);
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000002, 
  4, 
  149.99);
INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000002, 
  1000000002, 
  'I would like to personally thank you for your outstanding product. Great job, I will definitely be ordering again!', 
  5);
--Orders, OrderItem, Review 4
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1000000003, 
  'Confirmed', 
  'Credit', 
  TO_DATE('2019-12-02', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-02', 'YYYY-MM-DD') + 17, 
  '4770 Jefferson Street', 
  'Norfolk', 
  'VA', 
  '23510', 
  NULL);
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000003, 
  1, 
  269.99);
INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000003, 
  1000000003, 
  'MSI Optix G24C 24" VA Curved FHD FreeSync LED Monitor is great. I am so pleased with this product. We''re loving it.', 
  4);
--Orders, OrderItem, Review 5
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1000000004, 
  'Confirmed', 
  'Credit', 
  TO_DATE('2019-12-03', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-03', 'YYYY-MM-DD') + 26, 
  '2543 Vernon Street', 
  'La Mesa', 
  'CA', 
  '91941', 
  NULL);
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000004, 
  5, 
  69.99);
INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000004, 
  1000000004, 
  'It''s just amazing. It really saves me time and effort. JBuds Air True Wireless (Black) is exactly what our business has been lacking.',  
  4);
--Orders, OrderItem, Review 6
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1000000005, 
  'Confirmed', 
  'Credit', 
  TO_DATE('2019-12-03', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-03', 'YYYY-MM-DD') + 14, 
  '3609 Linden Avenue', 
  'Buffalo', 
  'ND', 
  '58011', 
  NULL);
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000005, 
  2, 
  49.99);
INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000005, 
  1000000005, 
  'I would gladly pay over 600 dollars for Sony WI-C310 Black - Earphones. I will refer everyone I know.', 
  4);
--Orders, OrderItem, Review 7
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1000000006, 
  'Confirmed', 
  'Credit', 
  TO_DATE('2019-12-03', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-03', 'YYYY-MM-DD') + 4, 
  '4557 Rafe Lane', 
  'Grand Junction', 
  'MS', 
  '38039', 
  NULL);
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000006, 
  5, 
  299.00);
INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000006, 
  1000000006, 
  'I wish I would have thought of it first. You guys rock!', 
  4);
--Orders, OrderItem, Review 8
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1000000007, 
  'Confirmed', 
  'PayPal', 
  TO_DATE('2019-12-04', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-04', 'YYYY-MM-DD') + 10, 
  '1181 Burke Street', 
  'Belmont', 
  'LA', 
  '71406', 
  NULL);
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000007, 
  3, 
  529.99);
INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000007, 
  1000000007, 
  'If you aren''t sure, don''t always go for Kinesis Advantage2 Contoured Linear Force Keyboard.', 
  3);
--Orders, OrderItem, Review 9
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1000000008, 
  'Confirmed', 
  'PayPal', 
  TO_DATE('2019-12-04', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-04', 'YYYY-MM-DD') + 7, 
  '4415 Chenoweth Drive', 
  'Cookeville', 
  'TN', 
  '38501', 
  NULL);
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000008, 
  4, 
  129.99);
INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000008, 
  1000000008, 
  'I should not have bought the SAMSUNG 970 EVO Plus M.2 NVMe PCI-E 500GB Solid State Drive. There are better products out there.', 
  2);
--Orders, OrderItem, Review 10
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1000000009, 
  'Confirmed', 
  'Bitcoin', 
  TO_DATE('2019-12-05', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-05', 'YYYY-MM-DD') + 14, 
  '1597 Del Dew Drive', 
  'Oakland', 
  'NJ', 
  '07436', 
  NULL);
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000009, 
  1, 
  803.99);
INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000000009, 
  1000000009, 
  'Don''t buy this.', 
  1);

---ADDING MORE INVENTORY DATA---
--Inventory 1
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  1000000009, 
  0, 
  'Shelf 797');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  1000000009, 
  'Warehouse Alpha', 
  'Active', 
  '4605 Thorn Street', 
  'Cheyenne', 
  'WY', 
  '82003');
--Inventory 2
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  1000000009, 
  0, 
  'Shelf 267');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  1000000009, 
  'Warehouse Alpha', 
  'Active', 
  '4605 Thorn Street', 
  'Cheyenne', 
  'WY', 
  '82003');
--Inventory 3
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  1000000008, 
  0, 
  'Shelf 739');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  1000000008, 
  'Warehouse Alpha', 
  'Active', 
  '4605 Thorn Street', 
  'Cheyenne', 
  'WY', 
  '82003');
--Inventory 4
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  1000000008, 
  4, 
  'Shelf 536');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  1000000008, 
  'Warehouse Omega', 
  'Renovation', 
  '2309 West Fork Drive', 
  'Plantation', 
  'FL', 
  '33324');
--Inventory 5
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  1000000006, 
  11, 
  'Shelf 400');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  1000000006, 
  'Warehouse Omega', 
  'Renovation', 
  '2309 West Fork Drive', 
  'Plantation', 
  'FL', 
  '33324');
--Inventory 6
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  1000000007, 
  17, 
  'Shelf 363');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  1000000007, 
  'Warehouse Omega', 
  'Renovation', 
  '2309 West Fork Drive', 
  'Plantation', 
  'FL', 
  '33324');
--Inventory 7
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  1000000007, 
  0, 
  'Shelf 210');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  1000000007, 
  'Warehouse Mu', 
  'Repairs', 
  '2149 Lucky Duck Drive', 
  'Pittsburgh', 
  'PA', 
  '15222');
--Inventory 8
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  1000000002, 
  29, 
  'Shelf 725');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  1000000002, 
  'Warehouse Mu', 
  'Repairs', 
  '2149 Lucky Duck Drive', 
  'Pittsburgh', 
  'PA', 
  '15222');
--Inventory 9
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  1000000004, 
  21, 
  'Shelf 245');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  1000000004, 
  'Warehouse Mu', 
  'Repairs', 
  '2149 Lucky Duck Drive', 
  'Pittsburgh', 
  'PA', 
  '15222');
--Inventory 10
INSERT INTO Inventory
  (InventoryId, 
  SupplierId, 
  Quantity, 
  ShelvingLocation) 
VALUES 
  (inventoryid_seq.NEXTVAL, 
  1000000000, 
  12, 
  'Shelf 707');
INSERT INTO Warehouse
  (WarehouseId, 
  InventoryId, 
  ProductId, 
  Name, 
  Status, 
  Address, 
  City, 
  State, 
  Zip) 
VALUES 
  (warehouseid_seq.NEXTVAL, 
  inventoryid_seq.CURRVAL, 
  1000000000, 
  'Warehouse Mu', 
  'Repairs', 
  '2149 Lucky Duck Drive', 
  'Pittsburgh', 
  'PA', 
  '15222');

---ADDING MORE ORDERITEM DATA---
--OrderItem 1
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  1000000003, 
  1000000005, 
  1, 
  49.99);
--OrderItem 2
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  1000000009, 
  1000000005, 
  1, 
  49.99);
--OrderItem 3
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail)   
VALUES 
  (orderitemid_seq.NEXTVAL, 
  1000000005, 
  1000000004, 
  1, 
  69.99);
--OrderItem 4
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail)   
VALUES 
  (orderitemid_seq.NEXTVAL, 
  1000000005, 
  1000000004, 
  1, 
  69.99);
--OrderItem 5
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail)   
VALUES 
  (orderitemid_seq.NEXTVAL, 
  1000000001, 
  1000000004, 
  1, 
  69.99);
--OrderItem 6
INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  HistoricalRetail)   
VALUES 
  (orderitemid_seq.NEXTVAL, 
  1000000001, 
  1000000005, 
  1, 
  49.99);

---TRIGGERS---
CREATE OR REPLACE TRIGGER update_product_status_trg
  FOR UPDATE OR INSERT ON inventory
  COMPOUND TRIGGER
  CURSOR quantity_cur IS
    SELECT inventoryid, quantity
    FROM inventory;
  TYPE type_quantity IS RECORD(
    inventoryid inventory.inventoryid%TYPE,
    quantity inventory.quantity%TYPE
    );
  TYPE type_quantity_list IS TABLE OF type_quantity
    INDEX BY BINARY_INTEGER;
  quantity_list type_quantity_list;
  TYPE type_inventoryids IS TABLE OF inventory.inventoryid%TYPE
    INDEX BY BINARY_INTEGER;
  curr_rec NUMBER(10) := 0;
BEFORE STATEMENT IS
  BEGIN
  FOR rec in quantity_cur LOOP
    curr_rec := curr_rec + 1;
    quantity_list(curr_rec).inventoryid := rec.inventoryid;
    quantity_list(curr_rec).quantity := rec.quantity;
  END LOOP;
END BEFORE STATEMENT;
BEFORE EACH ROW IS
  lv_stock_amount inventory.quantity%TYPE := 0;
  lv_stock_level product.status%TYPE;
  lv_productid product.productid%TYPE;
  lv_product_inventoryids_list type_inventoryids;
BEGIN
--Get productid that inventoryid matches
SELECT productid
  INTO lv_productid
  FROM warehouse
  WHERE inventoryid = :NEW.inventoryid;
SELECT inventoryid BULK COLLECT
  INTO lv_product_inventoryids_list
  FROM warehouse
  WHERE productid = lv_productid;
FOR curr_rec IN 1..quantity_list.COUNT LOOP
  IF (quantity_list(curr_rec).inventoryid = :NEW.inventoryid) THEN
    quantity_list(curr_rec).quantity := :NEW.quantity;
  EXIT;
  END IF;
END LOOP;
FOR curr_rec_1 IN 1..lv_product_inventoryids_list.COUNT LOOP
  FOR curr_rec_2 IN 1..quantity_list.COUNT LOOP
    IF (quantity_list(curr_rec_2).inventoryid
          = lv_product_inventoryids_list(curr_rec_1)) THEN
    lv_stock_amount := lv_stock_amount
                         + quantity_list(curr_rec_2).quantity;
    END IF;
  END LOOP;
END LOOP;
  IF (lv_stock_amount > 20) THEN
    lv_stock_level := 'High Stock Level';
  ELSIF ((lv_stock_amount >= 10) AND (lv_stock_amount <= 20)) THEN
    lv_stock_level := 'Average Stock Level';
  ELSIF ((lv_stock_amount >= 5) AND (lv_stock_amount <= 9)) THEN
    lv_stock_level := 'Low Stock Level';
  ELSIF ((lv_stock_amount >= 1) AND (lv_stock_amount <= 4)) THEN
    lv_stock_level := 'Limited Stock Level';
  ELSIF (lv_stock_amount = 0) THEN
    lv_stock_level := 'Out of Stock';
  END IF;
  --Update product status message
  UPDATE product
    SET status = lv_stock_level
    WHERE productid = lv_productid;
  END BEFORE EACH ROW;
END;
/
---UPDATING/CORRECTING PRODUCT STATUSES---
UPDATE inventory
  SET quantity = quantity + 0;

CREATE OR REPLACE TRIGGER update_stock_level_trg
  AFTER INSERT OR UPDATE ON orderitem
  FOR EACH ROW
DECLARE
  lv_quantity_difference orderitem.quantity%TYPE;
  CURSOR quantity_cur IS
    SELECT inventoryid, quantity
    FROM inventory;
  TYPE type_quantity IS RECORD(
    inventoryid inventory.inventoryid%TYPE,
    quantity inventory.quantity%TYPE
    );
  TYPE type_quantity_list IS TABLE OF type_quantity
    INDEX BY BINARY_INTEGER;
  quantity_list type_quantity_list;
  TYPE type_inventoryids IS TABLE OF inventory.inventoryid%TYPE
    INDEX BY BINARY_INTEGER;
  curr_rec NUMBER(10) := 0;
  lv_product_inventoryids_list type_inventoryids;
  lv_productid product.productid%TYPE;
BEGIN
  FOR rec in quantity_cur LOOP
    curr_rec := curr_rec + 1;
    quantity_list(curr_rec).inventoryid := rec.inventoryid;
    quantity_list(curr_rec).quantity := rec.quantity;
  END LOOP;    
  IF INSERTING THEN
    lv_quantity_difference := :NEW.quantity;
  ELSIF UPDATING THEN
    lv_quantity_difference := :NEW.quantity - :OLD.quantity;
  END IF;
  lv_productid := :NEW.productid;
  SELECT inventoryid BULK COLLECT
    INTO lv_product_inventoryids_list
    FROM warehouse
    WHERE productid = lv_productid;
  --When decreasing the amount of product quantity to buy
  IF (lv_quantity_difference < 0) THEN
    FOR curr_rec_1 IN 1..lv_product_inventoryids_list.COUNT LOOP
      FOR curr_rec_2 IN 1..quantity_list.COUNT LOOP
        IF (quantity_list(curr_rec_2).inventoryid
              = lv_product_inventoryids_list(curr_rec_1)) THEN
          WHILE ((quantity_list(curr_rec_2).quantity > 0) AND (lv_quantity_difference < 0)) LOOP
            quantity_list(curr_rec_2).quantity := quantity_list(curr_rec_2).quantity + 1;
            lv_quantity_difference := lv_quantity_difference + 1;
          END LOOP;
        END IF;
        IF (lv_quantity_difference = 0) THEN
          EXIT;
        END IF;
      END LOOP;
    END LOOP;
  --When increasing the amount of product quantity to buy
  ELSIF (lv_quantity_difference > 0) THEN
    FOR curr_rec_1 IN 1..lv_product_inventoryids_list.COUNT LOOP
      FOR curr_rec_2 IN 1..quantity_list.COUNT LOOP
        IF (quantity_list(curr_rec_2).inventoryid
              = lv_product_inventoryids_list(curr_rec_1)) THEN
          WHILE ((quantity_list(curr_rec_2).quantity > 0) AND (lv_quantity_difference > 0)) LOOP
            quantity_list(curr_rec_2).quantity := quantity_list(curr_rec_2).quantity - 1;
            lv_quantity_difference := lv_quantity_difference - 1;
          END LOOP;
        END IF;
        IF (lv_quantity_difference = 0) THEN
          EXIT;
        END IF;
      END LOOP;
    END LOOP;
  END IF;
    FOR curr_rec IN 1..quantity_list.COUNT LOOP
      UPDATE inventory
      SET quantity = quantity_list(curr_rec).quantity
      WHERE inventoryid = quantity_list(curr_rec).inventoryid;
    END LOOP;
END;
/

---PROCEDURES---
CREATE OR REPLACE PROCEDURE is_promo_code_valid_sp
  (p_category IN product.category%TYPE,
  p_promocode IN promo.promocode%TYPE,
  p_available OUT BOOLEAN)
IS
  lv_date DATE;
  lv_count NUMBER(10);
  lv_uses promo.uses%TYPE;
BEGIN
  p_available := FALSE;
  SELECT COUNT(category), expiredate, uses
    INTO lv_count, lv_date, lv_uses
    FROM promo 
    WHERE (category = p_category) 
      AND (promocode = p_promocode)
    GROUP BY expiredate, uses;
  IF ((lv_count != 0)
        AND (lv_uses > 0)
        AND (lv_date >= TRUNC(SYSDATE))) THEN 
    p_available := TRUE;
  END IF;
END;
/
CREATE OR REPLACE PROCEDURE manual_discount_total_sp
 (p_total IN product.cost%TYPE, 
 p_discount IN promo.discount%TYPE,
 p_final_total OUT product.cost%TYPE)
IS
BEGIN
  p_final_total := p_total - (p_total * (p_discount / 100));
END;
/

---FUNCTIONS---
CREATE OR REPLACE FUNCTION calculate_shipping_cost_sf
  (p_total IN NUMBER)
  RETURN NUMBER
    IS 
    lv_ship_cost product.cost%TYPE; 
BEGIN
  IF (p_total > 500) THEN
    lv_ship_cost := 0;
  ELSIF (p_total >= 400) AND (p_total <= 500) THEN
    lv_ship_cost := 5;
  ELSIF (p_total >= 300) AND (p_total <= 399) THEN
    lv_ship_cost := 10;
  ELSIF (p_total >= 200) AND (p_total <= 299) THEN
    lv_ship_cost := 15;
  ELSIF (p_total >= 100) AND (p_total <= 199) THEN
    lv_ship_cost := 20;
  ELSIF (p_total >= 50) AND (p_total <= 99) THEN
    lv_ship_cost := 25;
  ELSIF (p_total < 50) THEN
    lv_ship_cost := 30;
  END IF;
  RETURN lv_ship_cost;
END; 
/
CREATE OR REPLACE FUNCTION calculate_order_total_sf 
  (p_orderid IN orders.orderid%TYPE,
  p_promocode IN promo.promocode%TYPE,
  p_productid IN product.productid%TYPE)
  RETURN NUMBER
  IS 
    lv_total_cost product.cost%TYPE; 
    lv_promo_product_cost product.cost%TYPE;
    lv_promo_discount promo.discount%TYPE;
    lv_promo_category product.category%TYPE;
    lv_is_promo_code_valid BOOLEAN;
BEGIN 
  SELECT SUM(orderitem.historicalretail * orderitem.quantity)
    INTO lv_total_cost
    FROM orderitem
    WHERE orderid = p_orderid;
  SELECT category
    INTO lv_promo_category
    FROM product
    WHERE productid = p_productid;
  is_promo_code_valid_sp(lv_promo_category, p_promocode, lv_is_promo_code_valid);
  IF (lv_is_promo_code_valid) THEN
    SELECT SUM(orderitem.historicalretail * orderitem.quantity)
      INTO lv_promo_product_cost
      FROM orderitem
      WHERE (orderid = p_orderid) 
        AND (productid = p_productid);
    lv_total_cost := lv_total_cost - lv_promo_product_cost;
    SELECT discount
      INTO lv_promo_discount
      FROM promo
      WHERE promocode = p_promocode;
    lv_promo_product_cost := lv_promo_product_cost - (lv_promo_product_cost * (lv_promo_discount / 100));
    lv_total_cost := lv_total_cost + lv_promo_product_cost;
    UPDATE promo
      SET uses = uses - 1
      WHERE promocode = p_promocode;
  END IF;
  lv_total_cost := lv_total_cost + calculate_shipping_cost_sf(lv_total_cost);
  RETURN lv_total_cost;
END; 
/

---ENABLING ALL FOREIGN KEY CONSTRAINTS---
ALTER TABLE OrderItem ADD CONSTRAINT FKOrderItem253970 FOREIGN KEY (OrderId) REFERENCES Orders (OrderId);
ALTER TABLE OrderItem ADD CONSTRAINT FKOrderItem557828 FOREIGN KEY (ProductId) REFERENCES Product (ProductId);
ALTER TABLE Review ADD CONSTRAINT FKReview973403 FOREIGN KEY (ProductId) REFERENCES Product (ProductId);
ALTER TABLE Warehouse ADD CONSTRAINT FKWarehouse134335 FOREIGN KEY (ProductId) REFERENCES Product (ProductId);
ALTER TABLE Warehouse ADD CONSTRAINT FKWarehouse205034 FOREIGN KEY (InventoryId) REFERENCES Inventory (InventoryId);
ALTER TABLE Inventory ADD CONSTRAINT FKInventory585904 FOREIGN KEY (SupplierId) REFERENCES Supplier (SupplierId);
ALTER TABLE Orders ADD CONSTRAINT FKOrders523768 FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId);
ALTER TABLE Review ADD CONSTRAINT FKReview102331 FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId);
ALTER TABLE Address ADD CONSTRAINT FKAddress343072 FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId);
ALTER TABLE Review ADD CONSTRAINT FKReview669545 FOREIGN KEY (OrderId) REFERENCES Orders (OrderId);

COMMIT;

---DISABLING ALL FOREIGN KEY CONSTRAINTS---
/*
ALTER TABLE OrderItem DISABLE CONSTRAINT FKOrderItem253970;
ALTER TABLE OrderItem DISABLE CONSTRAINT FKOrderItem557828;
ALTER TABLE Review DISABLE CONSTRAINT FKReview973403;
ALTER TABLE Warehouse DISABLE CONSTRAINT FKWarehouse134335;
ALTER TABLE Warehouse DISABLE CONSTRAINT FKWarehouse205034;
ALTER TABLE Inventory DISABLE CONSTRAINT FKInventory585904;
ALTER TABLE Orders DISABLE CONSTRAINT FKOrders523768;
ALTER TABLE Review DISABLE CONSTRAINT FKReview102331;
ALTER TABLE Address DISABLE CONSTRAINT FKAddress343072;
ALTER TABLE Review DISABLE CONSTRAINT FKReview669545;
*/
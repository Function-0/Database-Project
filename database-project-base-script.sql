CREATE TABLE Address (
  AddressId  number(10) GENERATED AS IDENTITY, 
  CustomerId number(10) NOT NULL, 
  Address    varchar2(255) NOT NULL, 
  City       varchar2(255) NOT NULL, 
  State      varchar2(255) NOT NULL, 
  Zip        varchar2(255) NOT NULL, 
  PRIMARY KEY (AddressId));
CREATE TABLE Customer (
  CustomerId       number(10) GENERATED AS IDENTITY, 
  LastName         varchar2(255) NOT NULL, 
  FirstName        varchar2(255) NOT NULL, 
  Email            varchar2(255) NOT NULL, 
  Password         varchar2(255) NOT NULL, 
  SecurityQuestion varchar2(255) NOT NULL, 
  SecurityAnswer   varchar2(255) NOT NULL, 
  PRIMARY KEY (CustomerId));
CREATE TABLE Inventory (
  InventoryId      number(10) GENERATED AS IDENTITY, 
  SupplierId       number(10) NOT NULL, 
  Quantity         number(10) NOT NULL, 
  ShelvingLocation varchar2(255) NOT NULL, 
  PRIMARY KEY (InventoryId));
CREATE TABLE "Order" (
  OrderId    number(10) GENERATED AS IDENTITY, 
  CustomerId number(10) NOT NULL, 
  Status     varchar2(255) NOT NULL, 
  OrderDate  date NOT NULL, 
  ShipDate   date NOT NULL, 
  ShipStreet varchar2(255) NOT NULL, 
  ShipCity   varchar2(255) NOT NULL, 
  ShipState  varchar2(255) NOT NULL, 
  ShipZip    varchar2(255) NOT NULL, 
  ShipCost   number(10, 2) NOT NULL, 
  PRIMARY KEY (OrderId));
CREATE TABLE OrderItem (
  OrderItemId      number(10) GENERATED AS IDENTITY, 
  OrderId          number(10) NOT NULL, 
  ProductId        number(10) NOT NULL, 
  PaymentType      varchar2(255) NOT NULL, 
  Quantity         number(10) NOT NULL, 
  HistoricalRetail number(10, 2) NOT NULL, 
  PRIMARY KEY (OrderItemId));
CREATE TABLE Product (
  ProductId number(10) GENERATED AS IDENTITY, 
  Title     varchar2(255) NOT NULL, 
  Cost      number(10, 2) NOT NULL, 
  Retail    number(10, 2) NOT NULL, 
  Category  varchar2(255) NOT NULL, 
  Summary   varchar2(255) NOT NULL, 
  PRIMARY KEY (ProductId));
CREATE TABLE ProductReview (
  ReviewId   number(10) GENERATED AS IDENTITY, 
  CustomerId number(10) NOT NULL, 
  ProductId  number(10) NOT NULL, 
  Comment    varchar2(255) NOT NULL, 
  Rating     number(1) NOT NULL, 
  PRIMARY KEY (ReviewId));
CREATE TABLE Promo (
  PromoId    number(10) GENERATED AS IDENTITY, 
  ProductId  number(10) NOT NULL, 
  Discount   number(10, 2) NOT NULL, 
  Uses       number(5) NOT NULL, 
  PromoCode  varchar2(255) NOT NULL, 
  ActiveDate date NOT NULL, 
  ExpireDate date NOT NULL, 
  PRIMARY KEY (PromoId));
CREATE TABLE Supplier (
  SupplierId number(10) GENERATED AS IDENTITY, 
  Name       varchar2(255) NOT NULL, 
  Email      varchar2(255) NOT NULL, 
  Phone      varchar2(255) NOT NULL, 
  PRIMARY KEY (SupplierId));
CREATE TABLE Warehouse (
  WarehouseId number(10) NOT NULL, 
  InventoryId number(10) NOT NULL, 
  ProductId   number(10) NOT NULL, 
  Name        varchar2(255) NOT NULL, 
  Status      varchar2(255) NOT NULL, 
  Address     varchar2(255) NOT NULL, 
  City        varchar2(255) NOT NULL, 
  State       varchar2(255) NOT NULL, 
  Zip         varchar2(255) NOT NULL, 
  PRIMARY KEY (WarehouseId, 
  InventoryId));
ALTER TABLE Inventory ADD CONSTRAINT FKInventory585904 FOREIGN KEY (SupplierId) REFERENCES Supplier (SupplierId);
ALTER TABLE Warehouse ADD CONSTRAINT FKWarehouse205034 FOREIGN KEY (InventoryId) REFERENCES Inventory (InventoryId);
ALTER TABLE Address ADD CONSTRAINT FKAddress343072 FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId);
ALTER TABLE Warehouse ADD CONSTRAINT FKWarehouse134335 FOREIGN KEY (ProductId) REFERENCES Product (ProductId);
ALTER TABLE Promo ADD CONSTRAINT FKPromo126444 FOREIGN KEY (ProductId) REFERENCES Product (ProductId);
ALTER TABLE ProductReview ADD CONSTRAINT FKProductRev629680 FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId);
ALTER TABLE ProductReview ADD CONSTRAINT FKProductRev446054 FOREIGN KEY (ProductId) REFERENCES Product (ProductId);
ALTER TABLE "Order" ADD CONSTRAINT FKOrder835073 FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId);
ALTER TABLE OrderItem ADD CONSTRAINT FKOrderItem557828 FOREIGN KEY (ProductId) REFERENCES Product (ProductId);
ALTER TABLE OrderItem ADD CONSTRAINT FKOrderItem358778 FOREIGN KEY (OrderId) REFERENCES "Order" (OrderId);
ALTER TABLE Address ADD CONSTRAINT FKAddress781749 FOREIGN KEY () REFERENCES Customer ();


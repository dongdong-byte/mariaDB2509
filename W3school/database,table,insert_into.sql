
-- show databases ; 지금 loclahost 에 해당하는 데이터 베이스가 무엇인지 보여줘


show databases ;


-- create database 데이터 베이스명 -> 해당 데이터 베이스를 만들어줘.

create database exdb;
-- use 데이터 베이스명 -> 이 데이터 베이스를 사용할거야
-- 이걸 선언해아지 데이터를 생성하고 저장할수가 있다.

--
use exdb;

-- craete tabele 테이블 이름(열변수 </n> 변수 데이터 타입 );



create table  Customers(
                           CustomerID int,
                           CustomerName varchar(50),
                           ContactName varchar(50),
                           Address varchar(60),
                           City varchar(50),
                           PostalCode varchar(50),
                           Country varchar(50)



);
-- show tables -> 내가 누른 데이터 베이스에 테이블이 어떤게 있는지 보여줘;

show tables ;

create table Categories(
                           CategoryID int,
                           CategoryName varchar(50),
                           Description varchar(80)



);

-- insert into 테이블이름(테이블에 있는 열 변수-> 전부다 입력) value(열에 해당하는 데이터 입력);

-- 다중 insert 문
-- insert into 테이블이름(테이블에 있는 열 변수-> 전부다 입력) value
-- (열 1에 해당하는 데이터),
-- (열 2에 해당하는 데이터)....


insert into Categories(Categories.CategoryID,Categories.CategoryName,Categories.Description)values (1,'Beverages','Soft drinks, coffees, teas, beers, and ales');
insert into Categories(Categories.CategoryID,Categories.CategoryName,Categories.Description) values (2,'Condiments','Sweet and savory sauces, relishes, spreads, and seasonings');
insert into Categories(Categories.CategoryID,Categories.CategoryName,Categories.Description)values (3,'Confections','Desserts, candies, and sweet breads');
insert into Categories(Categories.CategoryID,Categories.CategoryName,Categories.Description)values (4,'Dairy Products','Cheeses');
insert into Categories(Categories.CategoryID,Categories.CategoryName,Categories.Description)values (5,'Grains/Cereals','Breads, crackers, pasta, and cereal');
insert into Categories(Categories.CategoryID,Categories.CategoryName,Categories.Description)values (6,'Meat/Poultry','Prepared meats');
insert into Categories(Categories.CategoryID,Categories.CategoryName,Categories.Description)values (7,'Produce','Dried fruit and bean curd');
insert into Categories(Categories.CategoryID,Categories.CategoryName,Categories.Description)values (8,'Seafood','Seaweed and fish');

show tables ;

create table Orders(
                       OrderID int,
                       CustomerID int,
                       EmployeeID int,
                       OrderDate date,
                       ShipperID int



);
show tables;

create table Products(
                         ProductID int,
                         ProductName varchar(50),
                         SupplierID int,
                         CategoryID int,
                         Unit varchar(100),
                         Price double

);

create table Suppliers(
                          SupplierID int,
                          SupplierName varchar(70),
                          ContactName varchar(50),
                          Address varchar(50),
                          City varchar(40),
                          PostalCode varchar(50),
                          Country varchar(40),
                          Phone varchar(50)


);
show tables ;


CREATE TABLE Employees(
EmployeeID INT,
LastName VARCHAR(50),
FirstName VARCHAR(30),
BirthDate DATE,
Photo VARCHAR(30),
Notes text
);
SHOW TABLES;
INSERT INTO Employees (EmployeeID,LastName,FirstName,BirthDate,Photo,Notes)
VALUE
(1,'Davolio','Nancy','1968-12-08','EmpID1.pic','Education includes a BA in psychology from Colorado State University. She also completed (The Art of the Cold Call). Nancy is a member of ''Toastmasters International''.'),
(2,'Fuller','Andrew','1952-02-19','EmpID2.pic','Andrew received his BTS commercial and a Ph.D. in international marketing from the University of Dallas. He is fluent in French and Italian and reads German. He joined the company as a sales representative, was promoted to sales manager and was then named vice president of sales. Andrew is a member of the Sales Management Roundtable, the Seattle Chamber of Commerce, and the Pacific Rim Importers Association.'),
(3,'Leverling','Janet','1963-08-30','EmpID3.pic','Janet has a BS degree in chemistry from Boston College). She has also completed a certificate program in food retailing management. Janet was hired as a sales associate and was promoted to sales representative.'),
(4,'Peacock','Margaret','1958-09-19','EmpID4.pic','Margaret holds a BA in English literature from Concordia College and an MA from the American Institute of Culinary Arts. She was temporarily assigned to the London office before returning to her permanent post in Seattle.'),
(5,'Buchanan','Steven','1955-03-04','EmpID5.pic','Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree. Upon joining the company as a sales representative, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London, where he was promoted to sales manager. Mr. Buchanan has completed the courses ''Successful Telemarketing'' and ''International Sales Management''. He is fluent in French.'),
(6,'Suyama','Michael','1963-07-02','EmpID6.pic','Michael is a graduate of Sussex University (MA, economics) and the University of California at Los Angeles (MBA, marketing). He has also taken the courses ''Multi-Cultural Selling'' and ''Time Management for the Sales Professional''. He is fluent in Japanese and can read and write French, Portuguese, and Spanish.'),
(7,'King','Robert','1960-05-29','EmpID7.pic','Robert King served in the Peace Corps and traveled extensively before completing his degree in English at the University of Michigan and then joining the company. After completing a course entitled ''Selling in Europe'', he was transferred to the London office.'),
(8,'Callahan','Laura','1958-01-09','EmpID8.pic','Laura received a BA in psychology from the University of Washington. She has also completed a course in business French. She reads and writes French.'),
(9,'Dodsworth','Anne','1969-07-02','EmpID9.pic','Anne has a BA degree in English from St. Lawrence College. She is fluent in French and German.');

CREATE TABLE OrderDetails(
OrderDetailID int,
CustomerID INT,
EmployeeID INT,
OrderDate DATE,
ShipperID int

);
SHOW TABLES;

CREATE TABLE Shippers(
ShipperID INT,
ShipperName VARCHAR(50),
Phone VARCHAR(40)



);
SHOW TABLES;

INSERT INTO Shippers(ShipperID,ShipperName,Phone) VALUE (1,'Speedy Express','(503) 555-9831');
INSERT INTO shippers(ShipperID,ShipperName,Phone)VALUE (2,'United Package','(503) 555-3199');
INSERT INTO shippers(ShipperID,ShipperName,Phone)VALUE(3,'Federal Shipping','(503) 555-9931');

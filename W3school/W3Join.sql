use exdb;

show tables ;

select  *from exdb.orders;
select  * from customers;

select * from orders as o inner join customers as c on o.CustomerID=c.CustomerID;
-- inner join -> 테이블 2개 <- :서로에 연관관계에 있는 교집합을 중심으로
select orders.OrderID,customers.CustomerID ,customers.CustomerName 고객이름 ,orders.OrderDate
from orders inner join customers
                       on orders.CustomerID=customers.CustomerID;

-- inner join 테이블 3개
-- as: 열이나 테이블에 대해 별칭(alies) 을 선하는데 사용하는 구문

select  orders.OrderID,
        customers.CustomerName as 고객이름 ,
        shipper.ShipperName as 운송업체
from orders
         inner join  customers on orders.CustomerID = customers.CustomerID
         inner join shipper on orders.ShipperID= shipper.ShipperID;

select *from orders;

-- left join 테이블 2개
-- as는 생략도 가능하다 -> 한칸띄면된다.

select c.CustomerID ,c.CustomerName,o.OrderID
from customers c
         left join orders  o
                   on c.CustomerID= o.CustomerID
order by c.CustomerID;

-- right join 테이블 2개

select o.OrderID ,e.EmployeeID,e.FirstName
from orders o
         right join  employees e
                     on o.EmployeeID = e.EmployeeID
order by  o.EmployeeID;


select * from customers;
select * from orders;

-- cross join 테이블2개

select c.CustomerID,c.CustomerName,o.OrderID
from customers c
         cross join orders o
where c.CustomerID =o.CustomerID;

-- self join  테이블 1개
select  c1.CustomerID,c1.CustomerName as c1고객이름,c1.City c1도시,
        c2.CustomerID,
        c2.CustomerName as c2고객이름, c2.City c2도시
from customers c1,customers c2
where c1.CustomerID <> c2.CustomerID
  and c1.City = c2.City
order by c1.City;
-- <>: 서로 다르다


-- union 교집합
select  City from customers
union
select City  from suppliers
order by City;


-- 독일에 공장을 지을건데 독일에 얼마나 많은 고객이 있는지 사전조사 데이터
select  City,Country from customers
where Country='Germany'
union

select City,Country from suppliers
where Country='Germany'
order by City;

select *from customers;

-- select 'Customer' as type ->Customer란 필드를 type으로 넣어라

select 'Customer' as type , CustomerName,City,Country
from customers
union

select  'Supplier' ,ContactName,City,Country
from suppliers;

s
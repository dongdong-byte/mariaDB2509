show databases;
use hrdtest;
create table users(

                      id varchar(50),
                      name varchar(100)
);

insert into users(id, name) VALUE (?,?);

create table Rental(
                       RentalID int primary key ,
                       MemberID int ,
                       BookID int,
                       RentDate date,
                       ReturnDate date

);

create table
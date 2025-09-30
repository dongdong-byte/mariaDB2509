show databases;
create database hrdtest;
use hrdtest;

create table users(

                      id varchar(50),
                      name varchar(100)
);
-- 1. 테이블생성 (제약조건 포함)
-- 회원테이블
create table Member(
    MemberID int primary key auto_increment,
    Name varchar(100) not null ,
    Phone varchar(30),
    Adress varchar(200)

);

-- Book도서 테이블

create  table  Book(
    BookID int primary key auto_increment,
    Title varchar(200) not null ,
    Author varchar(100),
    Publisher varchar(100),
    Price int check ( Price>=0 ),
    Pubyear char(10)
);


-- Rental 테이블

create table Rental(
    RentalID int primary key  auto_increment,
    MemberID int,
    BookID int,
    RentDate date,
    ReturnDate date,
    foreign key (MemberID) references Member(MemberID) on DELETE cascade,
    foreign key (BookID) references Book(BookID) on delete cascade

);

insert into Member( Name, Phone, Adress)values
                                            ('홍길동', '010-1234-5678', '서울시 강남구 테헤란로 123'),
                                            ('김철수', '010-2345-6789', '서울시 서초구 서초대로 456'),
                                            ('이영희', '010-3456-7890', '경기도 성남시 분당구 정자동 789'),
                                            ('박민수', '010-4567-8901', '인천시 남동구 구월동 321'),
                                            ('최지은', '010-5678-9012', '서울시 송파구 잠실동 654');

-- 도서 데이터 20개
insert into Book (Title, Author, Publisher, Price, Pubyear) VALUE
    ('자바 프로그래밍', '김자바', '한빛미디어', 35000, '2020'),
    ('파이썬 입문', '이파이', '길벗', 28000, '2021'),
    ('데이터베이스 개론', '박디비', '생능출판', 32000, '2019'),
    ('웹 개발의 정석', '최웹', '위키북스', 38000, '2022'),
    ('알고리즘 해법', '정알고', '인사이트', 42000, '2023'),
    ('리액트 마스터', '강리액', '한빛미디어', 36000, '2021'),
    ('머신러닝 실전', '신머신', '에이콘', 45000, '2020'),
    ('클라우드 컴퓨팅', '조클라우', '제이펍', 40000, '2022'),
    ('네트워크 기초', '윤네트', '생능출판', 30000, '2018'),
    ('보안의 이해', '한보안', '정보문화사', 33000, '2021'),
    ('운영체제 개념', '서운영', '한빛아카데미', 35000, '2019'),
    ('모바일 앱 개발', '김모바일', '위키북스', 39000, '2023'),
    ('빅데이터 분석', '이빅데이터', '길벗', 48000, '2020'),
    ('인공지능 개론', '박인공', '한빛미디어', 50000, '2022'),
    ('게임 개발 입문', '최게임', '에이콘', 37000, '2021'),
    ('IoT 프로그래밍', '정아이오티', '제이펍', 34000, '2020'),
    ('블록체인 기술', '강블록', '인사이트', 44000, '2023'),
    ('DevOps 실무', '신데브옵스', '위키북스', 41000, '2022'),
    ('UI/UX 디자인', '윤디자인', '길벗', 29000, '2021'),
    ('프로젝트 관리', '한프로젝트', '생능출판', 31000, '2019');

-- 대출데이터
insert into Rental( MemberID, BookID, RentDate, ReturnDate) values
      (1, 1, '2024-01-10', '2024-01-20'),
      (1, 7, '2024-02-15', NULL),
      (1, 13, '2024-03-20', NULL),
      (1, 5, '2024-04-05', '2024-04-15'),


      (2, 2, '2024-01-12', '2024-01-25'),
      (2, 4, '2024-02-20', NULL),
      (2, 14, '2024-03-10', '2024-03-20'),


      (3, 3, '2024-01-15', NULL),
      (3, 8, '2024-02-10', '2024-02-22'),
      (3, 1, '2024-03-15', NULL),


      (4, 6, '2024-01-18', '2024-02-01'),
      (4, 10, '2024-02-25', NULL),
      (4, 14, '2024-04-01', '2024-04-10'),


      (5, 9, '2024-01-20', '2024-02-03'),
      (5, 12, '2024-03-05', NULL),
      (5, 17, '2024-04-10', '2024-04-20');

SELECT
    m.Name AS 회원명,
    b.Title AS 도서명,
    b.Author AS 저자,
    r.RentDate AS 대출일,
    r.ReturnDate AS 반납일

FROM Rental r
         JOIN Member m ON r.MemberID = m.MemberID
         JOIN Book b ON r.BookID = b.BookID
WHERE m.Name = '홍길동'
;

-- 3.질문 반납하지 않은 도서를 검색하시오.
SELECT
    b.BookID,
    b.Title AS 도서명,
    b.Author AS 저자,
    m.Name AS 대출회원,
    r.RentDate AS 대출일,
    '미반납' AS 반납여부
FROM Rental r
         JOIN Book b ON r.BookID = b.BookID
         JOIN Member m ON r.MemberID = m.MemberID
WHERE r.ReturnDate IS NULL;

-- 4.질문 도서별 대출횟수 출력
SELECT
    B.BookID,
    B.Title AS 도서명,
    B.Author AS 저자,
    COUNT(*) AS 대출횟수
FROM
    Rental AS R
        JOIN
    Book AS B ON B.BookID = R.BookID
GROUP BY
    B.BookID, B.Title, B.Author
;

-- 5.가격이 가장 비싼 도서를 출력하시오.
select Title , Author , Publisher, MAX(Price) as BiggestPrice ,Pubyear   from Book;
USE shopdb;


-- is not null -> not null이 올바른 구문임
-- PRIMARY(productName) -> PRIMARY key (productName)
-- makedata는 내장함수라서 가급적이면 피하기
-- amount 같은 수량은 int  보다는 금액은 DECIMAL(10,2) 타입 사용 권장 (정확한 계산)
CREATE TABLE productTBL(
productName CHAR(4)  NOT null,
cost INT  NOT null,
makeDatE DATE ,
company CHAR(5) ,
amount INT  NOT null,

PRIMARY KEY (productName)

);

-- 위식대로 membertbl에  데이터를 입력했더니 collation_database가 latin1_swedish_ci로 설정이 되어 있어서 한국어 데이터가 입력이 안됨


-- 한글 이름 입력을 하려면 sql에서utf8로 지정해야한다.
-- 해결책
-- 1.현재 문자셋 확인

SHOW VARIABLES LIKE 'chrarcter_set%';
SHOW VARIABLES LIKE 'collation%';

-- datbase가latin1으로 정해저 있어서  한국어 데이터가 입력이 안됨

-- 1. 데이터 베이스 collation으로 변경
ALTER DATABASE shopdb CHARACTER SET UTF8MB4 COLLATE UTF8MB4_UNICODE_CI;

-- 2.테이블 collation변경
ALTER TABLE shopdb.membertbl CONVERT TO CHARACTER SET UTF8MB4 COLLATE UTF8MB4_UNICODE_CI;

-- 3. 세션 설정 
SET NAMES UTF8MB4 COLLATE UTF8MB4_UNICODE_CI;

-- 이방식은 membertbl에서만 가능 
-- producttbl latin코드를UTF8MB4로 바꾼다
ALTER TABLE shopdb.producttbl CONVERT TO CHARACTER SET UTF8MB4 COLLATE UTF8MB4_UNICODE_CI;
-- producttbl 정보 추가
INSERT INTO producttbl(productname,cost,make,company,amount)
VALUE
('컴퓨터',10,'2017-01-01','삼성',17),
('세탁기',20,'2018-09-01','LG',3),
('냉장고',5,'2019-02-01','대우',22);

SELECT * FROM membertbl;

-- mebertbl에 추가 데이터 삽입
INSERT INTO membertbl (memberID,memberName,memberAddress)
VALUE
('Jee','지운이','서울 은평구 증산동'),
('Han','한주연','인천 남구 주안동'),
('Sang','상길이','경기 성남구 분당구');

SELECT* FROM membertbl;
USE shopdb;
SELECT *FROM membertbl;

-- select (열이름) from 테이블이름 where 조건 ->의 형식을 가진다.
-- '*'는 모든 열을 의미한다.

-- 회원 테이블중에 이름과 주소만 출력하라

SELECT memberName, memberAddress FROM membertbl;

-- 지운이에 대한 정보만 추출하라
SELECT * FROM membertbl WHERE memberName='지운이';

-- 쿼리창에 시작버튼을 시작할시 모든 코드를 실행하기 때문에 실행코드를 선택하고 선택 실행 을 해야만한다

-- 새로운 테이블 생성 ->백틱으로 생성
CREATE TABLE `my testTBL`(id INT);

CREATE TABLE indextbl (
first_name VARCHAR(14),
last_name VARCHAR(16),
hire_date date

)

-- insert into ...select 구문으로 다른테이블에서 데이터를 조회해서 새로운 테이블에 삽입하는방법

-- insert into [대상 테이블]
-- select [행 속성 들]
-- from[원본테이블-> 데이터가 있는 테이블 -> 여기서는 employees스키마에 있는 employees 테이블을 가져온다.]
-- [limit 제한 -> 행을 500개로 제한한다.]
INSERT INTO indextbl 
SELECT first_name,last_name,hire_date
FROM employees.employees
LIMIT 500;

SELECT * FROM indextbl;

-- 이름이 'Mary' 인 사람을 조회해라
SELECT * FROM indextbl WHERE first_name='Mary';

-- 위 커리에 explain문을 붙여서 실행
EXPLAIN SELECT * FROM indextbl WHERE first_name='Mary';
-- explain문은 쿼리문이 실행될때 어떤방식으로 실행되는지 실행계획을 보여준다.

-- type부분에 all인건 인덱스를 사용안하고 테이블 전체를 검색한것 ->'*' 때문임
-- 인덱스가 없다면 전체 내용을 뒤벼서 찾아야한다

-- indextbl 테이블first_name에 인덱스를 생성해보자

-- 설명 : indextbl 테이블의  first_name 열에 대해 idx_indextbl_firstname란 이름의 -> (이이름은은 사용자가 자유롭게 정할수가 있음) 일반 인덱스를 생성하라

CREATE INDEX idx_indextbl_firstname ON indextbl(first_name);

-- 이름이 'Mary' 인 사람을 조회해라
SELECT * FROM indextbl WHERE first_name='Mary';
-- 위 커리에 explain문을 붙여서 실행
EXPLAIN SELECT *FROM indextbl WHERE first_name='Mary';

-- 인덱스는 잘사용하면 좋지만 잘못사용하면 독이다 -> 9장에서 설명

-- explain 을 사용하는 이유
-- 1. 쿼리 성능분석
-- 실행계획을 미리 확인
-- 병목지점식별
-- 2.인텍스 효율성 확인
-- 인텍스 사용 여부 체크
-- 적절한 인덱스 설계
-- 3. 최적화 방향 제시
-- type이 all인경우-> 인덱스 필요
-- row가 많은경우 -> 조건 개선 필요
-- 4.개발 운영 단계에서 필수
-- 신규 쿼리 성능 검증
-- 기존 쿼리 튜닝
-- 인뎃스 설계검토


-- -----3.32 뷰 (8장)--------------
-- CREATE VIEW [뷰이름 -> uv_membertbl  이라는 이름의 뷰를 생성한다.]
-- 이뷰는 membertbl  테이블에 memberName하고 memberAddres열로 구성된 테이블로 나타난다.
-- 뷰 생성시 select에 입력한 문이 작동한다/

-- 아래 구문은 알바생에게 주소만 변경하는 작업을 주는데 뷰를 생성안하면 필요 없는 정보가 유ㅊ출이 된다
CREATE VIEW uv_membertbl
AS SELECT memberName, memberAddress FROM membertbl;

SELECT * FROM uv_membertbl;

-- 회원 테이블 당탕이의 정보와 제품테이블의 '냉장고'의 정보를 동시에 조회한다고 가정하자 

-- 데이터 베이스를 shopdb로 사용한다
USE  shopdb;

-- 문제점
-- inner JOIN에 on절이 없어서 어떤기준으로 두 테이블을 결합할지 명시 하지 않았음 cross join으로 인식해서 의도가 다를수가 있다
-- where 절에서 두조건을 비교하려면 and 연산자로 연결해야한다.

-- SELECT m.memberName, p.productName FROM membertbl as m inner JOIN producttbl p ON m.memberID=p.producttbl WHERE m.memberName='당탕이', p.productName='냉장고'

-- 두테이블을동시에 입력해서 서로 비교해야하므로  비효율적이다 -> 테이블이 많아지면 골치 아파진다
-- 두 쿼리를 하나의 스토어드 프로시저로 만들어서 비교
-- 저장 프로시저(Stored Procedure)
-- 저장 프로시저는 데이터베이스 서버에 미리 저장해 둔 일련의 SQL 문들을 하나의 이름으로 묶어 놓은 데이터베이스 객체입니다.
-- 호출 시점에 프로시저 이름과 필요한 매개변수만 넘기면, 미리 정의된 SQL 문들이 서버에서 순차적으로 실행됩니다.
-- 예: 복잡한 데이터 조작, 비즈니스 로직의 일부를 데이터베이스 안에서 실행하도록 구현.

-- 책에 구문이 잘못된거 수정함
 delimiter $$
create procedure  myProc() begin
    select *from membertbl where memberName='당탕이';
    select  * from  prodicttbl where productName ='냉장고';

end $$

delimiter ;

call myProc();
 -- 3.4트리거 10장
 
 INSERT INTO membertbl VALUES('Firgure','연아','경기도 군포시 당정동');
 
 SELECT * FROM membertbl;
 -- '연아'인 회원의 주소를 '서울 강남구 역삼동'으로 변경해보자
 UPDATE membertbl SET memberAddress = '서울 강남구 역삼동 ' WHERE memberName ='연아';
 
 SELECT * FROM membertbl;
 
 -- '연아'가 회원탈퇴해서 회원 테이블에 삭제를 해야한다.
 DELETE FROM membertbl WHERE memberName='연아';
 
 SELECT * FROM membertbl;
 
 -- '연아'가 예전에 회원이었다는 정보는 어디에도 기록이 되어있지 않았다.
 -- 혹시라도 '연아'가 나중에 이 쇼핑몰의 회원이었다는 증명을 요구한다면 그걸 증명해줄 방법이 없다.
 
 
 -- 위와 같은 사태를 방지 하기 위해 회원 테이블에서 행 데이터를 삭제 할경우 다른 테이블에 지워진 뎅;터와 젇불어 지워진 날짜까지 기록해주보자.
 -- 먼저 지워진 데이를 보관할 테이블 (deletemembertmbl)을 만들어보자
 CREATE TABLE  deletemembertmbl(
 memberID CHAR(8),
 memberName CHAR(5),
 memberAddress CHAR(20),
 dletedData DATE 
 );

USE shopdb;
-- 회원 테이블에 삭제 작업이 일어나면 백업테이블에 태워진 데이터가 기록되는 트리거 생성한다.
-- 트리거 테이블 작성
delimiter $$
create trigger  trg_deletedMemberTBL -- 트리거 이름
after delete  -- 삭제후에 작동하게 지정
on membertbl -- 트리거를 부착할 테이블
for each row  -- 각 행마다 적용시킴
BEGIN
    -- old테이블 내용을 백업 테이블에 삽입
    insert into  deletedmembertbl
        values (OLD.memberID,OLD.memberName,OLD.memberAddress,curdate());
end $$
delimiter ;
 
USE shopdb;
SELECT * FROM membertbl;

-- 당탕이를 삭제한다.

DELETE FROM shopdb.membertbl WHERE memberName='당탕이';

SELECT * FROM membertbl;

SELECT * FROM shopdb.deletemembertmbl;

DELETE FROM membertbl WHERE memberName='당탕이';

SHOW TABLES LIKE '%deleted%';
 USE shopdb;
SELECT *FROM 
CREATE TABLE  deletedMemberTBL(
 memberID CHAR(8),
 memberName CHAR(5),
 memberAddress CHAR(20),
 dletedData DATE 
 );
SELECT * FROM deletedMemberTBL;


-- 3.4 데이터 베이스 백업 및 관리
-- 3.4.1 백업과 복원
-- 데이터베이스가 해야하는 주요 업무중하나가 데이터 백업하고 문제가 생기면 복원하는거다.

USE shopdb;
SELECT * FROM producttbl;

-- 사고->producttbl 모든 테이블삭제

-- delete문을 실행할때 where 절이 없으면 모든 데이터가 제거가 된다. 이거 ㄴ6장에서 설명하겠다.

Delete FROM producttbl;

-- 사고친후에 진짜로 삭제 되었는지 확인\
SELECT * FROM producttbl;

-- 백업한 데이터를 복원해서 실수로 삭제한거 복원
-- 사용 ㅈ중인 DB를 복원하면 문제가 생길수도 있으니까 , 우선 데이터 베이스를 shopdb에서 다른 db로 변경해야한다.
USE mysql;

USE shopdb;

SELECT * FROM producttbl;
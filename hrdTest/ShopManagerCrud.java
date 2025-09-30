import java.sql.*;

public class ShopManagerCrud {
    ShopManagerCrud(){
//        createTable();
insertmember();
//deleteTable(1);
    }

    public void deleteTable(int id) {
        System.out.println("레코드 삭제 시작");
        String sql = "delete from hrdtest.shopmember where CustNo = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            int row = pstmt.executeUpdate();
            System.out.println("====== " + row + "행이 삭제됨");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(pstmt, conn);
        }
    }

    private void insertmember() {
        System.out.println("직원 데이터 일괄 삽입 시작");

        String sql = """

                INSERT INTO hrdtest.shopmember
( CustName, Phone, Address,JoinDate,Grade,City) 
VALUES (?, ?, ?, ?,?,?)
""";

// 삽입할 데이터 배열
        String[][] shopmember = {
                {"홍길동", "010-1234-5678", "서울시 강남구", "2020-01-01", "A",   "01" },
                        {"이순신", "010-2222-3333", "부산시 해운대구", "2021-03-15", "B", "02"},
                                {"강감찬", "010-7777-8888", "대구시 달서구", "2019-05-20", "C", "03" }
                        };

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            // 배열의 각 행(회원)을 반복
            for (int i = 0; i < shopmember.length; i++) {
                pstmt.setString(1, (String) shopmember[i][0]); // CustName
                pstmt.setString(2, (String) shopmember[i][1]); // Phone
                pstmt.setString(3, (String) shopmember[i][2]); // Address
                pstmt.setString(4, (String) shopmember[i][3]); // JoinDate
                pstmt.setString(5, (String) shopmember[i][4]); // Grade

                pstmt.setString(6, (String) shopmember[i][5]); // City

                int row = pstmt.executeUpdate();
                System.out.println((i + 1) + "번째 회원 '" + shopmember[i][0] + "' 삽입 완료! (" + row + "행)");
            }

        } catch (SQLException e) {
            System.out.println("❌ 데이터 삽입 실패!");
            e.printStackTrace();
        } finally {
            DBConnection.close(pstmt, conn);
        }


        System.out.println("--- 모든 회원 데이터 삽입 완료 ---");
        }
    private void createTable() {
        System.out.println("--- 테이블 만들기 시작 ----");

        String sql1 = """
create table if not exists ShopMember(
    CustNo  int primary key auto_increment comment '회원번호' ,
    CustName  varchar(30) not null comment '회원성명',
    Phone  varchar(30) unique comment '전화번호',
    Address   varchar(50) comment '주소',
    JoinDate  DATE not null comment '가입일자',
    Grade  char(1)  comment '고객등급',
          
    City  CHAR(2) comment '도시코드',check(grade in ('A','B','C'))  
    
    
)
""";

        String sq2 = """
 create table if not exists Sale(
 SaleNo  int primary key auto_increment comment '판매 번호',
 CustNo  int comment '회원번호',
 PCost  int comment '단가',
 Amount int comment '수량',
 Price  int comment '금액',
 PCode  char(3) comment '상품코드',
     foreign key(CustNo ) references ShopMember(CustNo)
 
 
 
 
 )
 
                """;

        Connection conn = null;
        Statement stmt = null;

        try {
            conn = DBConnection.getConnection();



            stmt = conn.createStatement();
            System.out.println("ShopMember 테이블 생성중");
            stmt.execute(sql1);
            System.out.println("ShopMember 테이블 생성완료");
            System.out.println("Sale 테이블 생성중");
            stmt.execute(sq2);
            System.out.println("Sale 테이블 생성완료");
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("테이블 생성 실패");
        } finally {
            DBConnection.close(stmt, conn);
        }
        System.out.println("새로운 테이블생성 완료");
    }

}


import java.sql.*;

public class ShopManagerCrud {
    ShopManagerCrud(){
//        createTable();
//insertmember();
deleteTable(3);
//question01();
//insertsales();
//        이순신 회원으 등급을 'A'로 수정하시오
        updateTable("이순신","A");

    }
    public void question04() {
        System.out.println("가장 구매금액이 높은 회원의 이름과 금액을 조회하시오");
        String sql = """
                select
                                       shopmember.CustName as 회원이름,
                                       sum(sale.Amount * sale.PCost) as 총금액
                                   from hrdtest.sale
                                   inner join hrdtest.shopmember
                                   on sale.CustNo=shopmember.CustNo
                                   group by sale.CustNo,shopmember.CustName
                                   order by 총금액 desc
                                   limit 1;
      
                """;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                System.out.println("조회된 결과가 없음");
            } else {
                int rowCount = 0;
                do {
                    rowCount++;

                    String CustName = rs.getString("회원이름");

                    String totalprice = rs.getString("총금액");

                    System.out.println(
                            " | 회원이름 : " + CustName +
                            " | 총금액 : " + totalprice


                    );
                } while (rs.next());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(pstmt, conn, rs);
        }

    }
    public void question03() {
        System.out.println("회원별 총 구매금액을 구하시오.");
        String sql = """
                select  sale.CustNo as 회원번호,
                shopmember.CustName as 회원성명,
                
                sum(sale.Amount * sale.PCost) as 총금액
                from hrdtest.sale  inner join  hrdtest.shopmember 
                on sale.CustNo=shopmember.CustNo
                group by sale.CustNo,shopmember.CustName
                order by 총금액 desc ;
      
                """;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                System.out.println("조회된 결과가 없음");
            } else {
                int rowCount = 0;
                do {
                    rowCount++;
                    String CustNo = rs.getString("회원번호");
                    String CustName = rs.getString("회원성명");

                    String totalprice = rs.getString("총금액");

                    System.out.println("회원번호 : " + CustNo +
                            " | 회원성명 : " + CustName +
                            " | 총금액 : " + totalprice


                    );
                } while (rs.next());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(pstmt, conn, rs);
        }

    }

    private void updateTable(String CustName, String Grade) {
        System.out.println("데이터 수정 시작");

// PreparedStatement의 진짜 장점 활용! (SQL 인젝션 방지)
        String sql = "UPDATE hrdtest.shopmember SET Grade = ? WHERE CustName = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            // 값을 안전하게 바인딩
            pstmt.setString(1, Grade);      // 첫 번째 ? 에 이름
            pstmt.setString(2, CustName);     // 두 번째 ? 에 이름

            int row = pstmt.executeUpdate();

            if (row > 0) {
                System.out.println(  CustName + "님의 등급이 " + Grade + "으로 수정됨");
            } else {
                System.out.println("⚠️ " + CustName + "님을 찾을 수 없습니다");
            }

        } catch (SQLException e) {
            System.out.println("❌ 데이터 수정 실패!");
            e.printStackTrace();
        } finally {
            DBConnection.close(pstmt, conn);
        }

    }




    private void insertsales() {




            System.out.println("판매 데이터 일괄 삽입 시작");

            // 계좌 개설 신청서 양식 준비
            String sql = """
                insert into hrdtest.sale( CustNo, PCost, Amount, Price, PCode) 
                    VALUE (?,?,?,?,?)""";


            String[][] sale = {
                    {"1", "1000", "10", "10000", "P01"},
                            {"2", "2000", "5", "10000", "P02"},
                                    {"3", "1500", "7", "10500", "P03"}
            };


            Connection conn = null;
            PreparedStatement pstmt = null;


            try {
                conn = DBConnection.getConnection();
                pstmt = conn.prepareStatement(sql);

                // 배열의 각 행(회원)을 반복


                for (int i = 0; i < sale.length; i++) {
                    pstmt.setInt(1, Integer.parseInt(sale[i][0])); // SaleNo = 1
                    pstmt.setInt(2, Integer.parseInt(sale[i][1])); // CustNo = 1000
                    pstmt.setInt(3, Integer.parseInt(sale[i][2])); // PCost = 10
                    pstmt.setInt(4, Integer.parseInt(sale[i][3])); // Amount = 10000

                    pstmt.setString(5,(String) sale[i][4]);//   PCode   ='P01’


                    int row = pstmt.executeUpdate();


                    System.out.println((i + 1) + "번째 판매 데이터 삽입 완료 ! '(" + row + "행)");
                }

                // 문제 발생시 대응 (catch)
            } catch (SQLException e) {

                System.out.println("❌ 데이터 삽입 실패!");
                e.printStackTrace();
            } finally {

                DBConnection.close(pstmt, conn);
            }

            System.out.println("--- 모든 회원 데이터 삽입 완료 ---");

    }


    public void question01() {
    System.out.println("고객등급이 A등급인 회원의 이름, 전화번호, 가입일자를 조회하시오.");
    String sql = """
                select CustName,Phone,Address,Grade
                from hrdtest.shopmember where Grade='A';
      
                """;
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        if (!rs.next()) {
            System.out.println("조회된 결과가 없음");
        } else {
            int rowCount = 0;
            do {
                rowCount++;
                String CustName = rs.getString("CustName");
                String Phone = rs.getString("Phone");
                String Address = rs.getString("Address");
                String Grade = rs.getString("Grade");

                System.out.println("고객이름 : " + CustName +
                        " | 전화번호 : " + Phone +
                        " | 주소 : " + Address
                        + " | 고객등급 : " + Grade

                );
            } while (rs.next());
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        DBConnection.close(pstmt, conn, rs);
    }

}

public void deleteTable(int id) {
    System.out.println("레코드 삭제 시작");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {

        conn = DBConnection.getConnection();
//        자식데이터 먼제 삭제
        String sql = """
DELETE FROM hrdtest.sale WHERE CustNo = ?
""";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, id);
        int row = pstmt.executeUpdate();
        System.out.println("판매데이터 " + row + "행이 삭제됨");
//        2단계 부모 삭제
        String sql1 = """
DELETE FROM hrdtest.sale WHERE CustNo = ?
""";
        pstmt = conn.prepareStatement(sql1);
        pstmt.setInt(1, id);
        int row1 = pstmt.executeUpdate();
        System.out.println("회원 데이터 " + row1 + "행이 삭제됨");
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        DBConnection.close(pstmt, conn);
    }
}

private void insertmember() {
//        은행 업무 비유 : 여러명의 신규 고객 계좌 개설

//     전체 흐름 요악
//  1.   은행 지점 업무 시작
//    2.계좌 개설 신청서 양식 준비(sql)
//    3.3명의 고객 서류 준비(배열 데이터 String[][]member())
// 4. 본사와 전화 연결 (Connection-> try 구문에서 실행 ,Connection=null은 try구문 밖에서 선언해야한다. )
//    5.신청서 작성 도구 준비 (preparedStatement-> statement 보다는 정밀한 도구가 필요)
//    6.고객 1명씩 순차처리 (for구문으로 반복)
//    6-1.홍길동님 신청서 작성(SetString)
//    6-2. 본사 전송 (executeUpdate -> statment 구문을 사용하면 excute만 사용하면된다. )
//    6-3.승인확인 (row =1)
//    6-4.완료 공지 (ptintin)
//    6-5 . 이순신님 신청서 작성
//    6-6.본사 전송(executeUpdate)
//    6-7.승인확인(row=2)
//    6-8. 완료 공지 (printin)
//    6-9.강감찬님 신청서 작성
//    6-10.본사 전송 (executeUpdate)
//    6-11.승인확인 (row=3)
//    6-12. 완료 공지 (printin)
//    7. 문제 발생시 오류 처리(catch)
//    8.전화 끊고 정리 -> 성공하든 실패하든 일단 끊어야 한다->안끊는다는건 본사 직원 전화상태 대기중으로 두고 밥먹으로 간다는 소리
//    9.업무 완료 공지


//    오늘은 신규 고객 3명의 계좌를 일괄개설 하겠습니다.
    System.out.println("직원 데이터 일괄 삽입 시작");
// 계좌 개설 신청서 양식 준비
    String sql = """

                INSERT INTO hrdtest.shopmember
( CustName, Phone, Address,JoinDate,Grade,City) 
VALUES (?, ?, ?, ?,?,?)
""";
//은행직원 -> 계좌 개설 신청서 양식을 준비합니다.
//    양식에는 6개의 빈칸이 있습니다.
//    1.고객이름[?]
//    2.전화번호[?]
//    3.주소 :[?]
//    4. 가입일자 [?]
//    5. 고객 등급 [?]
//    6.도시 코드 [?]
// 삽입할 데이터 배열
//    신규 고객 3명의 정보 뭉치

    String[][] shopmember = {
            {"홍길동", "010-1234-5678", "서울시 강남구", "2020-01-01", "A",   "01" },
            {"이순신", "010-2222-3333", "부산시 해운대구", "2021-03-15", "B", "02"},
            {"강감찬", "010-7777-8888", "대구시 달서구", "2019-05-20", "C", "03" }
    };
//대기중인 고객들
//    1. 번 고객 서류:홍길동님 - 서울 거주, A등급, 2020년 가입
//    2번 고객 서류: 이순신님 - 부산 거주, B등급, 2021년 가입
//    3번 고객 서류 : 강감찬님 - 대구 거주, C등급, 2019년 가입

//     은행 창구 직원
    Connection conn = null;
    PreparedStatement pstmt = null;
// 본사 전산 시스템에 전화 연결 성공!
//    "계좌 개설 신청서 양식 준비 완료!"
    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);

        // 배열의 각 행(회원)을 반복
//        고객별 계좌 개설 처리 (반복작업)
//        은행 직원 -> 이제 3명의 고객을 한명씩 순서대로 처리하겠습니다.
// 1번 고객 (홍길동님 ) 처리
        for (int i = 0; i < shopmember.length; i++) {
            pstmt.setString(1, (String) shopmember[i][0]); // CustName = 홍길동
            pstmt.setString(2, (String) shopmember[i][1]); // Phone = "010-1234-5678"
            pstmt.setString(3, (String) shopmember[i][2]); // Address = "서울시 강남구"
            pstmt.setString(4, (String) shopmember[i][3]); // JoinDate = "2020-01-01"
            pstmt.setString(5, (String) shopmember[i][4]); // Grade = "A"

            pstmt.setString(6, (String) shopmember[i][5]); // City = "01
//이를 바탕으로 직원이 신청서를 작성한다.
//  ┌─────────────────────────┐
//│  계좌 개설 신청서       │
//├─────────────────────────┤
//│ 이름:   홍길동          │
//│ 전화:   010-1234-5678   │
//│ 주소:   서울시 강남구    │
//│ 가입일: 2020-01-01      │
//│ 등급:   A               │
//│ 도시:   01              │
//└─────────────────────────┘
//            int row = pstmt.executeUpdate();-> 신청서 제출
            int row = pstmt.executeUpdate();
//            본사 :  홍길동님계좌 개설 완료 했습니다.
//            row=1 1개 계좌 개설 완료
//            직원 공지 "1번째 회원 홍길동 삽입 완료"
            System.out.println((i + 1) + "번째 회원 '" + shopmember[i][0] + "' 삽입 완료! (" + row + "행)");
        }
// 문제 발생시 대응 (catch)
    } catch (SQLException e) {
//        만약 문제가 생긴다면
//        전화선이 끊어짐-> 본사 연락 두절
//        신청서에 오타가 있음 -> 본사가 반려
//        이미 같은 전화번호로 계좌가 있음-> 중복 오류
        System.out.println("❌ 데이터 삽입 실패!");
        e.printStackTrace();
    } finally {

//        업무 마무리 및 정리 (finally)
//        전화 끊기 & 서류 정리
//        사용한 신청서 양식 정리 (pstmt.close())
//        본사와의 전화 연결 종료 (conn.close())
//         성공하든 실패하늗 무조건 정리
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
     foreign key(CustNo ) references hrdtest.shopmember(CustNo)
 
 
 
 
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

    public void question02() throws SQLException {
        System.out.println("가입일자가 2020년 이후인 회원을 조회하시오.");
        String sql1 = """
               
                select CustName,JoinDate from hrdtest.shopmember where year(JoinDate)>=2020;
                """;
        String sql2= """
                
                select CustName,JoinDate from hrdtest.shopmember where JoinDate>='2020-01-01';
                """;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;


        try {
//            첫번째 방법
            System.out.println("방법1 year()함수 사용 ");
            conn = DBConnection.getConnection();

            pstmt = conn.prepareStatement(sql1);
            rs = pstmt.executeQuery();
            if (!rs.next()) {
                System.out.println("조회된 결과가 없음");
            } else {
                int rowCount = 0;
                do {
                    rowCount++;
                    String CustName = rs.getString("CustName");
                    String JoinDate = rs.getString("JoinDate");


                    System.out.println("고객이름 : " + CustName +
                            " | 가입날짜 : " + JoinDate


                    );
                } while (rs.next());
                rs.close();
                pstmt.close();
// 두번째 방식 (날짜 비교 사용)
                System.out.println("방법2 날짜 직접 비교 JoinDate>='2020-01-01");
                pstmt = conn.prepareStatement(sql2);
                rs = pstmt.executeQuery();
                if (!rs.next()) {
                    System.out.println("조회된 결과가 없음");
                } else {
                    int rowCount2 = 0;
                    do {
                        rowCount2++;
                        String CustName = rs.getString("CustName");
                        String JoinDate = rs.getString("JoinDate");
                        System.out.println("고객이름 : " + CustName +
                                " | 가입날짜 : " + JoinDate);
                    } while (rs.next());
                }

            }
        }catch (SQLException e){
            e.printStackTrace();

        }finally {
            DBConnection.close(pstmt, conn);
        }

    }




}









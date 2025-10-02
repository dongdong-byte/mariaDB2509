import  java.sql.*;


public class GolfCrudClass {
    GolfCrudClass(){
//        createTable();
//insertGolfMember();
//insertLesson();
//insertGolfUsage();
//        이순신 회원의 등급을 'A'로 수정
//        updateTable("이순신","A");
//        MNo = 3 인 회원을 삭제
//        deleteCustomerWithSales(3);

//        question04();
    }

    public void question04() {
        System.out.println(" 심화 문제 =“등급별 통계”->(등급, 회원 수, 평균 강습비, 총 이용요금)을 조회하시오.");
        String sql = """
    
             select gm.Grade as 등급 ,
                                                 count(distinct gm.MName) as 회원수 ,
                                                 avg(le.Fee) as 평균_강습비,
                                                 sum(gu.Cost)  as 총_이용요금
                                          from GolfMember gm
                                          left join  Lesson le
                                          on gm.MNo=le.MNo
                                          left join GolfUsage GU on gm.MNo = GU.MNo
                                          group by gm.MNo , gm.Grade
                                          order by gm.Grade;
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
                    String Grade = rs.getString("등급");
                    int TotalMName =rs.getInt("회원수");
                    double AvgFee = rs.getInt("평균_강습비");
                    int SumCost = rs.getInt("총_이용요금");


                    System.out.println("등급: " + Grade +
                                    " | 회원수: " + TotalMName+
                            " | 평균_강습비: " + AvgFee +
                            " | 총_이용요금: " + SumCost

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
        System.out.println("문제3. 회원별 총 이용요금을 집계. (출력: 회원명, 총요금)");
        String sql = """
    
                select gm.MName as 회원명,
           sum(gu.Cost) as 총요금
    from GolfMember gm
    inner join GolfUsage gu
    on gm.MNo = gu.MNo
    group by  gm.MNo,gm.MName;
                
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
                    String MName = rs.getString("회원명");

                    int Fee = rs.getInt("총요금");


                    System.out.println("회원명: " + MName +

                            " | 총요금: " + Fee


                    );
                } while (rs.next());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(pstmt, conn, rs);
        }

    }

    public void question02() {
        System.out.println("문제2.강습비가 250000 이상인 강습 내역을 조회하시오.");
        String sql = """
    
                select
                        gm.MName as 회원명,
                    le.Coach as 코치,
                    le.Fee as 강습비,
                    gu.UDate as 이용일자,
                    gu.Time as 이용시간
                    from GolfMember gm
                    inner join Lesson le
                    on gm.MNo=le.MNo
                    left join  GolfUsage gu
                    on gm.MNo = gu.MNo
                    where le.Fee >=250000
                    order by le.Fee desc ;
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
                    String MName = rs.getString("회원명");
                    String Coach = rs.getString("코치");
                    int Fee = rs.getInt("강습비");
                    String UDate = rs.getString("이용일자");
                    int Time = rs.getInt("이용시간");

                    System.out.println("회원명: " + MName +
                            " | 코치: " + Coach +
                            " | 강습비: " + Fee
                            + " | 이용일자: " + UDate
                            +" | 이용시간: " + Time
                    );
                } while (rs.next());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(pstmt, conn, rs);
        }

    }

    public void question01() {

            System.out.println("문제 1 A등급 회원의 이름, 전화번호, 가입일자를 조회하시오.");
            String sql = """
    select MName,Phone,JoinDate,Grade
    from GolfMember
    where Grade='A';
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
                        String MName = rs.getString("MName");
                        String Phone = rs.getString("Phone");
                        String JoinDate = rs.getString("JoinDate");
                        String Grade = rs.getString("Grade");

                        System.out.println("회원이름,: " + MName +
                                " | 전화번호,: " + Phone +
                                " | 가입일자: " + JoinDate
                        + " | 등급: " + Grade
                        );
                    } while (rs.next());
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                DBConnection.close(pstmt, conn, rs);
            }
        }


    public void deleteCustomerWithSales(int id) {
        System.out.println("회원과 판매 데이터 삭제 시작");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();

            // 1단계: 자식(lesson) 먼저 삭제
            String deleteSalesSql = "DELETE FROM hrdtest.lesson WHERE MNo = ?";
            pstmt = conn.prepareStatement(deleteSalesSql);
            pstmt.setInt(1, id);
            int salesDeleted = pstmt.executeUpdate();
            System.out.println("판매 데이터 " + salesDeleted + "행 삭제됨");
            pstmt.close();
//            1단계 자식 (golfusage)삭제
            String deleteSalesSql1 = "DELETE FROM hrdtest.golfusage WHERE MNo = ?";
            pstmt = conn.prepareStatement(deleteSalesSql1);
            pstmt.setInt(1, id);
            int salesDeleted1 = pstmt.executeUpdate();
            System.out.println("판매 데이터 " + salesDeleted1 + "행 삭제됨");
            pstmt.close();

            // 2단계: 부모(golfmember) 삭제
            String deleteMemberSql = "DELETE FROM hrdtest.golfmember WHERE MNo = ?";
            pstmt = conn.prepareStatement(deleteMemberSql);
            pstmt.setInt(1, id);
            int memberDeleted = pstmt.executeUpdate();
            System.out.println("회원 데이터 " + memberDeleted + "행 삭제됨");

            System.out.println("✅ 회원번호 " + id + " 완전 삭제 완료!");

        } catch (SQLException e) {
            System.out.println("❌ 삭제 실패!");
            e.printStackTrace();
        } finally {
            DBConnection.close(pstmt, conn);
        }
    }
    private void updateTable(String MName, String Grade) {
        System.out.println("데이터 수정 시작");

// PreparedStatement의 진짜 장점 활용! (SQL 인젝션 방지)
        String sql = "UPDATE hrdtest.GolfMember SET GolfMember.Grade = ? WHERE GolfMember.MName = ?;";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            // 값을 안전하게 바인딩
            pstmt.setString(1, Grade);      // 첫 번째 ? 에 급여
            pstmt.setString(2, MName);     // 두 번째 ? 에 이름

            int row = pstmt.executeUpdate();

            if (row > 0) {
                System.out.println("✅ " + MName + "님의 등급이 " + Grade + "으로 수정됨");
            } else {
                System.out.println("⚠️ " + MName + "님을 찾을 수 없습니다");
            }

        } catch (SQLException e) {
            System.out.println("❌ 데이터 수정 실패!");
            e.printStackTrace();
        } finally {
            DBConnection.close(pstmt, conn);
        }

    }




    private void insertGolfUsage() {

            System.out.println("GolfUsage 데이터 일괄 삽입 시작");

            // SQL 쿼리문 준비
            String sql = """
           insert into hrdtest.golfusage(MNo, UDate, Time, Cost) VALUE(?,?,?,?) ;
            """;

            String[][] value = {
                    {"1",  "2020-02-10","120", "24000"},
                    {"2", "2021-06-15","90", "18000"},
                    {"3",  "2022-04-20","150", "30000"}
            };

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                conn = DBConnection.getConnection();
                pstmt = conn.prepareStatement(sql);

                // 각 레슨 데이터를 순회하며 삽입
                for (int i = 0; i < value.length; i++) {
                    pstmt.setInt(1, Integer.parseInt(value[i][0]));     // MNo =1
                    pstmt.setString(2, (String) value[i][1]);          // UDate =2020-02-10
                    pstmt.setInt(3, Integer.parseInt(value[i][2]));         // Time =120
                    pstmt.setInt(4, Integer.parseInt(value[i][3]));     // Cost =24000

                    int row = pstmt.executeUpdate();
                    System.out.println((i + 1) + "번째 GolfUsage '" + value[i][0] + "' 삽입 완료! (" + row + "행)");
                }
            } catch (SQLException e) {
                System.out.println("❌ 데이터 삽입 실패!");
                e.printStackTrace();
            } finally {
                DBConnection.close(pstmt, conn);
            }

            System.out.println("--- 모든 GolfUsage 데이터 삽입 완료 ---");


    }

    private void insertLesson() {
        System.out.println(" Lesson 데이터 일괄 삽입 시작");

        // 계좌 개설 신청서 양식 준비
        String sql = """
                
                                    insert into hrdtest.Lesson(MNo, Coach, StartDate, Fee)
                                                                 VALUE(?,?,?,?);
                    
                    """;


        String[][] value = {
                {"1","김프로",   "2020-01-01", "300000" },
                {"2","박프로",   "2021-05-10", "250000"},
                {"3","이프로",   "2022-03-15", "200000"}
        };


        Connection conn = null;
        PreparedStatement pstmt = null;


        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            // 배열의 각 행(회원)을 반복


            for (int i = 0; i < value.length; i++) {
                pstmt.setInt(1, Integer.parseInt(value[i][0])); // MNo = 1
                pstmt.setString(2, (String) value[i][1]); // Coach = 김프로
                pstmt.setString(3, (String) value[i][2]); // StartDate = "2020-01-01"
                pstmt.setInt(4, Integer.parseInt(value[i][3])); // Grade = "A"



                int row = pstmt.executeUpdate();


                System.out.println((i + 1) + "번째 Lesson '" + value[i][0] + "' 삽입 완료! (" + row + "행)");
            }

            // 문제 발생시 대응 (catch)
        } catch (SQLException e) {

            System.out.println("❌ 데이터 삽입 실패!");
            e.printStackTrace();
        } finally {

            DBConnection.close(pstmt, conn);
        }

        System.out.println("--- 모든 Lesson 데이터 삽입 완료 ---");

    }

    private void insertGolfMember() {



            System.out.println(" GolfMember 데이터 일괄 삽입 시작");

            // 계좌 개설 신청서 양식 준비
            String sql = """
                
                    insert into hrdtest.GolfMember(MName, Phone, JoinDate, Grade)
                                             VALUE(?,?,?,?) ;
                    
                    """;


            String[][] shopmember = {
                    {"홍길동", "010-1111-2222",  "2020-01-01", "A" },
                    {"이순신", "010-3333-4444",  "2021-05-10", "B"},
                    {"강감찬", "010-5555-6666",  "2022-03-15", "C"}
            };


            Connection conn = null;
            PreparedStatement pstmt = null;


            try {
                conn = DBConnection.getConnection();
                pstmt = conn.prepareStatement(sql);

                // 배열의 각 행(회원)을 반복


                for (int i = 0; i < shopmember.length; i++) {
                    pstmt.setString(1, (String) shopmember[i][0]); // MName = 홍길동
                    pstmt.setString(2, (String) shopmember[i][1]); // Phone = "010-1234-5678"
                    pstmt.setString(3, (String) shopmember[i][2]); // JoinDate = "2020-01-01"
                    pstmt.setString(4, (String) shopmember[i][3]); // Grade = "A"



                    int row = pstmt.executeUpdate();


                    System.out.println((i + 1) + "번째 GolfMember '" + shopmember[i][0] + "' 삽입 완료! (" + row + "행)");
                }

                // 문제 발생시 대응 (catch)
            } catch (SQLException e) {

                System.out.println("❌ 데이터 삽입 실패!");
                e.printStackTrace();
            } finally {

                DBConnection.close(pstmt, conn);
            }

            System.out.println("--- 모든 GolfMember 데이터 삽입 완료 ---");

    }

    private void createTable() {
        System.out.println("--- 테이블 만들기 시작 ----");

        String sql1 = """
create table  hrdtest.GolfMember(
    MNo int primary key auto_increment comment '회원번호',
    MName varchar(30) not null comment '회원명',
    Phone varchar(13) unique comment '전화번호',
    JoinDate date not null comment '가입일자',
    Grade char(1),
    check ( Grade in ('A','B','C'))

);

""";
String sql2= """
        create table hrdtest.Lesson(
             LNo int primary key  auto_increment comment '강습번호',
             MNo int comment '회원번호',
             Coach varchar(30) not null comment '강사명',
             StartDate date not null  comment '강습시작일',
             Fee int comment '강습비',
            constraint chk_Fee_Positive check ( Fee >=0 ),
            foreign key (MNo) references GolfMember(MNo)
                                   on delete restrict
                                   on UPDATE cascade
        );
        
        
        """;
String sql3= """
        create table GolfUsage(
          UNo int primary key  auto_increment comment '이용번호',
            MNo int not null ,
            UDate date not null  comment '이용일자',
            Time int null comment '이용시간(분)',
            constraint chk_Time_Positive check ( Time >0 ),
              Cost int comment '이용 요금',
            constraint chk_Cost_NoNegative check ( Cost>=0 ),
            foreign key (MNo) references GolfMember(MNo)
                              on DELETE restrict
                              on UPDATE cascade
        
        );
        
        
        """;
        Connection conn = null;
        Statement stmt = null;

        try {
            conn = DBConnection.getConnection();



            stmt = conn.createStatement();
            System.out.println("GolfMember 테이블 만들기 시작");
            stmt.execute(sql1);
            System.out.println("GolfMember 테이블 만들기 완료");
            System.out.println("-----------");
            System.out.println("Lesson 테이블 만들기 시작");
            stmt.execute(sql2);
            System.out.println("Lesson 테이블 만들기 완료");
            System.out.println("-----------");
            System.out.println("GolfUsage 테이블 만들기 시작");
            stmt.execute(sql3);
            System.out.println("GolfUsage 테이블 만들기 완료");
            System.out.println("-----------");


        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("테이블 생성 실패");
        } finally {
            DBConnection.close(stmt, conn);
        }
        System.out.println("새로운 테이블생성 완료");
    }



}

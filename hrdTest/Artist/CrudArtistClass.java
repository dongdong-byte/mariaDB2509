import java.sql.*;





public class CrudArtistClass {
    CrudArtistClass(){


//        createTable();
//dropTable();
//        insertartisttable();
//        insertalbumtable();
//        아이유의 소속사를 '카카오엔터테인먼트'로 수정하시오.
//        updateTable("아이유","카카오엔터테인먼트");
//        question04();
    }

    public void question04() {

        System.out.println(" 심화문제 : 소속사별 매출현황을 구하시오");
        String sql = """
            select art.Agency as 소속사,count( distinct art.Agency) as 아티스트수,sum(alb.Sales) as 총판매량
                                                   from Artist art
                                                   inner join Album alb
                                                   on art.ArtistNo= alb.ArtistNo
                                                   group by art.Agency;
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
                    String Agency = rs.getString("소속사");
                    int count = rs.getInt("아티스트수");
                    int Sum = rs.getInt("총판매량");


                    System.out.println("소속사 : " + Agency +
                            " | 아티스트수 : " + count
                            +" | 총판매량 : " + Sum
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
        System.out.println("문제 3.아티스트별 총 판매량을 구하시오");
        String sql = """
            select  art.ArtistName  as 가수이름 , sum(alb.Sales) as 총판매량
            from Artist art
            inner join Album alb
            on alb.ArtistNo= art.ArtistNo
            group by art.ArtistNo , art.ArtistName;
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
                    String ArtistName = rs.getString("가수이름");
                    int Sales = rs.getInt("총판매량");


                    System.out.println("가수이름 : " + ArtistName +
                            " | 판매량 : " + Sales
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
        System.out.println("문제 2. 판매량이 1,000,000 이상인 앨범의 제목과 판매량을 조회.");
        String sql = """
            select AlbumTitle as 앨범제목 ,Sales as 판매량 from Album where Sales>=1000000;
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
                    String AlbumTitle = rs.getString("앨범제목");
                    int Sales = rs.getInt("판매량");


                    System.out.println("앨범제목 : " + AlbumTitle +
                            " | 판매량 : " + Sales
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

            System.out.println("문제 1.장르가 'K-POP'인 아티스트의 이름과 소속사를 조회하시오.");
            String sql = """
            select  ArtistName,Agency,Genre from Artist where Genre='K-pop';
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
                        String ArtistName = rs.getString("ArtistName");
                        String Agency = rs.getString("Agency");
                        String Genre = rs.getString("Genre");

                        System.out.println("아티스트 이름 : " + ArtistName +
                                " | 소속사 : " + Agency +
                                " | 장르 : " + Genre);
                    } while (rs.next());
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                DBConnection.close(pstmt, conn, rs);
            }

    }

    private void updateTable(String ArtistName,String Agency  ) {
        System.out.println("데이터 수정 시작");

// PreparedStatement의 진짜 장점 활용! (SQL 인젝션 방지)
        String sql = "update hrdtest.artist set  Agency=? where ArtistName=?;";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            // 값을 안전하게 바인딩
            pstmt.setString(1, Agency);      // 첫 번째 ? 에 가수 이름
            pstmt.setString(2, ArtistName);     // 두 번째 ? 에 이름

            int row = pstmt.executeUpdate();

            if (row > 0) {
                System.out.println(ArtistName + "님의 소속사가 " + Agency + "원으로 수정됨");
            } else {
                System.out.println(  ArtistName + "님을 찾을 수 없습니다");
            }

        } catch (SQLException e) {
            System.out.println("❌ 데이터 수정 실패!");
            e.printStackTrace();
        } finally {
            DBConnection.close(pstmt, conn);
        }

    }

    private void insertalbumtable() {
        System.out.println("앨범 데이터 일괄 삽입 시작");

        // 계좌 개설 신청서 양식 준비
        String sql = """
               
                               insert into hrdtest.Album(ArtistNo, AlbumTitle, ReleaseDate, Sales)
                                                               VALUE(?,?,?,?);""";


        String[][] Album = {
                {"1", "좋은 날", "2010-12-09", "500000"},
                {"2", "MAP OF THE SOUL: 7", "2020-02-21", "4300000"},
                {"3", "THE ALBUM", "2020-10-02", "1300000"}
        };


        Connection conn = null;
        PreparedStatement pstmt = null;


        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            // 배열의 각 행(회원)을 반복


            for (int i = 0; i < Album.length; i++) {
                pstmt.setInt(1, Integer.parseInt(Album[i][0])); // ArtistNo = 1
                pstmt.setString(2, (String) Album[i][1]); // AlbumTitle = "좋은 날"
                pstmt.setString(3, (String) Album[i][2]); // ReleaseDate = "2010-12-09"
                pstmt.setInt(4, Integer.parseInt(Album[i][3])); // Sales = 500000



                int row = pstmt.executeUpdate();


                System.out.println((i + 1) + "번째 앨범 '" + Album[i][0] + "' 삽입 완료! (" + row + "행)");
            }

            // 문제 발생시 대응 (catch)
        } catch (SQLException e) {

            System.out.println("❌ 데이터 삽입 실패!");
            e.printStackTrace();
        } finally {

            DBConnection.close(pstmt, conn);
        }

        System.out.println("--- 모든 앨범 데이터 삽입 완료 ---");


    }

    private void insertartisttable() {
        System.out.println("아티스트 데이터 일괄 삽입 시작");

        // 계좌 개설 신청서 양식 준비
        String sql = """
               
                insert into hrdtest.Artist(ArtistName, DebutDate, Genre, Agency)\s
                                             VALUE(?,?,?,?)""";


        String[][] Artist = {
                {"아이유", "2008-09-18", "발라드", "EDAM엔터테인먼트"},
                {"BTS", "2013-06-13", "K-POP", "하이브"},
                {"블랙핑크", "2016-08-08", "K-POP", "YG엔터테인먼트"}
        };


        Connection conn = null;
        PreparedStatement pstmt = null;


        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            // 배열의 각 행(회원)을 반복


            for (int i = 0; i < Artist.length; i++) {
                pstmt.setString(1, (String) Artist[i][0]); // ArtistName = 아이유
                pstmt.setString(2, (String) Artist[i][1]); // DebutDate = "2008-09-18"
                pstmt.setString(3, (String) Artist[i][2]); // Genre = "발라드"
                pstmt.setString(4, (String) Artist[i][3]); // Agency = "EDAM엔터테인먼트"



                int row = pstmt.executeUpdate();


                System.out.println((i + 1) + "번째 아티스트 '" + Artist[i][0] + "' 삽입 완료! (" + row + "행)");
            }

            // 문제 발생시 대응 (catch)
        } catch (SQLException e) {

            System.out.println("❌ 데이터 삽입 실패!");
            e.printStackTrace();
        } finally {

            DBConnection.close(pstmt, conn);
        }

        System.out.println("--- 모든 아티스트 데이터 삽입 완료 ---");
    }



    private void dropTable() {
        System.out.println("테이블 삭제 시작");

        String sql = """
            drop table *; 
    """;

        Connection conn = null;
        Statement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            stmt.execute(sql);
        } catch (SQLException e) {
            System.out.println("테이블 삭제 실패");
            e.printStackTrace();
        } finally {
            DBConnection.close(stmt, conn);
        }

        System.out.println("테이블 삭제 완료");
    }

    private void createTable() {
        System.out.println("--- 테이블 만들기 시작 ----");

        String sql1 = """
create table hrdtest.Artist(
     ArtistNo int primary key auto_increment comment '아티스트 번호',
     ArtistName varchar(30) not null unique comment '아티스트 명',
     DebutDate date not null comment '데뷔 일자',
     Genre varchar(20)not null comment '장르',
     Agency varchar(30) comment '소속사'
);
""";
String sql2 = """
        create table hrdtest.Album(
          AlbumNo int primary key  auto_increment comment '앨범번호',
          ArtistNo int comment '아티스트 번호',
          AlbumTitle varchar(50) not null comment '앨범명',
          ReleaseDate date not null comment '발매 일자',
          Sales int comment '판매량' ,
            check ( Sales>=0 ),
            foreign key (ArtistNo) references hrdtest.Artist(ArtistNo)
                                  );
        
        """;
        Connection conn = null;
        Statement stmt = null;

        try {
            conn = DBConnection.getConnection();



            stmt = conn.createStatement();
            System.out.println("첫번째 Artist 테이블 생성");
            stmt.execute(sql1);
            System.out.println("두번째 Album테이블 생성");
            stmt.execute(sql2);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("테이블 생성 실패");
        } finally {
            DBConnection.close(stmt, conn);
        }
        System.out.println("새로운 테이블생성 완료");
    }

    }



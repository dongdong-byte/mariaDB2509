package Book_hrdtest;

import java.sql.*;

public class CrudClass {
    public CrudClass() {
        //     인텔리제이 연결


//createTables();
//
//dropTables("member");
//insertTable("1","홍길동");

//deleteUsers();
//updateUsers();


    }

    public void question01_After2020() {
        System.out.println("2020년 이상 출판된 도서를 검색하시오.");
        String sql = "select * from hrdtest.book where Pubyear>=20";
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
try {
    conn = DBconnection.getConnection();
    pstmt = conn.prepareStatement(sql);
rs = pstmt.executeQuery();
if (!rs.next()) {
    System.out.println("2020년 이상 출판된 도서가 없습니다.");
}else {
    int rowCount = 0;
    do {
        rowCount++;
        int bookId = rs.getInt("BookID");
        String title = rs.getString("title");
        String author = rs.getString("author");
        String publisher = rs.getString("publisher");
        int price = rs.getInt("price");
        String pubYear = rs.getString("PubYear");
        System.out.println("도서ID: " + bookId +
                " | 도서명: " + title +
                " | 저자: " + author +
                " | 출판사: " + publisher +
                " | 가격: " + price + "원" +
                " | 출판연도: " + pubYear);


    }while (rs.next());




}


} catch (SQLException e) {
    e.printStackTrace();
}finally {
    DBconnection.close(rs, pstmt, conn);
}


    }






    private void createTables() {
        System.out.println("Creating tables --- start");
        String sql ="";
        Connection con = null;
        Statement stmt = null;
        try {
            con = DBconnection.getConnection();


            stmt = con.createStatement();
            stmt.execute(sql);

            System.out.println("테이블이 존재합니다.");
        }catch (SQLException e){
            System.out.println("❌ SQL 오류 발생:");
            e.printStackTrace();

        }finally {
            DBconnection.close(stmt,con);
        }
        System.out.println("Creating tables --- end");

    }



    public void question02() {

        System.out.println("‘홍길동’ 회원이 대출한 도서 목록을 출력하시오.");
        String sql = "SELECT\n" +
                "    m.Name AS 회원명,\n" +
                "    b.Title AS 도서명,\n" +
                "    b.Author AS 저자,\n" +
                "    r.RentDate AS 대출일,\n" +
                "    r.ReturnDate AS 반납일\n" +
                "\n" +
                "FROM hrdtest.Rental r\n" +
                "         JOIN hrdtest.Member m ON r.MemberID = m.MemberID\n" +
                "         JOIN hrdtest.Book b ON r.BookID = b.BookID\n" +
                "WHERE m.Name = '홍길동'\n" +
                ";";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBconnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (!rs.next()) {
                System.out.println("홍길동 회원의 대출 기록이 없습니다.");
            }else {
                int rowCount = 0;
                do {
                    rowCount++;
                    String name = rs.getString("회원명");

                    String Title = rs.getString("도서명");
                    String author = rs.getString("저자");
                    Date rentDate = rs.getDate("대출일");
                    Date returnDate = rs.getDate("반납일");
                    System.out.println("회원명: " + name +
                            " | 도서명: " + Title +
                            " | 저자: " + author +
                            " | 대출일: " + rentDate +
                            " | 반납일: " + (returnDate == null ? "-" : returnDate));




                }while (rs.next());




            }


        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBconnection.close(rs, pstmt, conn);
        }


    }

    public void question03() {
        System.out.println("반납하지 않은 도서를 검색하시오.");
        String sql = "SELECT\n" +
                "    b.BookID,\n" +
                "    b.Title AS 도서명,\n" +
                "    b.Author AS 저자,\n" +
                "    m.Name AS 대출회원,\n" +
                "    r.RentDate AS 대출일,\n" +
                "    '미반납' AS 반납여부\n" +
                "FROM Rental r\n" +
                "         JOIN Book b ON r.BookID = b.BookID\n" +
                "         JOIN Member m ON r.MemberID = m.MemberID\n" +
                "WHERE r.ReturnDate IS NULL";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBconnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (!rs.next()) {
                System.out.println("반납하지 않은 도서가 없습니다.");
            }else {
                int rowCount = 0;
                do {
                    rowCount++;
                    String name = rs.getString("대출회원");
                    String Title = rs.getString("도서명");
                    String author = rs.getString("저자");
                    Date rentDate = rs.getDate("대출일");
                    String return01 = rs.getString("반납여부");
                    System.out.println("대출회원: " + name +
                            " | 도서명: " + Title +
                            " | 저자: " + author +
                            " | 대출일: " + rentDate +
                            " | 반납여부: " +return01 );




                }while (rs.next());




            }


        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBconnection.close(rs, pstmt, conn);
        }


    }

    public void question04() {
        System.out.println("도서별 대출 횟수를 출력하시오.");
        String sql = "SELECT\n" +
                "    B.BookID,\n" +
                "    B.Title AS 도서명,\n" +
                "    B.Author AS 저자,\n" +
                "    COUNT(*) AS 대출횟수\n" +
                "FROM\n" +
                "    Rental AS R\n" +
                "        JOIN\n" +
                "    Book AS B ON B.BookID = R.BookID\n" +
                "GROUP BY\n" +
                "    B.BookID, B.Title, B.Author\n" +
                ";";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBconnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (!rs.next()) {
                System.out.println("도서별 대출 횟수가 안나옵니다.");
            }else {
                int rowCount = 0;
                do {
                    rowCount++;

                    String Title = rs.getString("도서명");
                    String author = rs.getString("저자");
                    int rentCount = rs.getInt("대출횟수");

                    System.out.println("  도서명: " + Title +
                            " | 저자: " + author +
                            " | 대출일: " + rentCount );





                }while (rs.next());




            }


        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBconnection.close(rs, pstmt, conn);
        }


    }


    public void question05() {
        System.out.println("가격이 가장 비싼 도서를 출력하시오..");
        String sql = "select Title , Author , Publisher, MAX(Price) as BiggestPrice ,Pubyear   from Book;";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBconnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (!rs.next()) {
                System.out.println("가격이 가장 비싼 도서가 안나옵니다.");
            }else {
                int rowCount = 0;
                do {
                    rowCount++;

                    String Title = rs.getString("Title");
                    String author = rs.getString("Author");
                    String publisher = rs.getString("Publisher");
                    int biggestPrice = rs.getInt("BiggestPrice");
                    int pubyear = rs.getInt("Pubyear");
                    System.out.println("도서명 : " + Title +
                    "| 저자 : " + author
                    +  "| 출판사 : " + publisher
                    +  "| 가장 비싼도서 : " + biggestPrice
                    + "| 출판일 : " + pubyear

                    );






                }while (rs.next());




            }


        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBconnection.close(rs, pstmt, conn);
        }
    }
}

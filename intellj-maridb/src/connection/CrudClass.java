package connection;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.sql.SQLException;
public class CrudClass {
    public CrudClass() {
        //     인텔리제이 연결


createTables();
//
dropTables("member");
//insertTable("1","홍길동");

//deleteUsers();
//updateUsers();
        selectUsers();
    }

    private void updateUsers(String id,String name) {

        System.out.println("레코드 수정 시작");
        String sql = "UPDATE users SET name=? WHERE id=?";
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = DBconnection.getConnection();
            pstmt =con.prepareStatement(sql);
            pstmt.setString(1,name);
            pstmt.setString(2,id);
            int rows = pstmt.executeUpdate();
            System.out.println("..........."+ rows +"행이 수정됨");
        }catch (SQLException ex) {
            ex.printStackTrace();
        }finally {
            DBconnection.close(pstmt ,con);
        }
        System.out.println("레코드 수정끝");


    }

    private void deleteUsers(String id) {
        System.out.println("Deleting users start");
        String query = "DELETE FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBconnection.getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, id);
            int rows = pstmt.executeUpdate();
            System.out.println("........"+  rows+" rows deleted");

        }catch (SQLException ex) {
            ex.printStackTrace();
        }finally {
            DBconnection.close( pstmt , conn);
            System.out.println("Deleting users end");
        }
    }

    private void insertTable(String id,String name) {
        System.out.println("Inserting Table start");
        System.out.println("삽입할 데이터 : ID="+ id+", Name=" + name );
        String sql = "insert into users(id, name) VALUE (?,?);";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBconnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, name);

            int rows = pstmt.executeUpdate();
            System.out.println("--------" + rows+ "행이 추가되었음");
        }catch (SQLException ex) {
            System.out.println("❌ 데이터 삽입 실패:");
            ex.printStackTrace();
        }finally {
            DBconnection.close( pstmt,conn);
        }
        System.out.println("Inserting Table end");
    }

    private void dropTables(String tableName ) {
        System.out.println("테이블 삭제  시작");
        String sql = "DROP TABLE IF EXISTS " + tableName;
        Connection conn = null;
        Statement stmt = null;
        try {
            conn = DBconnection.getConnection();
            stmt =conn.createStatement();
            int result =  stmt.executeUpdate(sql);
            System.out.println("✅ " + tableName + " 테이블 삭제 완료");
        }catch (SQLException ex){
            System.out.println("❌ " + tableName + " 테이블 삭제 실패:");
            ex.printStackTrace();
        }finally {
            DBconnection.close(stmt,conn);
        }
        System.out.println("테이블 삭제 끝");
    }

    private void createTables() {
        System.out.println("Creating tables --- start");
        String sql ="create table Rental(\n" +
                "    RentalID int primary key ,\n" +
                "    MemberID int ,\n" +
                "    BookID int,\n" +
                "    RentDate date,\n" +
                "    ReturnDate date\n" +
                "\n" +
                ");";
        Connection con = null;
        Statement stmt = null;
        try {
            con = DBconnection.getConnection();


            stmt = con.createStatement();
            stmt.execute(sql);

            System.out.println("users테이블이 존재합니다.");
        }catch (SQLException e){
            System.out.println("❌ SQL 오류 발생:");
            e.printStackTrace();

        }finally {
            DBconnection.close(stmt,con);
        }
        System.out.println("Creating tables --- end");

    }

    private void selectUsers() {
        System.out.println("레코드 내용 확인 Strat");
        String sql = "select * from users";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn =  DBconnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (!rs.next()) {
                System.out.println("user 테이블에 조회된 결과가 없음");
            }else {
                int rowCount = 0;
                do {
                    rowCount++;
                    String id = rs.getString("id");
                    String name = rs.getString("name");
                    System.out.println("id : " + id + " name : " + name);

                }while (rs.next());
                System.out.println("~~ 테이블에 : " + rowCount + " 행이 있음");
            }

        }catch (SQLException e){
            e.printStackTrace();

        }finally {
            DBconnection.close(rs,pstmt,conn);
        }

        System.out.println("----레코드 확인 end--------");



    }


}

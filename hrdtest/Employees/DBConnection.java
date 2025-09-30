import java.sql.*;

public class DBConnection {


    public static Connection getConnection() {

        //    DB접속
        String url = "jdbc:mariadb://localhost:3306/hrdtest";
        String user = "root";
        String password = "1234";
        Connection conn = null;
        try {
            //        jdbc드라이버 로드 (자바 6이상은 생략이 가능)
            Class.forName("org.mariadb.jdbc.Driver");
//     연결시도
            conn = DriverManager.getConnection(url, user, password);

            System.out.println("연결성공");

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.out.println("드라이버를 찾을수가 없다 : " + e.getMessage());

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("DB연결 실패" + e.getMessage());
        }
        return conn;
    }

// 데이터 자원을 닫는것 ->  은행 문을 열고 나오는 것
    public static void close(Statement stmt, Connection conn) {

        try {

            if (stmt != null && !stmt.isClosed()) //   statement 가 null이 아니라면-> Statement가 존재하는지 확인

                stmt.close();

        }catch (SQLException e){

            e.printStackTrace();
        }


        try {
            if (conn != null && conn.isClosed())// conn이 null이 아닌가?-> 입장권이 있는가?(은행에 들어온 상태)
                conn.close();
        }catch (SQLException e){
            e.printStackTrace();
        }


    }

// 은행 업무로 비교
    public static void close(PreparedStatement pstmt, Connection conn, ResultSet rs) {
//        전반적인 순서  REsultset->preparedSTatement->Connection

        try {
//       2.preparedstatement 닫기 (신청서 반납)
//if(pstmt != null) -> 신청서를 작성했나요?
//      && !pstmt.isClosed()-> 신청서 아직 처리중인가요?
            if(pstmt != null && !pstmt.isClosed())
//                pstmt.close()-> 신청서 직원에게 반납하기
//            입금 신청서" 작성 완료 → 직원에게 돌려주기
//"출금 신청서" 처리 완료 → 카운터에 놓고 오기
//더 이상 사용하지 않으니까 정리!
                pstmt.close();
        }catch (SQLException e){
            e.printStackTrace();
    }
//        3.  Connection닫기 (은행 퇴실)
//        if(conn != null)-> 은행에 실제로 들어갔나요?
//        && !conn.isClosed()-> 은행에 아직도 있나요?
//        conn.close();-> 은행문 열고 나가기
        try {
            if(conn != null && !conn.isClosed())
                conn.close();
        }catch (SQLException e){
        e.printStackTrace();
        }
        try {
//           1. resultset닫기 (받은서류/ 현금정리)
            //            if (rs != null) 실제로 뭔가를 넣었나요?
//            && !rs.isclosed -> 아직 지갑에 안 넣었나요?
//            rs.close():-> 지갑에 넣고 정리하기

//            예시 상황
//            잔액 조홰 했다면-> 명세세를 지갑에 넣기
//            돈을 인출했다면 -> 현금을 지갑에 넣기
//            계좌 이체 했다면 -> 영수증을 지갑에 넣기

            if(rs != null && !rs.isClosed())
                rs.close();
        }catch (SQLException e){
            e.printStackTrace();
        }
    }

    public static void close(
            PreparedStatement pstmt,
            Connection conn){


        try {
            if(pstmt != null && !pstmt.isClosed())
                pstmt.close();
        }catch (SQLException e) {
            e.printStackTrace();
        }

        try {
            if(conn != null && !conn.isClosed())
                conn.close();
        }catch (SQLException e){
            e.printStackTrace();
        }
    }

}


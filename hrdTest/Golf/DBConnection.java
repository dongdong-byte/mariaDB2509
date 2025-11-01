import java.sql.*;

public class DBConnection {
    public static Connection getConnection() {
        // DB접속
        String url = "jdbc:mariadb://localhost:3306/hrdtest";
        String user = "root";
        String password = "1234";
        Connection conn = null;

        try {
            // jdbc드라이버 로드 (자바 6이상은 생략이 가능)
            Class.forName("org.mariadb.jdbc.Driver");
            // 연결시도
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

    // 데이터 자원을 닫는것 -> 은행 문을 열고 나오는 것
    public static void close(Statement stmt, Connection conn) {
        try {
            if (stmt != null && !stmt.isClosed()) // statement가 존재하는지 확인
                stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null && !conn.isClosed()) // conn이 존재하는지 확인(은행에 들어온 상태)
                conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 은행 업무로 비교
    public static void close(PreparedStatement pstmt, Connection conn, ResultSet rs) {
        // 전반적인 순서: ResultSet -> PreparedStatement -> Connection
        try {
            // 1. ResultSet 닫기 (받은서류/현금정리)
            // rs가 null이 아닌지, 아직 닫히지 않았는지 확인
            if (rs != null && !rs.isClosed())
                rs.close(); // 지갑에 넣고 정리하기
            // 예: 잔액 조회 시 명세서 정리, 인출 시 현금 정리, 이체 시 영수증 정리
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {
            // 2. PreparedStatement 닫기 (신청서 반납)
            if (pstmt != null && !pstmt.isClosed())
                pstmt.close(); // 신청서 직원에게 반납
            // 예: 입금/출금 신청서 처리 완료 후 반납
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {
            // 3. Connection 닫기 (은행 퇴실)
            if (conn != null && !conn.isClosed())
                conn.close(); // 은행 문 열고 나가기
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void close(PreparedStatement pstmt, Connection conn) {
        try {
            if (pstmt != null && !pstmt.isClosed())
                pstmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null && !conn.isClosed())
                conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
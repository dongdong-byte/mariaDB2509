package Book_hrdtest;

// DBconnection.java - MariaDB 연결 설정 예시

import java.sql.*;

public class DBconnection {

    // 🔧 MariaDB 연결 정보 설정
    private static final String URL = "jdbc:mariadb://localhost:3306/hrdtest";
    private static final String USERNAME = "root"; // 예: root
    private static final String PASSWORD = "1234"; // 예: 1234
    private static final String DRIVER = "org.mariadb.jdbc.Driver";

    // 🔗 데이터베이스 연결 메서드
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // 1. 드라이버 로드 확인
            Class.forName(DRIVER);


            // 2. 연결 시도
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);


        } catch (ClassNotFoundException e) {
            System.out.println("❌ MariaDB 드라이버를 찾을 수 없습니다!");

            e.printStackTrace();

        } catch (SQLException e) {
            System.out.println("❌ 데이터베이스 연결 실패!");
            System.out.println("💡 확인사항:");
            System.out.println("1. MariaDB 서버가 실행 중인가?");
            System.out.println("2. 데이터베이스 이름이 정확한가? (" + URL + ")");
            System.out.println("3. 사용자명/비밀번호가 정확한가? (" + USERNAME + ")");
            System.out.println("4. 포트번호가 맞나? (기본: 3306)");
            e.printStackTrace();
        }

        return conn;
    }

    // 🗑️ Statement와 Connection 닫기
    public static void close(Statement stmt, Connection conn) {
        try {
            if (stmt != null) {
                stmt.close();

            }
            if (conn != null) {
                conn.close();

            }
        } catch (SQLException e) {
            System.out.println("❌ 자원 닫기 실패");
            e.printStackTrace();
        }
    }

    // 🗑️ PreparedStatement와 Connection 닫기 (오버로드)
    public static void close(ResultSet rs, PreparedStatement pstmt, Connection conn) {
        try {
            if (pstmt != null) {
                pstmt.close();

            }
            if (conn != null) {
                conn.close();



            }

            if (rs != null) {
                rs.close();

            }
        } catch (SQLException e) {
            System.out.println("❌ 자원 닫기 실패");
            e.printStackTrace();
        }
    }
}
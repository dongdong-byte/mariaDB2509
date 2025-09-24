package com.kim;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
public class DBConnection {
	
	// DB 접속정보
	
		static	String URL ="jdbc:mariadb://localhost:3306/employees";
		static	String user ="root";
		static	String passward ="1234";
			

	public static Connection getConnection() {
		// TODO Auto-generated method stub
		
		Connection conn = null;
	
		try {
		conn = DriverManager.getConnection(URL,user,passward);
		System.out.println("===.DB 연결성공=====");
		}catch(SQLException e) {
			e.printStackTrace();
			System.out.println("======DB연결실패=======");
		}
		return conn;
		}


	public static void close( Statement stmt, Connection conn) {
		try {
			if(stmt != null)
				stmt.close();
			
		}catch(SQLException e) {
			e.printStackTrace();
		}
		
		try {
			if(conn != null) {
				conn.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


	public static void close(ResultSet rs, PreparedStatement pstmt, Connection conn) {
		try {
			if(rs != null)
				rs.close();
			
		}catch(SQLException e) {
			e.printStackTrace();
		}
		try {
			if(pstmt != null)
				pstmt.close();
			
		}catch(SQLException e) {
			e.printStackTrace();
		}
		try {
			if(conn != null)
				conn.close();
			
		}catch(SQLException e) {
			e.printStackTrace();
		}
		
	}

}

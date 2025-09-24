package com.kim;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Connection;

public class Main {

	public static void main(String[] args) {
		
		
		Connection conn = null;

//		첫번째 방법
		//		try {
//		conn = DriverManager.getConnection(ur1,user,passward);
//		System.out.println("연결 성공");
//		
//		conn.close();
//		}catch(SQLException e) {
//			e.printStackTrace();
//		}
		
//		두번재 방법
		try {
			conn = DBConnection.getConnection();
		}finally{
//			연결해제
			
		}
		
		CROUDClass crudClass = new CROUDClass();
		
}

}

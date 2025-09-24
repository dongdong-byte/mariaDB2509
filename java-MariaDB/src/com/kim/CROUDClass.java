package com.kim;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class CROUDClass {

	public CROUDClass() {
//		create 테이블 -create table
		
		createTable();
//		
//		read 테이블 -select
		selectTable();
		
		
		
//		update 테이블 -update table
//		updateTable();
		
		
//		delete 테이블안에 row 삭제 - delete 
//		deleteUser();
		
//		insert
//		insertUser();
		
	}

	private void createTable() {
//		sql에 쓰인 table user구문은 절대 건드리지 말것!!!1
		String sql ="create table if not exists users(\r\n"
				+ "id varchar(50),\r\n"
				+ "name varchar(100)\r\n"
				+ ")";
		
		Connection conn = null;
		Statement stmt = null;
		try {
			conn = DBConnection.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sql);
			System.out.println("users 테이블 생성 완료");
		} catch (SQLException e) {
			e.printStackTrace();
			
		}finally {
			
//		DBConnection에서 연결정보를 관리해서 한곳에 통일하는것임 지금은 식이하나지만 여려개면ㅣ힘듬
//			finally에서 닫아줌
			DBConnection.close(stmt,conn);
		}
		
		
	}
	

	

	private void insertUser() {
		// TODO Auto-generated method stub
		
	}


	private void deleteUser() {
		// TODO Auto-generated method stub
		
	}


	private void selectTable() {
		String sql ="show tables";
		Connection conn = null;
		PreparedStatement pstmt =null; 
		ResultSet rs =null;
		
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			System.out.println(" ---------employees 데이터베이스 내에 테이블 확인------");
			while(rs.next()) {
//				String talName = rs.getString("tables_in_employees");
				String talName2 = rs.getNString(1);
//				System.out.println("["+talName+ "--" +talName2+ "]" );
				System.out.println("[" +talName2+ "]" );
				
			}
			System.out.println("-------------------------");
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			DBConnection.close(rs,pstmt,conn);
		}
		
	}

	

	

	private void updateTable() {
		// TODO Auto-generated method stub
		
	}
	
	
}
	

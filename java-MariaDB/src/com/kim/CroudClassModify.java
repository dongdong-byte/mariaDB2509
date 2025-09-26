package kim.Croud;

// Connection(연결) -> 데이터 베이스와 java 프로그램을 연결해주는 다리 역할
// 예시 -> 전화를 걸어서 상대방과 통화선을 연결하는것과 같음
//  Statement (명령문 실행기)
// sQL명령어를 데이터 베이스에 전달하고 실행하는 도구

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

import kim.Connection.DBConnection;

public class CroudClass {
//   메소드 실행 코드
	public CroudClass() {
		createtable();
		droptable();
		selectusers();
		insertusers();
		updateusers();
	}

private void updateusers() {
	// TODO Auto-generated method stub
	
}

private void insertusers() {
	// TODO Auto-generated method stub
	
}

private void selectusers() {
		// TODO Auto-generated method stub
		
	}

private void droptable() {
		// TODO Auto-generated method stub
		
	}

private void createtable() {
	 System.out.println("====새로운 테이블 생성 시작========");
	 String sql = null;
	 Connection conn= null;
	 Statement stmt=null;
	 PreparedStatement pstmt = null ;
	try {
// 이 연결이 있어야 데이터베이스에 명령을 보낼수가 있다. 
 		conn = DBConnection.getConnection();
//     connection을 통해 만들어진다.
// 		sQL문장등을 실행해준다.
// 		번역기처럼 java의 명령을 데이터 베이스가 이해할수 있게 전달해준다.
		 stmt = conn.createStatement();
		stmt.execute(sql);
		System.out.println("user 테이블이 존재 합니다.");
	} catch (SQLException e) {
//		SQLException 은 데이터 베이스 관련 작업에서만 발생하는 예외를 잡아내는 메소드이다
//		Exception 보다 더 구체적이다
//		Exception 는 모든 예외를 잡아내는데 SQLException는 데이터베이스 만의 예외를 잡는다.
		e.printStackTrace();
//		
	}finally {
//		finally 에서 닫아줘야하는 이유 
//		데이터 베이스 연결은 제한된 자원이다. 사용후 닫지 않으면
//		1. 메모리 누수발생 , 2.다른 프로그램이 데이터 베이스에 접근하지 못할수가있음
//		3.마치 전화를 끊지 않고 그대로 두는것과 같다.
		DBConnection.close(stmt,conn);
	}
}
	
}

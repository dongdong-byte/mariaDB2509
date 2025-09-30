import  java.sql.*;


public class EmployCrudClass {
 EmployCrudClass(){
//    createTable();
//    insertTable();
//    selectTable();
//     문제 : 이순신의 급여를 3,500,000원으로 수정하시오.
//    updateTable();
//     문제 : 사번이 1번인 사원의 정보를 삭제하시오.
    deleteTable(1);
//dropTable();
//question02();
}



    private void createTable() {
//     전체 은행 스토리 요약
//        1.은행입장 (connection)
//        2.창구에서 펜과종이를 받음 (statement)
//        3.서류 제출(execute(sql))
//        4.문제가 생기면 직원이 거부(catch)
//        5.일이 끝나면 은행에서 퇴장 , 펜과 종이 , 입장권 반납(finally)


        System.out.println("---테이블 만들기 시작----");
//        sql-> 내가 실행하고자하는 테이블 -> 은행에서 내가 보고자하는 업무
        String sql = """
create table if not exists Employees (
    EmpNo int primary key auto_increment,
    EmpName varchar(30) not null ,
    Dept varchar(20) not null ,
    HireDate date not null ,
    Salary int
)
 """;

        Connection conn = null;
        Statement stmt = null;
        try {

            conn = DBConnection.getConnection();
            System.out.println("연결 성공");

            stmt = conn.createStatement();


            stmt.execute(sql);
            System.out.println("테이블 생성완료");


        }catch (SQLException e){

            e.printStackTrace();
            System.out.println("테이블 생성 실패");
// 은행 업무가 성공하든 실패하든 영업이 끝나면 은행 문을 닫는것
        }finally {
//            창구 직원이 쓰던 펜과 종이(statment)를 반납
//             입장권 (connection)도 회수 -> 자리 정리
//            결론-> 은행에 나가면서 정리하고 나오는 과정
            DBConnection.close(stmt,conn);
        }
        System.out.println("새로운 테이블생성 완료");

    }
    private void insertTable() {System.out.println("데이터 삽입 시작");
        String sql = """
                insert into hrdtest.employees  (EmpName,Dept ,HireDate,Salary)
                    values (?,?,?,?)
                
                
                """;
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
//            자리 채우기
//            첫번째데이터
            pstmt.setString(1,"홍길동");
            pstmt.setString(2,"영업부");
            pstmt.setDate(3,java.sql.Date.valueOf("2020-03-01"));
            pstmt.setInt(4,2500000);
            pstmt.addBatch();

//            두번째 데이터
            pstmt.setString(1,"이순신");
            pstmt.setString(2,"인사부");
            pstmt.setDate(3,java.sql.Date.valueOf("2019-07-15"));
            pstmt.setInt(4,3200000);
            pstmt.addBatch();
//            세번째 데이터
            pstmt.setString(1,"강감찬");
            pstmt.setString(2,"개발부");
            pstmt.setDate(3,java.sql.Date.valueOf("2021-01-10"));
            pstmt.setInt(4,2800000);
            pstmt.addBatch();
// 한꺼번에 실행
            int [] result = pstmt.executeBatch();
            System.out.println(result.length + " 건 삽입완료");

//            preparedstatment는 executeupdate()를 사용한다
//            execute(sql)은 statement에서 사용하는 방식이다.
//            pstmt.executeUpdate(sql);-> 이거 statement 방식이라서 preparedstatement에서 저렇게 쓰면  JDBC 드라이버가 이마 닫힌 connnection으로 인식하거나 에러 메세지를 토해낼수가 잇다.
        }catch (SQLException e){
            e.printStackTrace();
            System.out.println("데이터 삽입 실패");
        }finally {
            DBConnection.close(pstmt,conn);
        }
        System.out.println("데이터 삽입 완료");





    }

    private void updateTable(  ) {
        System.out.println("데이터 수정  시작");
        String sql = "update hrdtest.employees set Salary=3500000 where EmpName='이순신';";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);


           int row = pstmt.executeUpdate();
            System.out.println("===="+ row +"행이 수정됨");

        } catch (SQLException e) {
            e.printStackTrace();

        }finally {
            DBConnection.close(pstmt,conn);
        }
    }

    public void question02() {
        System.out.println("문제 2.급여가 3,000,000원 이상인 사원의 이름과 부서를 조회하시오.");
//        은행 창구에 가서 "개발부" 직원 명단좀 보여주세요" 라고 요청서를 작성하는것 -> sql-> 은행 직원에게 보여줄 "업무 요청서"
        String sql = """
                select EmpNo,EmpName,Dept,Salary from hrdtest.employees where Salary>3000000;
        """;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
//            은행에 들어가서 창구와 연결되는 순간 -> DB 서버에 접속하는 단계 = 은행 창구 직원과 상담을 시작하는 느낌
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
//            rs = pstmt.executeQuery();-> 은행 창구 직원이 내부 시스템 (DB)를 뒤져서 조건에 맞는 자료를 찾아 오는 과정

            rs = pstmt.executeQuery();
            if(!rs.next()){
                System.out.println("조회된 결과가 없음");

            }else {
                int rowCount= 0;
                do {
//                    은행창구 직원이 결과 목록을 하나씩 꺼내서 "직원 ID: OOO, 이름: OOO, 급여: OOO" 이렇게 차례대로 읽어주는 상황.
                    rowCount++;
                    int EmpNo = rs.getInt("EmpNo");
                    String EmpName = rs.getString("EmpName");
                    String Dept = rs.getString("Dept");
                   int Salary = rs.getInt("Salary");
                    System.out.println( "직원 ID :" +EmpNo+
                            "| 직원이름 : " + EmpName
                            + " | 부서 : " + Dept
                            + " | 급여 : " + Salary



                    );

                }while (rs.next());


            }

        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBConnection.close(pstmt,conn,rs);
        }
    }
    public void selectTable() {
        System.out.println("문제 1.부서가 '개발부'인 사원의 사번, 이름, 급여를 조회하시오.");
//        은행 창구에 가서 "개발부" 직원 명단좀 보여주세요" 라고 요청서를 작성하는것 -> sql-> 은행 직원에게 보여줄 "업무 요청서"
        String sql = """
                select EmpNo,EmpName,Salary from hrdtest.employees where Dept = '개발부';
        """;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
//            은행에 들어가서 창구와 연결되는 순간 -> DB 서버에 접속하는 단계 = 은행 창구 직원과 상담을 시작하는 느낌
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
//            rs = pstmt.executeQuery();-> 은행 창구 직원이 내부 시스템 (DB)를 뒤져서 조건에 맞는 자료를 찾아 오는 과정

            rs = pstmt.executeQuery();
            if(!rs.next()){
                System.out.println("조회된 결과가 없음");

            }else {
                int rowCount= 0;
                do {
//                    은행창구 직원이 결과 목록을 하나씩 꺼내서 "직원 ID: OOO, 이름: OOO, 급여: OOO" 이렇게 차례대로 읽어주는 상황.
                    rowCount++;
                    int EmpNo = rs.getInt("EmpNo");
                    String EmpName = rs.getString("EmpName");
                    int Salary = rs.getInt("Salary");
                    System.out.println( "직원 ID :" +EmpNo+
                            "| 직원이름 : " + EmpName
                            + " | 급여 : " + Salary



                    );

                }while (rs.next());


            }

        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBConnection.close(pstmt,conn,rs);
        }
    }

    private void dropTable() {
        System.out.println("테이블 삭제 시작");
        String sql = """
                delete from hrdtest.employees
        """;
        Connection conn = null;
        Statement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt= conn.createStatement();
            stmt.execute(sql);
        }catch (SQLException e){
            System.out.println("테이블 삭제 실패");
            e.printStackTrace();
        }finally {
            DBConnection.close(stmt,conn);
        }
        System.out.println("테이블 삭제 완료");
    }



    public void deleteTable( int id) {
        System.out.println("레코드 삭제 시작");
        String sql = "delete from hrdtest.employees  where EmpNo=  " + id + ";";
        Connection conn =null;
        PreparedStatement pstmt  =null;


        try {

             conn = DBConnection.getConnection();
             pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            int row = pstmt.executeUpdate();
            System.out.println("======" + row +"행이 삭제됨");

        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBConnection.close(pstmt,conn);
        }
    }
}

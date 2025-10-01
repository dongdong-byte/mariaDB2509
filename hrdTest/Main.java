import java.sql.SQLException;

//TIP 코드를 <b>실행</b>하려면 <shortcut actionId="Run"/>을(를) 누르거나
// 에디터 여백에 있는 <icon src="AllIcons.Actions.Execute"/> 아이콘을 클릭하세요.
public class Main {
    public static  void main(String[] args) throws SQLException {
ShopManagerCrud shopManagerCrud  = new ShopManagerCrud();
// 1.고객등급이 A등급인 회원의 이름, 전화번호, 가입일자를 조회.
        shopManagerCrud.question01();
        System.out.println("====================");
//        2.가입일자가 2020년 이후인 회원을 조회하시오.
        shopManagerCrud.question02();
        System.out.println("====================");
// 3. 회원별 총 구매금액을 구하시오(출력: 회원번호, 회원성명, 총금액)
        System.out.println("====================");
        shopManagerCrud.question03();
//      4.가장 구매금액이 높은 회원의 이름과 금액을 조회하시오
        System.out.println("==================");
shopManagerCrud.question04();
        }
    }

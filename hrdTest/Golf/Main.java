//TIP 코드를 <b>실행</b>하려면 <shortcut actionId="Run"/>을(를) 누르거나
// 에디터 여백에 있는 <icon src="AllIcons.Actions.Execute"/> 아이콘을 클릭하세요.
public class Main {
    public static void main(String[] args) {


GolfCrudClass golfCrudClass = new GolfCrudClass();
//문제 1 A등급 회원의 이름, 전화번호, 가입일자를 조회하시오
        golfCrudClass.question01();
        System.out.println("============");
//        문제2.강습비가 250000 이상인 강습 내역을 조회.
        golfCrudClass.question02();
        System.out.println("================");
// 문제3. 회원별 총 이용요금을 집계. (출력: 회원명, 총요금)
        golfCrudClass.question03();
        System.out.println("================");
//       심화 문제 =“등급별 통계”->(등급, 회원 수, 평균 강습비, 총 이용요금)을 조회하시오.
golfCrudClass.question04();


        }
    }

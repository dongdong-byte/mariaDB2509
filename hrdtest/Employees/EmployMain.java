//TIP 코드를 <b>실행</b>하려면 <shortcut actionId="Run"/>을(를) 누르거나
// 에디터 여백에 있는 <icon src="AllIcons.Actions.Execute"/> 아이콘을 클릭하세요.
public class Main {
    public static void main(String[] args) {

EmployCrudClass employCrudClass = new EmployCrudClass();
// 1.부서가 '개발부'인 사원의 사번, 이름, 급여를 조회하시오.
        employCrudClass.selectTable();
        System.out.println("============");
// 2.급여가 3,000,000원 이상인 사원의 이름과 부서를 조회하시오.
employCrudClass.question02();
    }
}
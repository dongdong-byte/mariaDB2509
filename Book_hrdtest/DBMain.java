package Book_hrdtest;

public class DBMain {
    public static void main(String[] args) {
        CrudClass  crudClass =  new CrudClass();


//        1.2020년 이상(>=) 출판된 도서를 검색하시오.
//        crudClass.question01_After2020();
        System.out.println("====================");

//        2.‘홍길동’ 회원이 대출한 도서 목록을 출력하시오.
//        crudClass.question02();
        System.out.println("====================");
//        3.반납하지 않은 도서를 검색하시오.
//        crudClass.question03();
        System.out.println("====================");
//        4.도서별 대출 횟수를 출력하시오.
//crudClass.question04();
        System.out.println("====================");
//        5. 가격이 가장 비싼 도서를 출력하시오.
crudClass.question05();
    }
}

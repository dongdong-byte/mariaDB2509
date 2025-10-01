//TIP 코드를 <b>실행</b>하려면 <shortcut actionId="Run"/>을(를) 누르거나
// 에디터 여백에 있는 <icon src="AllIcons.Actions.Execute"/> 아이콘을 클릭하세요.
public class Main {
    public static void main(String[] args) {

CrudArtistClass crudArtistClass =  new CrudArtistClass() ;

// 문제 1.장르가 'K-POP'인 아티스트의 이름과 소속사를 조회.
        crudArtistClass.question01();
        System.out.println("==================");
//  문제 2. 판매량이 1,000,000 이상인 앨범의 제목과 판매량을 조회.
crudArtistClass.question02();
        System.out.println("==================");
// 문제 3.아티스트별 총 판매량을 구하시오
        crudArtistClass.question03();
        System.out.println("==================");
//   심화문제 : 소속사별 매출현황을 구하시오
        crudArtistClass.question04();
    }
}
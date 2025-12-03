show databases ;

create  database projectTest;

use projectTest;

CREATE TABLE CAR (
    -- 기본(기존) 컬럼
                     car_id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '차량 고유 ID',
                     brand           VARCHAR(50) NOT NULL COMMENT '브랜드 (예: 현대, 기아)',
                     model           VARCHAR(50) NOT NULL COMMENT '모델명 (예: 아반떼, 그랜저)',
                     year            INT NOT NULL COMMENT '연식 (예: 2024년형)',
                     grade           VARCHAR(50) COMMENT '등급 (예: 프레스티지)',
                     type            ENUM('COMPACT', 'SEDAN', 'SUV', 'VAN', 'TRUCK') COMMENT '차종 (경형, SUV, 승합 등)',
                     price_per_day   DECIMAL(15, 0) NOT NULL COMMENT '1일 대여료 (단기 렌트 기준가)',
                     status          ENUM('AVAILABLE', 'RENTED', 'MAINTENANCE') DEFAULT 'AVAILABLE' COMMENT '상태',

    -- 추가된 컬럼
                     zone_id         BIGINT COMMENT '지역 점소 ID (PICKUP_ZONE 테이블 FK)',
                     fuel_type       VARCHAR(20) COMMENT '연료 필터 (휘발유, 전기, 하이브리드)',
                     color           VARCHAR(20) COMMENT '색상 필터 (화이트, 블랙 등)',
                     passenger_limit INT COMMENT '인원수 필터 (5인승, 9인승 등)',
                     rent_type       ENUM('SHORT', 'LONG', 'BOTH') DEFAULT 'SHORT' COMMENT '장/단기 구분 (SHORT, LONG, BOTH)',
                     price_monthly   DECIMAL(15, 0) COMMENT '월 대여료 (장기 렌트 시 가격 표시용)',
                     discount_rate   INT DEFAULT 0 COMMENT '할인율 표시 (예: 50% 할인)',
                     description     TEXT COMMENT '차량 상세 설명 텍스트'
) COMMENT '차량 메인 테이블';

select * from CAR;

INSERT INTO CAR
(brand, model, year, grade, type, price_per_day, status, zone_id, fuel_type, color, passenger_limit, rent_type, price_monthly, discount_rate, description)
VALUES
-- 1. 경차/소형
('현대', '캐스퍼', 2024, '인스퍼레이션', 'COMPACT', 50000, 'AVAILABLE', 1, '휘발유', '카키', 4, 'SHORT', 0, 0, '귀여운 디자인의 경형 SUV'),
('기아', '레이', 2023, '시그니처', 'COMPACT', 45000, 'RENTED', 2, '휘발유', '화이트', 4, 'BOTH', 900000, 10, '공간 활용성이 뛰어난 박스카'),
('기아', '모닝', 2024, '프레스티지', 'COMPACT', 40000, 'AVAILABLE', 1, '휘발유', '베이지', 5, 'SHORT', 0, 5, '도심 주행에 최적화된 경차'),
('현대', '베뉴', 2023, '플럭스', 'COMPACT', 60000, 'AVAILABLE', 3, '휘발유', '그레이', 5, 'LONG', 1100000, 15, '혼라이프를 위한 소형 SUV'),

-- 2. 준중형/중형 세단
('현대', '아반떼', 2024, '모던', 'SEDAN', 70000, 'AVAILABLE', 1, '휘발유', '화이트', 5, 'BOTH', 1200000, 0, '국민 준중형 세단, 뛰어난 연비'),
('기아', 'K5', 2023, '노블레스', 'SEDAN', 85000, 'AVAILABLE', 2, '휘발유', '블랙', 5, 'SHORT', 0, 10, '스포티한 디자인의 중형 세단'),
('현대', '쏘나타', 2024, '프리미엄', 'SEDAN', 90000, 'MAINTENANCE', 4, 'LPG', '실버', 5, 'BOTH', 1400000, 5, '편안한 승차감의 패밀리 세단'),
('기아', 'K3', 2023, '트렌디', 'SEDAN', 65000, 'AVAILABLE', 1, '휘발유', '블루', 5, 'SHORT', 0, 20, '가성비 좋은 준중형'),

-- 3. 준대형/대형 세단
('현대', '그랜저', 2024, '캘리그래피', 'SEDAN', 130000, 'RENTED', 3, '하이브리드', '블랙', 5, 'BOTH', 2200000, 0, '플래그십 세단의 고급스러움'),
('제네시스', 'G80', 2024, '스포츠 패키지', 'SEDAN', 200000, 'AVAILABLE', 5, '휘발유', '우유니 화이트', 5, 'SHORT', 0, 0, '럭셔리 프리미엄 세단'),
('제네시스', 'G90', 2023, '기본형', 'SEDAN', 350000, 'AVAILABLE', 5, '휘발유', '비크 블랙', 5, 'SHORT', 0, 0, 'VIP 의전용 최고급 세단'),

-- 4. SUV
('기아', '스포티지', 2024, '노블레스', 'SUV', 95000, 'AVAILABLE', 2, '하이브리드', '정글 그린', 5, 'BOTH', 1500000, 10, '가장 인기 있는 준중형 SUV'),
('현대', '싼타페', 2024, '캘리그래피', 'SUV', 120000, 'RENTED', 4, '휘발유', '화이트', 7, 'SHORT', 0, 0, '넓은 공간의 패밀리 SUV'),
('현대', '투싼', 2023, '인스퍼레이션', 'SUV', 90000, 'AVAILABLE', 1, '경유', '그레이', 5, 'SHORT', 0, 15, '다이내믹한 디자인의 SUV'),
('제네시스', 'GV80', 2024, '기본형', 'SUV', 220000, 'AVAILABLE', 5, '휘발유', '카디프 그린', 5, 'LONG', 3500000, 5, '제네시스의 첫 번째 럭셔리 SUV'),
('현대', '코나 Electric', 2024, '프리미엄', 'SUV', 100000, 'AVAILABLE', 2, '전기', '레드', 5, 'SHORT', 0, 20, '전기차 특유의 정숙성과 가속력'),

-- 5. 승합/RV
('기아', '카니발', 2024, '시그니처', 'VAN', 150000, 'AVAILABLE', 3, '경유', '화이트', 9, 'BOTH', 2500000, 0, '9인승 패밀리 밴의 정석'),
('현대', '스타리아', 2023, '라운지', 'VAN', 140000, 'AVAILABLE', 4, 'LPG', '블랙', 7, 'SHORT', 0, 10, '우주선을 닮은 미래지향적 디자인'),

-- 6. 수입차
('벤츠', 'E-Class', 2023, 'AMG Line', 'SEDAN', 250000, 'AVAILABLE', 5, '휘발유', '실버', 5, 'SHORT', 0, 0, '프리미엄 비즈니스 세단'),
('BMW', '520i', 2024, 'M Sport', 'SEDAN', 240000, 'MAINTENANCE', 5, '휘발유', '카본 블랙', 5, 'BOTH', 3800000, 5, '다이내믹한 드라이빙의 즐거움');

select * from CAR ;

INSERT INTO CAR
(brand, model, year, grade, type, price_per_day, status, zone_id, fuel_type, color, passenger_limit, rent_type, price_monthly, discount_rate, description)
VALUES
-- 경차/소형
('쉐보레', '스파크', 2024, 'LT', 'COMPACT', 38000, 'AVAILABLE', 2, '휘발유', '오렌지', 4, 'SHORT', 0, 0, '경쾌한 도심형 경차'),
('현대', 'i10', 2023, '스마트', 'COMPACT', 42000, 'RENTED', 4, '휘발유', '레드', 5, 'BOTH', 850000, 5, '실용적인 시티카'),

-- 준중형/중형 세단
('현대', '아반떼 하이브리드', 2024, '프레스티지', 'SEDAN', 80000, 'AVAILABLE', 3, '하이브리드', '그레이', 5, 'LONG', 1350000, 10, '연비 끝판왕 하이브리드'),
('쉐보레', '말리부', 2023, 'RS', 'SEDAN', 88000, 'AVAILABLE', 1, '휘발유', '블랙', 5, 'SHORT', 0, 15, '미국식 중형 세단의 매력'),
('르노코리아', 'SM6', 2024, '시그니처', 'SEDAN', 75000, 'MAINTENANCE', 2, '휘발유', '화이트', 5, 'BOTH', 1250000, 20, '유럽 감성의 프렌치 세단'),

-- SUV
('기아', '쏘렌토', 2024, '그래비티', 'SUV', 110000, 'AVAILABLE', 1, '하이브리드', '블랙', 7, 'BOTH', 1800000, 0, '7인승 중형 SUV'),
('기아', '셀토스', 2023, '프레스티지', 'SUV', 78000, 'RENTED', 3, '휘발유', '화이트', 5, 'SHORT', 0, 10, '합리적인 소형 SUV'),
('쌍용', '토레스', 2024, 'T7', 'SUV', 85000, 'AVAILABLE', 4, '경유', '그린', 5, 'LONG', 1400000, 25, '레트로 감성의 SUV'),
('현대', '팰리세이드', 2024, '캘리그래피', 'SUV', 160000, 'AVAILABLE', 5, '경유', '네이비', 8, 'SHORT', 0, 0, '대형 SUV의 끝판왕'),
('제네시스', 'GV70', 2023, '스포츠', 'SUV', 190000, 'AVAILABLE', 5, '휘발유', '마틴 그레이', 5, 'BOTH', 3200000, 5, '컴팩트 럭셔리 SUV'),

-- 승합/RV
('기아', '카니발 하이리무진', 2024, 'VIP', 'VAN', 200000, 'AVAILABLE', 5, '경유', '블랙', 4, 'SHORT', 0, 0, '프리미엄 VIP 리무진'),
('현대', '스타리아 투어러', 2024, '라운지', 'VAN', 130000, 'RENTED', 2, '경유', '화이트', 11, 'BOTH', 2200000, 10, '단체 여행용 11인승'),

-- 전기차
('현대', '아이오닉6', 2024, '롱레인지', 'SEDAN', 110000, 'AVAILABLE', 1, '전기', '그래비티 골드', 5, 'BOTH', 1900000, 15, '공기역학적 전기 세단'),
('기아', 'EV6', 2024, 'GT-Line', 'SUV', 120000, 'AVAILABLE', 3, '전기', '문라이트 그레이', 5, 'SHORT', 0, 10, '고성능 전기 SUV'),
('테슬라', '모델Y', 2024, '롱레인지', 'SUV', 130000, 'MAINTENANCE', 2, '전기', '화이트', 5, 'LONG', 2300000, 5, '인기 전기 SUV'),

-- 수입차
('아우디', 'A6', 2023, '45 TFSI', 'SEDAN', 230000, 'AVAILABLE', 5, '휘발유', '나바라 블루', 5, 'SHORT', 0, 0, '독일 프리미엄 세단'),
('볼보', 'XC60', 2024, 'Inscription', 'SUV', 210000, 'AVAILABLE', 5, '하이브리드', '크리스탈 화이트', 5, 'BOTH', 3500000, 10, '북유럽 안전의 대명사'),
('렉서스', 'ES300h', 2024, 'Luxury', 'SEDAN', 220000, 'RENTED', 5, '하이브리드', '소닉 실버', 5, 'SHORT', 0, 0, '조용한 럭셔리 세단'),

-- 픽업트럭
('쌍용', '렉스턴 스포츠', 2023, '노블레스', 'TRUCK', 95000, 'AVAILABLE', 4, '경유', '그랜드 화이트', 5, 'LONG', 1600000, 20, '국산 픽업트럭');

CREATE TABLE CAR_OPTION (
                            option_id     BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '옵션 고유 ID',
                            name          VARCHAR(50) NOT NULL COMMENT '옵션명 (예: 네비게이션, 통풍시트)',
                            description   TEXT COMMENT '옵션 설명',

    -- 추가된 컬럼
                            car_id        BIGINT NOT NULL COMMENT '[필수] 차량 ID (CAR 테이블 FK)',
                            icon_url      VARCHAR(255) COMMENT '[UI 구현] 옵션 아이콘 이미지 경로',
                            is_essential  CHAR(1) DEFAULT 'N' COMMENT '[리스트] 목록에 노출할 주요 옵션 여부 (Y/N)',

    -- 외래키 설정 (CAR 테이블의 car_id 참조)
                            CONSTRAINT fk_option_car FOREIGN KEY (car_id) REFERENCES CAR(car_id) ON DELETE CASCADE
) COMMENT '차량 옵션 상세 테이블';

INSERT INTO CAR_OPTION
(car_id, name, description, is_essential, icon_url)
VALUES
-- 1. 경차/소형 (Car ID 1~4: 캐스퍼, 레이 등)
(1, '열선 스티어링 휠', '겨울철 필수, 따뜻한 핸들', 'Y', '/icons/heated_wheel.png'),
(1, '후방 카메라', '주차 보조를 위한 후방 영상 제공', 'Y', '/icons/rear_camera.png'),
(2, '2열 폴딩 시트', '뒷좌석을 접어 넓은 적재 공간 확보 가능', 'Y', '/icons/folding_seat.png'),
(3, '버튼 시동 스마트키', '버튼을 눌러 시동을 거는 스마트키 시스템', 'N', '/icons/smart_key.png'),
(4, '선루프', '개방감을 주는 일반형 선루프', 'N', '/icons/sunroof.png'),

-- 2. 준중형/중형 세단 (Car ID 5~8: 아반떼, K5, 쏘나타 등)
(5, '스마트폰 무선 충전', '패드 위에 올려두면 자동 충전', 'N', '/icons/wireless_charge.png'),
(5, '통풍 시트 (1열)', '여름철 쾌적한 운전을 위한 시트', 'Y', '/icons/vent_seat.png'),
(6, '드라이브 와이즈', '첨단 운전자 보조 시스템 (ADAS)', 'Y', '/icons/drive_wise.png'),
(6, '전자식 변속 다이얼', '다이얼 방식의 세련된 기어 노브', 'N', '/icons/dial_gear.png'),
(7, '보스(BOSE) 사운드', '프리미엄 사운드 시스템', 'N', '/icons/bose_sound.png'),
(8, 'LED 헤드램프', '야간 시인성이 뛰어난 LED 램프', 'Y', '/icons/led_lamp.png'),

-- 3. 고급/대형 세단 (Car ID 9~11: 그랜저, G80, G90)
(9, '헤드업 디스플레이 (HUD)', '전면 유리에 주행 정보 표시', 'Y', '/icons/hud.png'),
(9, '서라운드 뷰 모니터', '차량 주변 360도를 화면으로 확인', 'Y', '/icons/surround_view.png'),
(10, '고스트 도어 클로징', '문이 덜 닫히면 자동으로 닫아주는 기능', 'N', '/icons/ghost_door.png'),
(10, '에르고 모션 시트', '운전자 피로를 풀어주는 안마 기능 시트', 'N', '/icons/massage_seat.png'),
(11, '뒷좌석 듀얼 모니터', 'VIP를 위한 후석 엔터테인먼트 시스템', 'N', '/icons/rear_monitor.png'),

-- 4. SUV (Car ID 12~16: 스포티지, 싼타페, GV80 등)
(12, '파노라마 선루프', '지붕 전체가 열리는 넓은 개방감', 'Y', '/icons/pano_sunroof.png'),
(13, '차박 패키지', '평탄화 매트 및 220V 인버터 포함', 'N', '/icons/camping_pack.png'),
(13, '스마트 파워 테일게이트', '키를 소지하고 접근하면 트렁크 자동 오픈', 'Y', '/icons/power_trunk.png'),
(14, '4륜 구동 (4WD)', '험로 및 눈길 주행 안정성 확보', 'Y', '/icons/4wd.png'),
(15, '디지털 키 2', '스마트폰으로 도어 잠금/해제 및 시동', 'N', '/icons/digital_key.png'),
(16, 'V2L (Vehicle to Load)', '전기차 배터리로 외부 전자기기 사용 가능', 'Y', '/icons/v2l.png'),

-- 5. 승합/RV (Car ID 17~18: 카니발, 스타리아)
(17, '스마트 파워 슬라이딩 도어', '버튼 하나로 열리는 측면 자동문', 'Y', '/icons/sliding_door.png'),
(17, '후석 대화 모드', '운전석 마이크로 뒷좌석 승객과 대화', 'N', '/icons/talk_mode.png'),
(18, '스위블링 시트', '좌석을 회전시켜 마주보고 앉을 수 있음', 'Y', '/icons/swivel_seat.png'),

-- 6. 수입차 (Car ID 19~20: 벤츠 E-Class, BMW 520i)

(19, '엠비언트 라이트', '실내 분위기를 연출하는 무드 조명', 'N', '/icons/ambient_light.png'),
(20, '제스처 컨트롤', '손동작으로 오디오 볼륨 등 제어', 'N', '/icons/gesture.png'),
(20, 'M 스포츠 브레이크', '고성능 브레이크 시스템', 'Y', '/icons/m_brake.png');

select *from CAR_OPTION;

CREATE TABLE branch (
                        branch_id       BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '지점 고유 ID (CAR 테이블 zone_id와 연결)',
                        name            VARCHAR(50) NOT NULL COMMENT '지점명 (예: 부산역 카픽 센터)',
                        region_depth1   VARCHAR(20) NOT NULL COMMENT '지역 필터 (서울, 경기, 제주, 부산 등)',
                        branch_type     ENUM('AIRPORT', 'STATION', 'TERMINAL', 'ETC') DEFAULT 'ETC' COMMENT '지점 타입 (지도 아이콘 구분용)',
                        address         VARCHAR(255) NOT NULL COMMENT '상세 주소',
                        latitude        DECIMAL(10, 7) NOT NULL COMMENT '위도 (지도 마커용)',
                        longitude       DECIMAL(10, 7) NOT NULL COMMENT '경도 (지도 마커용)',
                        phone           VARCHAR(20) COMMENT '지점 연락처',
                        open_hours      VARCHAR(100) COMMENT '운영 시간 안내',
                        is_active       TINYINT DEFAULT 1 COMMENT '운영 여부 (1: 운영중, 0: 폐쇄)'
) COMMENT '지점(branch) 정보 테이블';

INSERT INTO branch
(name, region_depth1, branch_type, address, latitude, longitude, phone, open_hours, is_active)
VALUES
-- 1번 지점: 서울역 (도심 접근성 좋음, 경차/준중형 위주 배치 예상)
('서울역점', '서울', 'STATION', '서울시 용산구 한강대로 405 (서울역)', 37.554648, 126.972559, '02-1234-5678', '08:00 ~ 22:00', 1),

-- 2번 지점: 인천공항 (해외 입국자, 여행객 위주)
('인천공항점', '인천', 'AIRPORT', '인천시 중구 공항로 271 (인천국제공항)', 37.449339, 126.451339, '032-777-8888', '24시간 운영', 1),

-- 3번 지점: 부산역 (KTX 여행객, 관광)
('부산역점', '부산', 'STATION', '부산시 동구 중앙대로 206 (부산역)', 35.115225, 129.042243, '051-444-5555', '09:00 ~ 20:00', 1),

-- 4번 지점: 제주공항 (렌트카 수요 최다 지역)
('제주공항점', '제주', 'AIRPORT', '제주시 공항로 2 (제주국제공항)', 33.510413, 126.491353, '064-123-4567', '08:00 ~ 21:00', 1),

-- 5번 지점: 강남대로 (프리미엄/고급 세단 수요, 비즈니스)
('강남대로점', '서울', 'ETC', '서울시 강남구 강남대로 396', 37.497952, 127.027619, '02-555-6666', '09:00 ~ 18:00', 1);

-- (참고) 아까 만든 테이블 이름이 PICKUP_ZONE이었다면 BRANCH로 변경
-- RENAME TABLE PICKUP_ZONE TO BRANCH;

CREATE TABLE PICKUP_ZONE (
                             zone_id     BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '카픽존 고유 ID',
                             branch_id   BIGINT NOT NULL COMMENT '어느 지점 소속인지 (BRANCH 테이블 FK)',
                             name        VARCHAR(50) NOT NULL COMMENT '상세 위치명 (예: 제1주차장 3층)',
                             latitude    DECIMAL(10, 7) NOT NULL COMMENT '상세 픽업 위치 좌표 (위도)',
                             longitude   DECIMAL(10, 7) NOT NULL COMMENT '상세 픽업 위치 좌표 (경도)',
                             guide_info  TEXT COMMENT '셔틀/도보 안내 문구 (예: 3번 출구 셔틀 탑승)',
                             landmark    VARCHAR(100) COMMENT '근처 랜드마크 (찾기 쉽게)',
                             is_active   TINYINT DEFAULT 1 COMMENT '사용 가능 여부 (1: 사용, 0: 미사용)',

    -- 외래키 설정 (BRANCH 테이블이 존재해야 함)
                             CONSTRAINT fk_zone_branch FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id)
) COMMENT '지점 내 상세 픽업 구역 (주차장 등)';



INSERT INTO PICKUP_ZONE
(branch_id, name, latitude, longitude, guide_info, landmark, is_active)
VALUES
-- 1. 서울역점 (branch_id: 1)
(1, '롯데마트 주차장 4층', 37.555946, 126.970276, '서울역 1번 출구로 나와 롯데마트 엘리베이터 이용', '롯데마트 서울역점', 1),
(1, 'KDB생명타워 지하 3층', 37.553894, 126.972323, '12번 출구 앞 도보 3분, 지하주차장 B3-A구역', 'KDB생명타워', 1),

-- 2. 인천공항점 (branch_id: 2)
(2, '단기주차장 지상 1층', 37.447668, 126.452668, '여객터미널 건너편 단기주차장 H구역', '인천공항 단기주차장', 1),
(2, '장기주차장 셔틀존', 37.443555, 126.460111, '[셔틀 탑승] 1층 3번 게이트 앞 셔틀버스 이용하여 P1 주차장 하차', '장기주차장 타워', 1),

-- 3. 부산역점 (branch_id: 3)
(3, '부산역 선상주차장 A구역', 35.115666, 129.040555, '부산역 2층 대합실 연결 통로 이용', '부산역사 내', 1),
(3, '차이나타운 공영주차장', 35.114111, 129.038222, '부산역 1번 출구 길 건너 차이나타운 입구', '텍사스 거리 입구', 1),

-- 4. 제주공항점 (branch_id: 4) - 셔틀 필수
(4, '카픽 렌터카 하우스 1구역', 33.508555, 126.495222, '[셔틀 탑승] 5번 게이트 앞 횡단보도 건너 렌터카 하우스 3구역에서 셔틀 탑승 (15분 간격)', '렌터카 하우스', 1),
(4, '카픽 렌터카 하우스 2구역', 33.508666, 126.495333, '[셔틀 탑승] 5번 게이트 앞 횡단보도 건너 렌터카 하우스 3구역에서 셔틀 탑승 (15분 간격)', '렌터카 하우스', 1),

-- 5. 강남대로점 (branch_id: 5)
(5, '메리츠타워 지하 4층', 37.497555, 127.028444, '강남역 2번 출구 바로 앞 건물 지하주차장', '메리츠타워', 1);

CREATE TABLE RESERVATION (
                             reservation_id   BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '예약 고유 ID',
                             user_id          BIGINT NOT NULL COMMENT '예약자 ID (USERS 테이블 FK)',
                             car_id           BIGINT NOT NULL COMMENT '차량 ID (CAR 테이블 FK)',

    -- 픽업 및 반납 장소 (둘 다 PICKUP_ZONE 테이블 참조)
                             pickup_zone_id   BIGINT NOT NULL COMMENT '픽업 지점 ID (PICKUP_ZONE FK)',
                             return_zone_id   BIGINT NOT NULL COMMENT '반납 지점 ID (PICKUP_ZONE FK)',

                             insurance_type   VARCHAR(50) NOT NULL COMMENT '보험 정보 (일반자차, 완전자차 등)',
                             estimated_price  DECIMAL(15, 0) NOT NULL COMMENT '예상 결제 금액',
                             status           ENUM('PENDING', 'CONFIRMED', 'CANCELED', 'COMPLETED') DEFAULT 'PENDING' COMMENT '예약 상태',

                             start_date       DATETIME NOT NULL COMMENT '대여 시작 일시',
                             end_date         DATETIME NOT NULL COMMENT '대여 종료 일시',

                             created_at       DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '예약 생성일',

    -- 외래키(Foreign Key) 설정
                             CONSTRAINT fk_res_car FOREIGN KEY (car_id) REFERENCES CAR(car_id),

    -- ★ 핵심: 픽업존과 리턴존이 같은 테이블(PICKUP_ZONE)을 바라봄
                             CONSTRAINT fk_res_pickup FOREIGN KEY (pickup_zone_id) REFERENCES PICKUP_ZONE(zone_id),
                             CONSTRAINT fk_res_return FOREIGN KEY (return_zone_id) REFERENCES PICKUP_ZONE(zone_id)

    -- (USERS 테이블이 있다면 아래 주석 해제)
    -- CONSTRAINT fk_res_user FOREIGN KEY (user_id) REFERENCES USERS(user_id)
) COMMENT '차량 예약 정보 테이블';

INSERT INTO RESERVATION
(user_id, car_id, pickup_zone_id, return_zone_id, insurance_type, estimated_price, status, start_date, end_date)
VALUES
-- 1. [완료] 서울역에서 빌리고 반납 (단기) - 캐스퍼
(1, 1, 1, 1, '완전자차', 55000, 'COMPLETED', '2024-11-20 10:00:00', '2024-11-20 18:00:00'),

-- 2. [진행중] 제주 여행 (3박 4일) - 스포티지
(2, 12, 7, 7, '완전자차', 380000, 'CONFIRMED', '2025-12-01 14:00:00', '2025-12-04 14:00:00'),

-- 3. [예약] 주말 나들이 (강남) - 제네시스 G80
(3, 10, 9, 9, '일반자차', 400000, 'PENDING', '2025-12-07 09:00:00', '2025-12-08 20:00:00'),

-- 4. [★편도] 서울역 수령 -> 부산역 반납 (출장) - K5
(4, 6, 1, 5, '완전자차', 180000, 'CONFIRMED', '2025-12-05 08:00:00', '2025-12-05 15:00:00'),

-- 5. [예약] 인천공항 픽업 (귀국 의전) - 카니발
(5, 17, 3, 3, '완전자차', 150000, 'CONFIRMED', '2025-12-15 10:00:00', '2025-12-16 10:00:00'),

-- 6. [취소] 개인 사정으로 취소됨 - 아반떼
(1, 5, 2, 2, '일반자차', 70000, 'CANCELED', '2024-11-25 09:00:00', '2024-11-26 09:00:00'),

-- 7. [완료] 부산 여행 - 레이
(6, 2, 5, 5, '완전자차', 90000, 'COMPLETED', '2024-10-10 11:00:00', '2024-10-12 11:00:00'),

-- 8. [진행중] 강남 비즈니스 미팅 - 벤츠 E-Class
(7, 19, 9, 9, '슈퍼자차', 500000, 'CONFIRMED', '2025-12-02 09:00:00', '2025-12-03 09:00:00'),

-- 9. [예약] 겨울 스키장 여행 (SUV) - 싼타페
(8, 13, 1, 1, '완전자차', 240000, 'PENDING', '2025-12-20 08:00:00', '2025-12-22 20:00:00'),

-- 10. [★편도] 인천공항 -> 서울역 (외국인 친구 픽업) - 스타리아
(9, 18, 3, 1, '일반자차', 160000, 'CONFIRMED', '2025-12-10 13:00:00', '2025-12-10 16:00:00'),

-- 11. [장기] 한달 살기 (제주) - 코나 전기차
(2, 16, 8, 8, '완전자차', 1500000, 'CONFIRMED', '2025-01-01 10:00:00', '2025-01-31 10:00:00'),

-- 12. [완료] 잠깐 마실용 - 모닝
(3, 3, 2, 2, '일반자차', 20000, 'COMPLETED', '2024-11-15 14:00:00', '2024-11-15 16:00:00'),

-- 13. [예약] 가족 여행 - 팰리세이드 (데이터엔 없지만 13번차 투싼으로 대체)
(10, 14, 2, 2, '완전자차', 180000, 'PENDING', '2025-12-24 09:00:00', '2025-12-25 22:00:00'),

-- 14. [취소] 결제 실패로 인한 취소 - BMW 520i
(4, 20, 9, 9, '슈퍼자차', 480000, 'CANCELED', '2025-12-01 10:00:00', '2025-12-02 10:00:00'),

-- 15. [완료] 차 수리 맡긴 동안 대차 - 소나타
(5, 7, 5, 5, '일반자차', 180000, 'COMPLETED', '2024-11-01 09:00:00', '2024-11-03 18:00:00'),

-- 16. [진행중] 제주도 오픈카(?) 기분내기 - GV80
(6, 15, 7, 7, '완전자차', 440000, 'CONFIRMED', '2025-12-02 12:00:00', '2025-12-04 12:00:00'),

-- 17. [★편도] 부산 -> 서울 (이사 준비) - 스타리아
(8, 18, 6, 2, '완전자차', 200000, 'PENDING', '2025-12-30 08:00:00', '2025-12-30 18:00:00'),

-- 18. [예약] 연말 파티 - G90
(1, 11, 9, 9, '슈퍼자차', 700000, 'CONFIRMED', '2025-12-31 18:00:00', '2026-01-01 10:00:00'),

-- 19. [완료] 급한 업무 미팅 - 그랜저
(7, 9, 1, 1, '일반자차', 130000, 'COMPLETED', '2024-11-28 09:00:00', '2024-11-29 09:00:00'),

-- 20. [진행중] 서울 시내 주행 - 베뉴
(9, 4, 1, 1, '완전자차', 120000, 'CONFIRMED', '2025-12-01 10:00:00', '2025-12-03 10:00:00');
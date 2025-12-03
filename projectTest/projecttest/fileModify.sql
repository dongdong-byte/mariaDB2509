create database projecttest2;

use projecttest2;

-- 1. 기존 테이블과 충돌 방지를 위해 외래키 체크 잠시 해제
SET FOREIGN_KEY_CHECKS = 0;

-- 2. 기존 CAR 테이블이 있다면 삭제 (구조를 완전히 뜯어고치기 때문)
DROP TABLE IF EXISTS CAR;

-- -------------------------------------------------------
-- 여기서부터 새로 추가되는 테이블 (BRAND, MODEL, PRICE_POLICY)
-- -------------------------------------------------------

/* 1. BRAND (신규 추가) */
CREATE TABLE IF NOT EXISTS BRAND (
                                     brand_id       BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '브랜드 고유 ID',
                                     brand_name     VARCHAR(100) NOT NULL COMMENT '브랜드명 (예: Hyundai)',
                                     origin_country VARCHAR(100) COMMENT '제조국가'
) COMMENT '차량 제조사 브랜드 정보';

/* 2. MODEL (신규 추가) - 기존 CAR의 brand, model, fuel_type 등을 가져옴 */
CREATE TABLE IF NOT EXISTS MODEL (
                                     model_id        BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '모델 고유 ID',
                                     brand_id        BIGINT NOT NULL COMMENT '브랜드 ID (FK)',
                                     model_name      VARCHAR(100) NOT NULL COMMENT '모델명 (예: Avante)',
                                     fuel_type       VARCHAR(50) NOT NULL COMMENT '연료 타입',
                                     segment         VARCHAR(50) NOT NULL COMMENT '차종 (기존 type 컬럼 대체)',
                                     passenger_limit INT NOT NULL DEFAULT 5 COMMENT '승차 정원',
                                     transmission    VARCHAR(20) DEFAULT 'AUTO' COMMENT '변속기',
                                     CONSTRAINT fk_model_brand FOREIGN KEY (brand_id) REFERENCES BRAND(brand_id)
) COMMENT '차량 모델 및 제원 정보';

/* 3. PRICE_POLICY (신규 추가) - 기존 CAR의 가격 정보 분리 */
CREATE TABLE IF NOT EXISTS PRICE_POLICY (
                                            policy_id     BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '가격 정책 고유 ID',
                                            model_id      BIGINT NOT NULL COMMENT '모델 ID (FK)',
                                            price_daily   DECIMAL(15, 0) NOT NULL COMMENT '1일 대여료 (기존 price_per_day)',
                                            price_monthly DECIMAL(15, 0) NOT NULL COMMENT '월 대여료 (기존 price_monthly)',
                                            start_date    DATETIME NOT NULL COMMENT '정책 적용 시작일',
                                            end_date      DATETIME DEFAULT '9999-12-31 23:59:59' COMMENT '정책 적용 종료일',
                                            CONSTRAINT fk_price_model FOREIGN KEY (model_id) REFERENCES MODEL(model_id)
) COMMENT '모델별 기간 대여 요금 정책';

-- -------------------------------------------------------
-- 새로 다시 만드는 CAR 테이블 (다이어그램의 pickup_zone과 연결)
-- -------------------------------------------------------

/* 4. CAR (재생성) */
CREATE TABLE CAR (
                     car_id      BIGINT(20) AUTO_INCREMENT PRIMARY KEY COMMENT '차량 고유 ID',
                     model_id    BIGINT NOT NULL COMMENT '모델 ID (FK - 신규)',
                     zone_id     BIGINT(20) NOT NULL COMMENT '픽업존 ID (FK - 기존 pickup_zone 테이블 연결)',
                     car_number  VARCHAR(20) NOT NULL UNIQUE COMMENT '차량 번호판',
                     year        INT(11) NOT NULL COMMENT '연식',
                     color       VARCHAR(20) COMMENT '차량 색상',
                     mileage     INT DEFAULT 0 COMMENT '주행 거리',
                     status      ENUM('available', 'rented', 'maintenance') DEFAULT 'available' COMMENT '상태',
                     description TEXT COMMENT '차량 상제 설명',

    -- 신규 테이블(MODEL)과 연결
                     CONSTRAINT fk_car_model FOREIGN KEY (model_id) REFERENCES MODEL(model_id),

    -- [중요] 다이어그램에 있는 기존 pickup_zone 테이블과 연결
                     CONSTRAINT fk_car_zone_existing FOREIGN KEY (zone_id) REFERENCES pickup_zone(zone_id)
) COMMENT '실제 대여 가능한 차량 정보';

-- 5. 외래키 체크 다시 활성화
SET FOREIGN_KEY_CHECKS = 1;

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

-- 기존 데이터 충돌 방지 (필요시)
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------
-- 1. BRANCH (지점)
-- 다이어그램: name, region_depth1, branch_type, address, lat, lon, phone, open_hours, is_active
-- ---------------------------------------------------------
INSERT IGNORE INTO branch (branch_id, name, region_depth1, branch_type, address, latitude, longitude, phone, open_hours, is_active) VALUES
                                                                                                                                        (1, '서울 강남점', '서울', 'station', '서울 강남구 테헤란로 123', 37.4980, 127.0270, '02-123-4567', '09:00~20:00', 1),
                                                                                                                                        (2, '서울 홍대점', '서울', 'station', '서울 마포구 양화로 456', 37.5575, 126.9245, '02-987-6543', '24시간', 1),
                                                                                                                                        (3, '부산역점', '부산', 'station', '부산 동구 중앙대로 789', 35.1150, 129.0410, '051-123-4567', '08:00~22:00', 1),
                                                                                                                                        (4, '제주공항점', '제주', 'airport', '제주 제주시 공항로 100', 33.5104, 126.4913, '064-742-0000', '08:00~22:00', 1),
                                                                                                                                        (5, '인천공항점', '인천', 'airport', '인천 중구 공항로 200', 37.4601, 126.4406, '032-743-0000', '24시간', 1);

-- ---------------------------------------------------------
-- 2. PICKUP_ZONE (픽업존)
-- 다이어그램: branch_id(FK), name, lat, lon, guide_info, landmark, is_active
-- ---------------------------------------------------------
INSERT IGNORE INTO pickup_zone (zone_id, branch_id, name, latitude, longitude, guide_info, landmark, is_active) VALUES
                                                                                                                    (1, 1, '강남역 1번출구 주차장', 37.4980, 127.0270, '지하 3층 A구역', '강남역 1번출구', 1),
                                                                                                                    (2, 2, '홍대입구역 3번출구 앞', 37.5575, 126.9245, '도로변 정차 구역', '연남동 파출소 옆', 1),
                                                                                                                    (3, 3, '부산역 광장 픽업존', 35.1150, 129.0410, '광장 우측 렌트카 구역', '부산역 분수대', 1),
                                                                                                                    (4, 4, '제주공항 렌트카하우스', 33.5104, 126.4913, '5구역 3번 라인', '렌트카하우스 건물', 1),
                                                                                                                    (5, 5, '인천공항 제1터미널', 37.4601, 126.4406, '단기주차장 H구역', '지상 1층 횡단보도 앞', 1);

-- ---------------------------------------------------------
-- 3. BRAND (브랜드)
-- 다이어그램: brand_name, origin_country
-- ---------------------------------------------------------
INSERT INTO BRAND (brand_id, brand_name, origin_country) VALUES
                                                             (1, 'Hyundai', 'KOREA'),
                                                             (2, 'Kia', 'KOREA'),
                                                             (3, 'Genesis', 'KOREA'),
                                                             (4, 'BMW', 'GERMANY'),
                                                             (5, 'Mercedes-Benz', 'GERMANY')
ON DUPLICATE KEY UPDATE brand_name=brand_name; -- 중복 방지

-- ---------------------------------------------------------
-- 4. MODEL (모델)
-- 다이어그램: brand_id(FK), model_name, fuel_type, segment, passenger_limit, transmission
-- ---------------------------------------------------------
INSERT INTO MODEL (model_id, brand_id, model_name, fuel_type, segment, passenger_limit, transmission) VALUES
                                                                                                          (1, 1, 'The New Avante', 'GASOLINE', 'SEDAN', 5, 'AUTO'),
                                                                                                          (2, 1, 'Sonata The Edge', 'GASOLINE', 'SEDAN', 5, 'AUTO'),
                                                                                                          (3, 1, 'Grandeur GN7', 'HYBRID', 'SEDAN', 5, 'AUTO'),
                                                                                                          (4, 1, 'Tucson NX4', 'DIESEL', 'SUV', 5, 'AUTO'),
                                                                                                          (5, 1, 'Casper', 'GASOLINE', 'COMPACT', 4, 'AUTO'),
                                                                                                          (6, 2, 'K5 3rd Gen', 'GASOLINE', 'SEDAN', 5, 'AUTO'),
                                                                                                          (7, 2, 'Sorento MQ4', 'HYBRID', 'SUV', 7, 'AUTO'),
                                                                                                          (8, 2, 'Carnival KA4', 'DIESEL', 'RV', 9, 'AUTO'),
                                                                                                          (9, 3, 'G80', 'GASOLINE', 'SEDAN', 5, 'AUTO'),
                                                                                                          (10, 5, 'E-Class', 'GASOLINE', 'SEDAN', 5, 'AUTO')
ON DUPLICATE KEY UPDATE model_name=model_name;

-- ---------------------------------------------------------
-- 5. PRICE_POLICY (가격 정책)
-- 다이어그램: model_id(FK), price_daily, price_monthly, start_date, end_date
-- ---------------------------------------------------------
INSERT INTO PRICE_POLICY (model_id, price_daily, price_monthly, start_date, end_date) VALUES
                                                                                          (1, 55000, 700000, NOW(), '9999-12-31'),
                                                                                          (2, 70000, 950000, NOW(), '9999-12-31'),
                                                                                          (3, 110000, 1500000, NOW(), '9999-12-31'),
                                                                                          (4, 85000, 1100000, NOW(), '9999-12-31'),
                                                                                          (5, 40000, 500000, NOW(), '9999-12-31'),
                                                                                          (6, 68000, 920000, NOW(), '9999-12-31'),
                                                                                          (7, 95000, 1300000, NOW(), '9999-12-31'),
                                                                                          (8, 120000, 1600000, NOW(), '9999-12-31'),
                                                                                          (9, 180000, 2500000, NOW(), '9999-12-31'),
                                                                                          (10, 200000, 2800000, NOW(), '9999-12-31');

-- ---------------------------------------------------------
-- 6. CAR (차량 실물)
-- 다이어그램: model_id(FK), zone_id(FK), car_number, year, color, mileage, status, description
-- ---------------------------------------------------------
INSERT INTO CAR (model_id, zone_id, car_number, year, color, mileage, status, description) VALUES
                                                                                               (1, 1, '12가 3456', 2023, 'WHITE', 15000, 'available', '강남역 - 신차급 아반떼'),
                                                                                               (1, 2, '34나 5678', 2022, 'BLACK', 32000, 'rented', '홍대입구 - 장기 렌트 중'),
                                                                                               (2, 3, '56다 1234', 2024, 'SILVER', 5000, 'available', '부산역 - 출장용 추천'),
                                                                                               (3, 4, '78라 9012', 2023, 'BLACK', 12000, 'maintenance', '제주공항 - 정비 중'),
                                                                                               (4, 5, '90마 3456', 2022, 'GREY', 45000, 'available', '인천공항 - 짐 싣기 좋음'),
                                                                                               (5, 1, '11허 1111', 2024, 'KHAKI', 2000, 'available', '강남역 - 인기 경차 캐스퍼'),
                                                                                               (6, 2, '22하 2222', 2023, 'BLUE', 21000, 'rented', '홍대입구 - 데이트 추천'),
                                                                                               (7, 3, '33호 3333', 2023, 'WHITE', 18000, 'available', '부산역 - 가족 여행용 쏘렌토'),
                                                                                               (8, 4, '44가 4444', 2024, 'BLACK', 3000, 'available', '제주공항 - 9인승 카니발 리무진'),
                                                                                               (10, 5, '55나 5555', 2023, 'WHITE', 10000, 'available', '인천공항 - VIP 의전용 벤츠');

-- 외래키 체크 다시 활성화
SET FOREIGN_KEY_CHECKS = 1;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS reservation;

CREATE TABLE reservation (
                             reservation_id  BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '예약 고유 ID',

    -- 1. 예약 기본 정보
                             user_id         BIGINT COMMENT '회원 ID (비회원일 경우 NULL)',
                             car_id          BIGINT NOT NULL COMMENT '차량 ID (FK)',

    -- 2. 지점 및 일정 (요구사항: 지점 선택, 날짜 확인)
                             pickup_zone_id  BIGINT NOT NULL COMMENT '픽업 지점 ID (FK)',
                             return_zone_id  BIGINT NOT NULL COMMENT '반납 지점 ID (FK)',
                             start_date      DATETIME NOT NULL COMMENT '대여 시작 일시',
                             end_date        DATETIME NOT NULL COMMENT '대여 종료 일시',

    -- 3. 운전자 정보 (요구사항: 사용자 정보 입력, 비회원 대응)
                             driver_name     VARCHAR(50) NOT NULL COMMENT '실제 운전자 이름',
                             driver_phone    VARCHAR(20) NOT NULL COMMENT '운전자 연락처',
                             driver_birth    DATE COMMENT '운전자 생년월일 (보험 나이 확인용)',
                             license_kind    VARCHAR(50) COMMENT '면허 종류 (예: 2종 보통)',
                             license_number  VARCHAR(50) COMMENT '운전면허 번호',

    -- 4. 옵션 및 비용 (요구사항: 보험/부가서비스, 예상 비용)
                             insurance_type  VARCHAR(50) DEFAULT 'basic' COMMENT '보험 (none, basic, full_coverage)',
                             has_navi        BOOLEAN DEFAULT FALSE COMMENT '네비게이션 신청 여부',
                             has_baby_seat   BOOLEAN DEFAULT FALSE COMMENT '베이비시트 신청 여부',
                             has_dashcam     BOOLEAN DEFAULT FALSE COMMENT '블랙박스 신청 여부',

                             estimated_price DECIMAL(15, 0) NOT NULL COMMENT '예상 결제 금액',
                             final_price     DECIMAL(15, 0) COMMENT '실제 결제 금액 (연체/반납 후 확정)',

    -- 5. 상태 및 결제 (요구사항: 결제 페이지)
                             status          ENUM('pending', 'confirmed', 'canceled', 'completed', 'no_show') DEFAULT 'pending' COMMENT '예약 상태',
                             payment_status  ENUM('unpaid', 'paid', 'refunded') DEFAULT 'unpaid' COMMENT '결제 상태',
                             payment_method  VARCHAR(50) COMMENT '결제 수단 (CARD, NAVER_PAY 등)',

                             created_at      DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '예약 생성일',

    -- 외래키 연결
    -- user_id는 users 테이블이 있을 때만 연결 (없으면 주석 처리)
                             CONSTRAINT fk_reservation_user FOREIGN KEY (user_id) REFERENCES users(user_id),
                             CONSTRAINT fk_reservation_car FOREIGN KEY (car_id) REFERENCES car(car_id),
                             CONSTRAINT fk_res_pickup FOREIGN KEY (pickup_zone_id) REFERENCES pickup_zone(zone_id),
                             CONSTRAINT fk_res_return FOREIGN KEY (return_zone_id) REFERENCES pickup_zone(zone_id)
) COMMENT '차량 예약 및 결제 정보 (회원/비회원 통합)';

SET FOREIGN_KEY_CHECKS = 1;

SET FOREIGN_KEY_CHECKS = 0;

-- 기존 테이블이 있다면 삭제 (구조 변경 반영)
DROP TABLE IF EXISTS users;

CREATE TABLE users (
                       user_id       BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '회원 고유 ID',
                       email         VARCHAR(255) NOT NULL UNIQUE COMMENT '로그인 이메일 (중복 불가)',
                       password_hash VARCHAR(255) NOT NULL COMMENT '비밀번호 (암호화된 문자열)',
                       name          VARCHAR(100) NOT NULL COMMENT '사용자 이름',
                       phone         VARCHAR(20) NOT NULL COMMENT '휴대폰 번호',
                       birth_date    DATE COMMENT '생년월일 (만 21세/26세 확인용)',

    -- 스크린샷에 있던 추가 컬럼 반영
                       role          ENUM('USER', 'ADMIN') DEFAULT 'USER' COMMENT '권한 (일반유저, 관리자)',
                       grade         VARCHAR(20) DEFAULT 'SILVER' COMMENT '회원 등급 (SILVER, GOLD, VIP)',
                       profile_img   VARCHAR(255) COMMENT '프로필 이미지 URL',

                       created_at    DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
                       updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일'
) COMMENT '회원 정보 테이블';

SET FOREIGN_KEY_CHECKS = 1;


-- 회원 가데이터 (꼭 필요)
INSERT INTO users (user_id, email, password_hash, name, phone, birth_date, role, grade, created_at) VALUES
-- 1~5번: 예약 내역이 있는 일반 회원들
(1, 'hong@test.com', 'hashed_pw_1', '홍길동', '010-1111-1111', '1990-01-01', 'USER', 'GOLD', NOW()),
(2, 'kim@test.com', 'hashed_pw_2', '김철수', '010-2222-2222', '1985-05-05', 'USER', 'VIP', NOW()),
(3, 'lee@test.com', 'hashed_pw_3', '이영희', '010-3333-3333', '1995-12-25', 'USER', 'SILVER', NOW()),
(4, 'park@test.com', 'hashed_pw_4', '박지민', '010-4444-4444', '1992-07-07', 'USER', 'SILVER', NOW()),
(5, 'choi@test.com', 'hashed_pw_5', '최민수', '010-5555-5555', '1980-08-15', 'USER', 'GOLD', NOW()),

-- 6~9번: 신규 가입 회원 (예약 없음)
(6, 'kang@test.com', 'hashed_pw_6', '강다니', '010-6666-6666', '2000-01-01', 'USER', 'SILVER', NOW()),
(7, 'yoon@test.com', 'hashed_pw_7', '윤슬기', '010-7777-7777', '1998-03-01', 'USER', 'SILVER', NOW()),
(8, 'lim@test.com', 'hashed_pw_8', '임꺽정', '010-8888-8888', '1988-08-08', 'USER', 'VIP', NOW()),
(9, 'jang@test.com', 'hashed_pw_9', '장그래', '010-9999-9999', '1993-10-10', 'USER', 'SILVER', NOW()),

-- 10번: 관리자 계정 (role = ADMIN)
(10, 'admin@carrental.com', 'admin_pw_secure', '관리자', '010-0000-0000', '1980-01-01', 'ADMIN', 'MASTER', NOW());

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO reservation (
    user_id, car_id, pickup_zone_id, return_zone_id, start_date, end_date,
    driver_name, driver_phone, driver_birth, license_kind, license_number,
    insurance_type, has_navi, has_baby_seat, estimated_price,
    status, payment_status, payment_method
) VALUES
-- 1. 회원 예약 (일반)
(1, 1, 1, 1, '2025-05-01 10:00:00', '2025-05-03 10:00:00',
 '홍길동', '010-1111-1111', '1990-01-01', '1종 보통', '11-123456-11',
 'basic', TRUE, FALSE, 150000, 'confirmed', 'paid', 'CARD'),

-- 2. 비회원 예약 (user_id 없음)
(NULL, 2, 2, 2, '2025-05-05 09:00:00', '2025-05-06 09:00:00',
 '김비회', '010-9999-8888', '1995-05-05', '2종 보통', '12-987654-22',
 'full_coverage', TRUE, TRUE, 120000, 'confirmed', 'paid', 'NAVER_PAY'),

-- 3. 풀옵션 예약 (네비 + 베이비시트)
(2, 5, 3, 3, '2025-06-01 08:00:00', '2025-06-03 18:00:00',
 '이영희', '010-2222-2222', '1988-12-25', '2종 보통', '11-222222-33',
 'full_coverage', TRUE, TRUE, 350000, 'pending', 'unpaid', NULL),

-- 4. 편도 예약 (강남 픽업 -> 홍대 반납)
(3, 4, 1, 2, '2025-06-10 10:00:00', '2025-06-10 20:00:00',
 '박지민', '010-3333-3333', '1992-07-07', '1종 보통', '11-333333-44',
 'none', FALSE, FALSE, 80000, 'completed', 'paid', 'CARD'),

-- 5. 장기 렌트 (보험 없음)
(4, 8, 4, 4, '2025-07-01 10:00:00', '2025-07-31 10:00:00',
 '최민수', '010-4444-4444', '1985-03-01', '1종 대형', '11-444444-55',
 'none', TRUE, FALSE, 1500000, 'confirmed', 'paid', 'TRANSFER'),

-- 6~15. 다양한 케이스 추가
(NULL, 6, 2, 2, '2025-08-01 12:00:00', '2025-08-02 12:00:00', '박비회', '010-8888-7777', '1999-09-09', '2종 보통', '13-111111-99', 'basic', FALSE, FALSE, 70000, 'canceled', 'refunded', 'CARD'),
(1, 3, 1, 1, '2025-08-15 09:00:00', '2025-08-16 09:00:00', '홍길동', '010-1111-1111', '1990-01-01', '1종 보통', '11-123456-11', 'full_coverage', TRUE, FALSE, 110000, 'confirmed', 'paid', 'KAKAO_PAY'),
(2, 7, 3, 3, '2025-09-01 10:00:00', '2025-09-05 10:00:00', '이영희', '010-2222-2222', '1988-12-25', '2종 보통', '11-222222-33', 'basic', TRUE, TRUE, 450000, 'confirmed', 'paid', 'CARD'),
(NULL, 9, 5, 5, '2025-09-10 14:00:00', '2025-09-12 14:00:00', '정비회', '010-7777-6666', '1993-03-03', '1종 보통', '14-555555-88', 'full_coverage', FALSE, FALSE, 250000, 'pending', 'unpaid', NULL),
(3, 10, 5, 5, '2025-09-20 09:00:00', '2025-09-21 09:00:00', '박지민', '010-3333-3333', '1992-07-07', '1종 보통', '11-333333-44', 'basic', FALSE, FALSE, 200000, 'completed', 'paid', 'CARD'),
(5, 1, 1, 1, '2025-10-01 10:00:00', '2025-10-03 10:00:00', '김철수', '010-5555-5555', '1980-08-15', '1종 보통', '11-555555-66', 'none', TRUE, FALSE, 120000, 'confirmed', 'paid', 'CARD'),
(NULL, 2, 2, 2, '2025-10-05 10:00:00', '2025-10-06 10:00:00', '최비회', '010-6666-5555', '1998-11-11', '2종 보통', '15-777777-00', 'basic', FALSE, FALSE, 60000, 'no_show', 'unpaid', NULL),
(1, 5, 1, 1, '2025-11-01 09:00:00', '2025-11-01 18:00:00', '홍길동', '010-1111-1111', '1990-01-01', '1종 보통', '11-123456-11', 'full_coverage', TRUE, FALSE, 55000, 'confirmed', 'paid', 'NAVER_PAY'),
(4, 6, 2, 2, '2025-11-10 10:00:00', '2025-11-12 10:00:00', '최민수', '010-4444-4444', '1985-03-01', '1종 대형', '11-444444-55', 'basic', FALSE, TRUE, 180000, 'confirmed', 'paid', 'CARD'),
(2, 8, 4, 4, '2025-12-24 10:00:00', '2025-12-26 10:00:00', '이영희', '010-2222-2222', '1988-12-25', '2종 보통', '11-222222-33', 'full_coverage', TRUE, TRUE, 300000, 'pending', 'unpaid', NULL);

SET FOREIGN_KEY_CHECKS = 1;
-- 1. 외래키 체크 해제 (순서 상관없이 생성/삭제를 위해 필수)
SET FOREIGN_KEY_CHECKS = 0;

-- 2. 기존 테이블 초기화 (순서 중요하지 않음)
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS price_policy;
DROP TABLE IF EXISTS model;
DROP TABLE IF EXISTS pickup_zone;
DROP TABLE IF EXISTS branch;
DROP TABLE IF EXISTS brand;
DROP TABLE IF EXISTS users;

-- -------------------------------------------------------
-- [1단계] 기초 테이블 생성 (부모 테이블)
-- -------------------------------------------------------

/* 1. USERS (회원) */
CREATE TABLE users (
                       user_id       BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '회원 고유 ID',
                       email         VARCHAR(255) NOT NULL UNIQUE COMMENT '로그인 이메일 (중복 불가)',
                       password_hash VARCHAR(255) NOT NULL COMMENT '비밀번호',
                       name          VARCHAR(100) NOT NULL COMMENT '사용자 이름',
                       phone         VARCHAR(20) NOT NULL COMMENT '휴대폰 번호',
                       birth_date    DATE COMMENT '생년월일',
                       role          ENUM('USER', 'ADMIN') DEFAULT 'USER' COMMENT '권한',
                       grade         VARCHAR(20) DEFAULT 'SILVER' COMMENT '등급',
                       profile_img   VARCHAR(255) COMMENT '프로필 이미지',
                       created_at    DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
                       updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '회원 정보 테이블';

/* 2. BRAND (브랜드) */
CREATE TABLE brand (
                       brand_id       BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '브랜드 고유 ID',
                       brand_name     VARCHAR(100) NOT NULL COMMENT '브랜드명',
                       origin_country VARCHAR(100) COMMENT '제조국가'
) COMMENT '차량 제조사 브랜드 정보';

/* 3. BRANCH (지점) */
CREATE TABLE branch (
                        branch_id       BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '지점 고유 ID',
                        name            VARCHAR(50) NOT NULL COMMENT '지점명',
                        region_depth1   VARCHAR(20) NOT NULL COMMENT '지역 필터',
                        branch_type     ENUM('AIRPORT', 'STATION', 'TERMINAL', 'ETC') DEFAULT 'ETC',
                        address         VARCHAR(255) NOT NULL COMMENT '상세 주소',
                        latitude        DECIMAL(10, 7) NOT NULL COMMENT '위도',
                        longitude       DECIMAL(10, 7) NOT NULL COMMENT '경도',
                        phone           VARCHAR(20) COMMENT '지점 연락처',
                        open_hours      VARCHAR(100) COMMENT '운영 시간',
                        is_active       TINYINT DEFAULT 1 COMMENT '운영 여부'
) COMMENT '지점 정보 테이블';

-- -------------------------------------------------------
-- [2단계] 중간 테이블 생성 (참조가 필요한 테이블)
-- -------------------------------------------------------

/* 4. PICKUP_ZONE (픽업존) - Branch 참조 */
CREATE TABLE pickup_zone (
                             zone_id     BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '픽업존 고유 ID',
                             branch_id   BIGINT NOT NULL COMMENT '지점 ID (FK)',
                             name        VARCHAR(50) NOT NULL COMMENT '상세 위치명',
                             latitude    DECIMAL(10, 7) NOT NULL COMMENT '위도',
                             longitude   DECIMAL(10, 7) NOT NULL COMMENT '경도',
                             guide_info  TEXT COMMENT '안내 문구',
                             landmark    VARCHAR(100) COMMENT '랜드마크',
                             is_active   TINYINT DEFAULT 1 COMMENT '사용 가능 여부',
                             CONSTRAINT fk_zone_branch FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
) COMMENT '지점 내 상세 픽업 구역';

/* 5. MODEL (모델) - Brand 참조 */
CREATE TABLE model (
                       model_id        BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '모델 고유 ID',
                       brand_id        BIGINT NOT NULL COMMENT '브랜드 ID (FK)',
                       model_name      VARCHAR(100) NOT NULL COMMENT '모델명',
                       fuel_type       VARCHAR(50) NOT NULL COMMENT '연료 타입',
                       segment         VARCHAR(50) NOT NULL COMMENT '차종',
                       passenger_limit INT NOT NULL DEFAULT 5 COMMENT '승차 정원',
                       transmission    VARCHAR(20) DEFAULT 'AUTO' COMMENT '변속기',
                       CONSTRAINT fk_model_brand FOREIGN KEY (brand_id) REFERENCES brand(brand_id)
) COMMENT '차량 모델 및 제원 정보';

/* 6. PRICE_POLICY (가격 정책) - Model 참조 */
CREATE TABLE price_policy (
                              policy_id     BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '가격 정책 고유 ID',
                              model_id      BIGINT NOT NULL COMMENT '모델 ID (FK)',
                              price_daily   DECIMAL(15, 0) NOT NULL COMMENT '1일 대여료',
                              price_monthly DECIMAL(15, 0) NOT NULL COMMENT '월 대여료',
                              start_date    DATETIME NOT NULL COMMENT '시작일',
                              end_date      DATETIME DEFAULT '9999-12-31 23:59:59' COMMENT '종료일',
                              CONSTRAINT fk_price_model FOREIGN KEY (model_id) REFERENCES model(model_id)
) COMMENT '모델별 기간 대여 요금 정책';

-- -------------------------------------------------------
-- [3단계] 최종 테이블 생성 (모든 것을 참조)
-- -------------------------------------------------------

/* 7. CAR (차량 실물) - Model, Pickup_zone 참조 */
CREATE TABLE car (
                     car_id      BIGINT(20) AUTO_INCREMENT PRIMARY KEY COMMENT '차량 고유 ID',
                     model_id    BIGINT NOT NULL COMMENT '모델 ID (FK)',
                     zone_id     BIGINT(20) NOT NULL COMMENT '픽업존 ID (FK)',
                     car_number  VARCHAR(20) NOT NULL UNIQUE COMMENT '차량 번호판',
                     year        INT(11) NOT NULL COMMENT '연식',
                     color       VARCHAR(20) COMMENT '차량 색상',
                     mileage     INT DEFAULT 0 COMMENT '주행 거리',
                     status      ENUM('available', 'rented', 'maintenance') DEFAULT 'available',
                     description TEXT COMMENT '차량 상세 설명',
                     CONSTRAINT fk_car_model FOREIGN KEY (model_id) REFERENCES model(model_id),
                     CONSTRAINT fk_car_zone_existing FOREIGN KEY (zone_id) REFERENCES pickup_zone(zone_id)
) COMMENT '실제 대여 가능한 차량 정보';

/* 8. RESERVATION (예약) - User, Car, Pickup_zone 참조 */
CREATE TABLE reservation (
                             reservation_id  BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '예약 고유 ID',
                             user_id         BIGINT COMMENT '회원 ID (비회원 NULL)',
                             car_id          BIGINT NOT NULL COMMENT '차량 ID (FK)',
                             pickup_zone_id  BIGINT NOT NULL COMMENT '픽업 지점 ID (FK)',
                             return_zone_id  BIGINT NOT NULL COMMENT '반납 지점 ID (FK)',
                             start_date      DATETIME NOT NULL COMMENT '대여 시작',
                             end_date        DATETIME NOT NULL COMMENT '대여 종료',

                             driver_name     VARCHAR(50) NOT NULL COMMENT '운전자 이름',
                             driver_phone    VARCHAR(20) NOT NULL COMMENT '운전자 연락처',
                             driver_birth    DATE COMMENT '운전자 생년월일',
                             license_kind    VARCHAR(50) COMMENT '면허 종류',
                             license_number  VARCHAR(50) COMMENT '면허 번호',

                             insurance_type  VARCHAR(50) DEFAULT 'basic',
                             has_navi        BOOLEAN DEFAULT FALSE,
                             has_baby_seat   BOOLEAN DEFAULT FALSE,
                             has_dashcam     BOOLEAN DEFAULT FALSE,

                             estimated_price DECIMAL(15, 0) NOT NULL COMMENT '예상 금액',
                             final_price     DECIMAL(15, 0) COMMENT '최종 금액',
                             status          ENUM('pending', 'confirmed', 'canceled', 'completed', 'no_show') DEFAULT 'pending',
                             payment_status  ENUM('unpaid', 'paid', 'refunded') DEFAULT 'unpaid',
                             payment_method  VARCHAR(50) COMMENT '결제 수단',
                             created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,

                             CONSTRAINT fk_reservation_user FOREIGN KEY (user_id) REFERENCES users(user_id),
                             CONSTRAINT fk_reservation_car FOREIGN KEY (car_id) REFERENCES car(car_id),
                             CONSTRAINT fk_res_pickup FOREIGN KEY (pickup_zone_id) REFERENCES pickup_zone(zone_id),
                             CONSTRAINT fk_res_return FOREIGN KEY (return_zone_id) REFERENCES pickup_zone(zone_id)
) COMMENT '차량 예약 및 결제 정보';


-- -------------------------------------------------------
-- [4단계] 데이터 삽입 (순서대로)
-- -------------------------------------------------------

-- 1. USERS
INSERT INTO users (user_id, email, password_hash, name, phone, birth_date, role, grade, created_at) VALUES
                                                                                                        (1, 'hong@test.com', 'hashed_pw_1', '홍길동', '010-1111-1111', '1990-01-01', 'USER', 'GOLD', NOW()),
                                                                                                        (2, 'kim@test.com', 'hashed_pw_2', '김철수', '010-2222-2222', '1985-05-05', 'USER', 'VIP', NOW()),
                                                                                                        (3, 'lee@test.com', 'hashed_pw_3', '이영희', '010-3333-3333', '1995-12-25', 'USER', 'SILVER', NOW()),
                                                                                                        (4, 'park@test.com', 'hashed_pw_4', '박지민', '010-4444-4444', '1992-07-07', 'USER', 'SILVER', NOW()),
                                                                                                        (5, 'choi@test.com', 'hashed_pw_5', '최민수', '010-5555-5555', '1980-08-15', 'USER', 'GOLD', NOW()),
                                                                                                        (6, 'kang@test.com', 'hashed_pw_6', '강다니', '010-6666-6666', '2000-01-01', 'USER', 'SILVER', NOW()),
                                                                                                        (7, 'yoon@test.com', 'hashed_pw_7', '윤슬기', '010-7777-7777', '1998-03-01', 'USER', 'SILVER', NOW()),
                                                                                                        (8, 'lim@test.com', 'hashed_pw_8', '임꺽정', '010-8888-8888', '1988-08-08', 'USER', 'VIP', NOW()),
                                                                                                        (9, 'jang@test.com', 'hashed_pw_9', '장그래', '010-9999-9999', '1993-10-10', 'USER', 'SILVER', NOW()),
                                                                                                        (10, 'admin@carrental.com', 'admin_pw_secure', '관리자', '010-0000-0000', '1980-01-01', 'ADMIN', 'MASTER', NOW());

-- 2. BRAND
INSERT INTO brand (brand_id, brand_name, origin_country) VALUES
                                                             (1, 'Hyundai', 'KOREA'), (2, 'Kia', 'KOREA'), (3, 'Genesis', 'KOREA'), (4, 'BMW', 'GERMANY'), (5, 'Mercedes-Benz', 'GERMANY');

-- 3. BRANCH
INSERT INTO branch (branch_id, name, region_depth1, branch_type, address, latitude, longitude, phone, open_hours, is_active) VALUES
                                                                                                                                 (1, '서울 강남점', '서울', 'station', '서울 강남구 테헤란로 123', 37.4980, 127.0270, '02-123-4567', '09:00~20:00', 1),
                                                                                                                                 (2, '서울 홍대점', '서울', 'station', '서울 마포구 양화로 456', 37.5575, 126.9245, '02-987-6543', '24시간', 1),
                                                                                                                                 (3, '부산역점', '부산', 'station', '부산 동구 중앙대로 789', 35.1150, 129.0410, '051-123-4567', '08:00~22:00', 1),
                                                                                                                                 (4, '제주공항점', '제주', 'airport', '제주 제주시 공항로 100', 33.5104, 126.4913, '064-742-0000', '08:00~22:00', 1),
                                                                                                                                 (5, '인천공항점', '인천', 'airport', '인천 중구 공항로 200', 37.4601, 126.4406, '032-743-0000', '24시간', 1);

-- 4. PICKUP_ZONE
INSERT INTO pickup_zone (zone_id, branch_id, name, latitude, longitude, guide_info, landmark, is_active) VALUES
                                                                                                             (1, 1, '강남역 1번출구 주차장', 37.4980, 127.0270, '지하 3층 A구역', '강남역 1번출구', 1),
                                                                                                             (2, 2, '홍대입구역 3번출구 앞', 37.5575, 126.9245, '도로변 정차 구역', '연남동 파출소 옆', 1),
                                                                                                             (3, 3, '부산역 광장 픽업존', 35.1150, 129.0410, '광장 우측 렌트카 구역', '부산역 분수대', 1),
                                                                                                             (4, 4, '제주공항 렌트카하우스', 33.5104, 126.4913, '5구역 3번 라인', '렌트카하우스 건물', 1),
                                                                                                             (5, 5, '인천공항 제1터미널', 37.4601, 126.4406, '단기주차장 H구역', '지상 1층 횡단보도 앞', 1);

-- 5. MODEL
INSERT INTO model (model_id, brand_id, model_name, fuel_type, segment, passenger_limit, transmission) VALUES
                                                                                                          (1, 1, 'The New Avante', 'GASOLINE', 'SEDAN', 5, 'AUTO'),
                                                                                                          (2, 1, 'Sonata The Edge', 'GASOLINE', 'SEDAN', 5, 'AUTO'),
                                                                                                          (3, 1, 'Grandeur GN7', 'HYBRID', 'SEDAN', 5, 'AUTO'),
                                                                                                          (4, 1, 'Tucson NX4', 'DIESEL', 'SUV', 5, 'AUTO'),
                                                                                                          (5, 1, 'Casper', 'GASOLINE', 'COMPACT', 4, 'AUTO'),
                                                                                                          (6, 2, 'K5 3rd Gen', 'GASOLINE', 'SEDAN', 5, 'AUTO'),
                                                                                                          (7, 2, 'Sorento MQ4', 'HYBRID', 'SUV', 7, 'AUTO'),
                                                                                                          (8, 2, 'Carnival KA4', 'DIESEL', 'RV', 9, 'AUTO'),
                                                                                                          (9, 3, 'G80', 'GASOLINE', 'SEDAN', 5, 'AUTO'),
                                                                                                          (10, 5, 'E-Class', 'GASOLINE', 'SEDAN', 5, 'AUTO');

-- 6. PRICE_POLICY
INSERT INTO price_policy (model_id, price_daily, price_monthly, start_date) VALUES
                                                                                (1, 55000, 700000, NOW()), (2, 70000, 950000, NOW()), (3, 110000, 1500000, NOW()),
                                                                                (4, 85000, 1100000, NOW()), (5, 40000, 500000, NOW()), (6, 68000, 920000, NOW()),
                                                                                (7, 95000, 1300000, NOW()), (8, 120000, 1600000, NOW()), (9, 180000, 2500000, NOW()),
                                                                                (10, 200000, 2800000, NOW());

-- 7. CAR
INSERT INTO car (model_id, zone_id, car_number, year, color, mileage, status, description) VALUES
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

-- 8. RESERVATION
INSERT INTO reservation (
    user_id, car_id, pickup_zone_id, return_zone_id, start_date, end_date,
    driver_name, driver_phone, driver_birth, license_kind, license_number,
    insurance_type, has_navi, has_baby_seat, estimated_price,
    status, payment_status, payment_method
) VALUES
      (1, 1, 1, 1, '2025-05-01 10:00:00', '2025-05-03 10:00:00', '홍길동', '010-1111-1111', '1990-01-01', '1종 보통', '11-123456-11', 'basic', TRUE, FALSE, 150000, 'confirmed', 'paid', 'CARD'),
      (NULL, 2, 2, 2, '2025-05-05 09:00:00', '2025-05-06 09:00:00', '김비회', '010-9999-8888', '1995-05-05', '2종 보통', '12-987654-22', 'full_coverage', TRUE, TRUE, 120000, 'confirmed', 'paid', 'NAVER_PAY'),
      (2, 5, 3, 3, '2025-06-01 08:00:00', '2025-06-03 18:00:00', '이영희', '010-2222-2222', '1988-12-25', '2종 보통', '11-222222-33', 'full_coverage', TRUE, TRUE, 350000, 'pending', 'unpaid', NULL),
      (3, 4, 1, 2, '2025-06-10 10:00:00', '2025-06-10 20:00:00', '박지민', '010-3333-3333', '1992-07-07', '1종 보통', '11-333333-44', 'none', FALSE, FALSE, 80000, 'completed', 'paid', 'CARD'),
      (4, 8, 4, 4, '2025-07-01 10:00:00', '2025-07-31 10:00:00', '최민수', '010-4444-4444', '1985-03-01', '1종 대형', '11-444444-55', 'none', TRUE, FALSE, 1500000, 'confirmed', 'paid', 'TRANSFER'),
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

-- 5. 외래키 체크 다시 활성화
SET FOREIGN_KEY_CHECKS = 1;
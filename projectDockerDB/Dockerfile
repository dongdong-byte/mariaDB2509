# 1. 자바 21 실행 환경 (Amazon Corretto 사용 - 가장 안정적)
FROM amazoncorretto:21

# 2. 작업 폴더 설정
WORKDIR /app

# 3. 빌드된 jar 파일 위치 변수
ARG JAR_FILE=build/libs/*.jar

# 4. jar 파일을 도커 안으로 복사
COPY ${JAR_FILE} app.jar

# 5. 실행 명령어
ENTRYPOINT ["java", "-jar", "app.jar"]
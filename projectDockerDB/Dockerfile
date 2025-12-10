# 1. 자바 21 (질문자님 버전) 환경을 가져온다
FROM amazoncorretto:21
# 2. 작업 폴더 설정
WORKDIR /app

# 3. 빌드된 jar 파일 위치 변수
ARG JAR_FILE=*.jar

# 4. jar 파일을 도커 안으로 복사
COPY ${JAR_FILE} app.jar

# 5. 실행 명령어
ENTRYPOINT ["java", "-jar", "app.jar"]
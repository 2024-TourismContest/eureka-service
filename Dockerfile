# syntax=docker/dockerfile:1.4
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /workspace

# 1) buildscript만 복사해서 의존성 캐시
COPY settings.gradle build.gradle gradlew ./
COPY gradle gradle/

# 2) 캐시된 장소에 의존성만 미리 받아두기
RUN --mount=type=cache,target=/root/.gradle \
    chmod +x gradlew && \
    ./gradlew dependencies --quiet

# 3) 실제 소스 복사 후 빌드
COPY src src/
RUN --mount=type=cache,target=/root/.gradle \
    ./gradlew clean bootJar -x test --parallel

FROM eclipse-temurin:17-jdk AS runner
WORKDIR /app
COPY --from=builder /workspace/build/libs/*.jar app.jar

ENTRYPOINT ["java","-jar","/app/app.jar"]
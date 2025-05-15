FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /workspace

COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./

RUN chmod +x gradlew
RUN ./gradlew clean build -x test

FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

COPY --from=builder /workspace/build/libs/*.jar app.jar

ENTRYPOINT ["java","-jar","/app/app.jar"]

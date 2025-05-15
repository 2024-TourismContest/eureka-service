FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /workspace

COPY . .

RUN chmod +x ./gradlew \
 && ./gradlew clean bootJar

FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

COPY --from=builder /workspace/build/libs/*.jar app.jar

ENTRYPOINT ["java","-jar","/app/app.jar"]

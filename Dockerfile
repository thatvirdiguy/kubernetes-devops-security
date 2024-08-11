# First stage: Build the application
FROM maven:3.8.5-openjdk-8 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

# Second stage: Create the final image
FROM adoptopenjdk/openjdk8:alpine-slim
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline
COPY --from=builder /app/target/*.jar /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]
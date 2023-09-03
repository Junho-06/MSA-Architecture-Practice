FROM openjdk:17-alpine

EXPOSE 8080

ARG JAR_FILE=build/libs/Spring-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} ./Spring-0.0.1.jar

ENTRYPOINT ["java", "-jar", "/Spring-0.0.1.jar"]
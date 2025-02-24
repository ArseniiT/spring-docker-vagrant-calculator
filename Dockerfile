FROM eclipse-temurin:17-jre-alpine
WORKDIR /vagrant
COPY target/calculator-0.0.1-SNAPSHOT.jar calculator-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java", "-jar", "calculator-0.0.1-SNAPSHOT.jar"]
EXPOSE 8080

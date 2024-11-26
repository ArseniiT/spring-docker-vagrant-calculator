# Use a minimal image with JRE for running the application
FROM eclipse-temurin:17-jre-alpine
WORKDIR /vagrant

# Copy the pre-built JAR file into the container
COPY ./build/libs/calculator-0.0.1-SNAPSHOT.jar calculator-0.0.1-SNAPSHOT.jar

# Specify the command to run the application
ENTRYPOINT ["java", "-jar", "calculator-0.0.1-SNAPSHOT.jar"]

# Expose the port the application listens on
EXPOSE 8080

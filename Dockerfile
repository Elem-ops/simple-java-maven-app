FROM maven:3.9.11-eclipse-temurin-21 AS build

WORKDIR /app

# Copy the pom.xml file to download dependencies.
COPY pom.xml .

# Download all the dependencies from the pom.xml file.
RUN mvn dependency:go-offline

# Copy the rest of the source code.
COPY src ./src

# Compile and package the application into a JAR file.
RUN mvn package -DskipTests

# Use lightweight image for the final image.
FROM eclipse-temurin:21-jre-ubi9-minimal

WORKDIR /app

# Copy the built JAR file from the 'build' stage.
COPY --from=build /app/target/*.jar app.jar

# Expose port 8080, which is the port the application runs on.
EXPOSE 8080

# The command to run the application when the container starts.
ENTRYPOINT ["java", "-jar", "app.jar"]

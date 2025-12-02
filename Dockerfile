# Stage 1: Build the application using Maven
FROM maven:3.8-openjdk-17 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml file to download dependencies
COPY pom.xml .

# Download all dependencies from pom.xml
RUN mvn dependency:go-offline

# Copy the rest of the application source code
COPY src ./src

# Package the application, skipping tests
RUN mvn clean package -DskipTests

# Stage 2: Create the final image
FROM eclipse-temurin:17-jre-jammy

# Set the working directory
WORKDIR /app

# Copy the .jar file from the build stage
# The artifact name is based on the pom.xml.
# Please adjust 'tutorhub-be-0.0.1-SNAPSHOT.jar' if your artifactId or version is different.
COPY --from=build /app/target/tutorhub-be-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8080
EXPOSE 8080

# Run the jar file with production profile
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=prod"]


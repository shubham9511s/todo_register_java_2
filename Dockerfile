# Stage 1: Build the application
FROM eclipse-temurin:17-jdk-alpine As build

WORKDIR /app

# Copy Gradle wrapper scripts and configuration
COPY gradlew gradlew.bat build.gradle settings.gradle /app/
COPY gradle /app/gradle

# Copy application source code
COPY src /app/src

# Build the application
RUN ./gradlew build



# Stage 2: Create the final image

FROM eclipse-temurin:17-jre-alpine


WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=build /app/build/libs/todo_register-0.0.1-SNAPSHOT.jar /app/todo_register-0.0.1-SNAPSHOT.jar


# Expose the port the application runs on
EXPOSE 8080



# Set the command to run the application
CMD ["java", "-jar", "/app/todo_register-0.0.1-SNAPSHOT.jar"]
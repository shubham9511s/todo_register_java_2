
# Stage 1: Build the application
FROM eclipse-temurin:17-jdk-alpine As build

WORKDIR /app

# Copy necessary files for Gradle build
COPY gradlew gradlew.bat build.gradle settings.gradle /app/
COPY gradle /app/gradle


COPY src /app/src

# Clean previous builds
RUN ./gradlew clean

# Remove previous build artifacts
RUN rm -rf /app/build

# Build the application
RUN ./gradlew build

# Stage 2: Create the final image
FROM eclipse-temurin:17-jre-alpine

# Add a non-privileged user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=build /app/build/libs/todo_register-0.0.1-SNAPSHOT.jar /app/todo_register-0.0.1-SNAPSHOT.jar

# Change ownership of the application files to the non-privileged user
RUN chown -R appuser:appgroup /app

# Expose the port the application runs on
EXPOSE 8080

# Switch to the non-privileged user
USER appuser

# Set the command to run the application
CMD ["java", "-jar", "/app/todo_register-0.0.1-SNAPSHOT.jar"]

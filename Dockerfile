# Use a Maven image to compile the application
FROM openjdk:17-jdk-slim AS build

WORKDIR /app

# Copy the entire project
COPY . .

RUN ./mvnw install -N

# Run the Maven build to download dependencies
RUN ./mvnw dependency:go-offline

# Package the application
RUN ./mvnw package -DskipTests

# Use a minimal base image for the runtime
FROM openjdk:17-jdk-slim as server
WORKDIR /app

# Copy the packaged JAR file from the build stage
COPY --from=build /app/server/target/*.jar app.jar

# Expose the application port

EXPOSE 7111

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]


# Use a minimal base image for the runtime
FROM openjdk:17-jdk-slim as client
WORKDIR /app

# Copy the packaged JAR file from the build stage
COPY --from=build /app/client/target/*.jar app.jar

# Expose the application port

EXPOSE 7211

# Run the application
# ENTRYPOINT ["java", "-jar", "app.jar"]
ENTRYPOINT ["java", "-jar", "app.jar"]

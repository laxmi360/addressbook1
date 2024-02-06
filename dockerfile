FROM maven:3.8.4-openjdk-11-slim AS build-stage

# Set the working directory inside the container
WORKDIR /app


# Copy the Maven project definition files
COPY pom.xml ./


# Download the dependencies needed for the build (cache them in a separate layer)
RUN mvn dependency:go-offline


# Copy the application source code
COPY src ./src

# Build the WAR file
RUN mvn package

FROM varakumar/mytomcat:latest
LABEL maintainer="chaitanya"
ADD ./target/*.war /usr/local/tomcat/webapps/
EXPOSE 9990
CMD ["catalina.sh", "run"]

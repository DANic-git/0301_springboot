# Start by building the application.
FROM bitnami/java:17 as build
ENV JDBC_URL=jdbc:postgresql://host.docker.internal:5432/db?user=app&password=pass
ENV HOME=/usr/app
RUN mkdir -p $HOME
WORKDIR $HOME
ADD . $HOME
RUN --mount=type=cache,target=/root/.m2 ./mvnw verify


FROM bitnami/java:17 as final

WORKDIR /app
COPY --from=build /usr/app/target/app.jar /app/app.jar
RUN ["chmod", "+x", "/app/app.jar"]
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
FROM openjdk:17 as build

WORKDIR /src
COPY . /src

RUN ./mvnw clean package

FROM openjdk:17

RUN mkdir /app
WORKDIR /app

COPY --from=build /src/target/transform-demo-ui-0.0.1-SNAPSHOT.jar /app/transform-demo-ui-0.0.1-SNAPSHOT.jar

ENTRYPOINT ["java", "-jar", "/app/transform-demo-ui-0.0.1-SNAPSHOT.jar"]
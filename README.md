# Week 03. Spring Boot Task (Slurm Навыкум "Build Containers!")

## Задача

Есть проект на [Spring Boot](https://docs.spring.io/spring-boot/docs/current/reference/html/), который собирается в исполняемый файл.

### Сборка

В проект уже вшит [Maven Wrapper](https://maven.apache.org/wrapper/) (инструмент сборки), поэтому никаких дополнительных инструментов, кроме Java 17 на сборочной машине не нужно

Сборка запускается командой:
```shell
./mvnw verify
```

Исполняемый файл, получаемый в результате сборки будет в `target/app.jar`, для запуска достаточно команды:
```shell
./target/app.jar
```

### Авто-тесты

В процессе сборки прогоняются авто-тесты (их отключать не нужно), авто-тесты требуют для своей работы СУБД PostgreSQL

По умолчанию, используется следующий URL для подключения: `jdbc:postgresql://localhost:5432/db?user=app&password=pass`

При необходимости, URL можно поменять, задав переменную окружения `JDBC_URL`

Схема и данные, необходимые для прохождения авто-тестов, расположены в каталоге [`docker-entrypoint-initdb.d`](docker-entrypoint-initdb.d)

### API

API доступно по адресу: `http://localhost:8080/api/items`

Healthcheck стандартный для [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)

## Что нужно сделать

1. С помощью образа [bitnami/java:17](https://hub.docker.com/r/bitnami/java/) собрать всё, прогнав авто-тесты (`./mvnw verify` и авто-тесты прогонит, и соберёт)
2. Запаковать результаты сборки в образ [bitnami/java:17](https://hub.docker.com/r/bitnami/java/), указав в качестве `ENTRYPOINT` `["app.jar"]`
3. Выложить всё в виде публичного образа на GHCR (GitHub Container Registry)

Нужно максимально использовать кэширование: если `pom.xml` не менялся, то желательно не прогонять заново скачивание зависимостей при сборке (так же, как JS-ники делают с `package.json`)

Вносить изменения в исходный код не нужно

Рекомендуется, но не обязательно, запускать приложение не от root

### Требования

1. Всё должно быть оформлено в виде публичного репозитория на GitHub
2. Вся сборка образов должна проходить через GitHub Actions
3. Образ должен выкладываться в GitHub Container Registry (GHCR)

К текущему заданию дополнительно предъявляются требования:
1. [Docker Buildx Build](https://docs.docker.com/build/) (указывайте явно при сборке `docker buildx build`)
2. Multi-Stage

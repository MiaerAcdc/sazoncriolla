# --- FASE 1: CONSTRUCCIÓN (BUILD) ---
# Usamos una imagen que incluye Maven (3.9.6) Y OpenJDK 20
FROM maven:3.9.6-openjdk-20 AS build

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de Maven y el código fuente
COPY pom.xml .
COPY src src

# Construye la aplicación usando 'mvn' directamente
RUN mvn clean package -DskipTests

# --- FASE 2: EJECUCIÓN (RUNTIME) ---
# Seguimos usando una imagen ligera de solo JRE 20 para el entorno de producción
FROM eclipse-temurin:20-jre

# Establece el directorio de trabajo para la ejecución
WORKDIR /app

# Copia el JAR generado
COPY --from=build /app/target/sazon.jar sazon.jar

# Expone el puerto por defecto de Spring Boot
EXPOSE 8080

# Comando para ejecutar la aplicación JAR
ENTRYPOINT ["java", "-jar", "sazon.jar"]

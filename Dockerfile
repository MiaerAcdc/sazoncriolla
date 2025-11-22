# --- FASE 1: CONSTRUCCIÓN (BUILD) ---
# Usamos una imagen con el JDK 20, necesario para compilar tu código Java 20.
FROM eclipse-temurin:20-jdk AS build

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia solo el pom.xml y el código fuente. 
# Se eliminaron las líneas COPY mvnw y COPY .mvn.
COPY pom.xml .

# Copia el código fuente de tu aplicación
COPY src src

# Construye la aplicación usando 'mvn' directamente
RUN mvn clean package -DskipTests

# --- FASE 2: EJECUCIÓN (RUNTIME) ---
# Usamos una imagen base ligera de solo JRE 20 para la ejecución en producción.
FROM eclipse-temurin:20-jre

# Establece el directorio de trabajo para la ejecución
WORKDIR /app

# Copia el JAR generado desde la fase de construcción ('build')
# Asumimos que el JAR se llama 'sazon.jar' y está en target/.
COPY --from=build /app/target/sazon.jar sazon.jar

# Expone el puerto por defecto de Spring Boot
EXPOSE 8080

# Comando para ejecutar la aplicación JAR
ENTRYPOINT ["java", "-jar", "sazon.jar"]

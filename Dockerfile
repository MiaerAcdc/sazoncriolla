# --- FASE 1: CONSTRUCCIÓN (BUILD) ---
# Usamos una imagen que contenga el JDK 20, que es necesario para compilar.
FROM eclipse-temurin:20-jdk AS build

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de configuración de Maven (pom.xml) y el wrapper
# Se hace antes del código fuente para aprovechar el cache de Docker (si pom.xml no cambia)
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Copia el código fuente de tu aplicación
COPY src src

# Construye la aplicación (genera el archivo JAR)
# El JAR se llama 'sazon.jar' (según finalName en pom.xml) y estará en /app/target/
RUN ./mvnw clean package -DskipTests

# --- FASE 2: EJECUCIÓN (RUNTIME) ---
# Usamos una imagen base ligera de solo JRE (Java Runtime Environment) para la ejecución.
# Corregido a '20-jre' que es una etiqueta válida.
FROM eclipse-temurin:20-jre

# Establece el directorio de trabajo para la ejecución
WORKDIR /app

# Copia el JAR generado desde la fase de construcción ('build')
# Nota: La ruta y nombre del JAR deben coincidir con la configuración de tu pom.xml.
# Asumimos que el JAR se llama 'sazon.jar' y está en target/.
COPY --from=build /app/target/sazon.jar sazon.jar

# Expone el puerto por defecto de Spring Boot
EXPOSE 8080

# Comando para ejecutar la aplicación JAR
ENTRYPOINT ["java", "-jar", "sazon.jar"]

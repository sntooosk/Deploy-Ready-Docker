# Estágio de construção
FROM ubuntu:latest AS build

# Atualiza o repositório de pacotes e instala o OpenJDK 21 e o Maven
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk maven

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia o código-fonte do aplicativo para o diretório de trabalho
COPY . .

# Executa o comando Maven para limpar e construir o aplicativo
RUN mvn clean install

# Segundo estágio
FROM openjdk:21-jdk-slim

# Expõe a porta 8080 para permitir o acesso ao aplicativo
EXPOSE 8080

# Copia o arquivo JAR gerado no estágio de construção para dentro do contêiner
COPY --from=build /app/target/login-auth-api-0.0.1-SNAPSHOT.jar /app.jar

# Define o ponto de entrada para iniciar o aplicativo quando o contêiner for executado
ENTRYPOINT ["java", "-jar", "app.jar"]
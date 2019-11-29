FROM microsoft/mssql-server-linux:2017-latest as debug
ARG FLYWAY_VERSION=5.1.4
# Install OpenJDK-8
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y ca-certificates-java
RUN apt-get install -y ant
RUN apt-get install -y curl
RUN apt-get clean
RUN update-ca-certificates -f
# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME
# Install Flyway
RUN mkdir /flyway \
  && cd /flyway \
  && curl -L https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz -o flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && tar -xzf flyway-commandline-${FLYWAY_VERSION}.tar.gz --strip-components=1 \
  && rm flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && ln -s /flyway/flyway /usr/local/bin/flyway
RUN rm -rf /flyway/sql/*

COPY . ./
COPY ./sql /flyway/sql
ENTRYPOINT entrypoint-debug.sh

#---------------Estágio usada para rodar os Testes, teste, sonarqube
FROM debug as tests
ENTRYPOINT entrypoint-tests.sh

#---------------Estágio usada para build/publish/pack
FROM debug as build
ENTRYPOINT entrypoint.sh

#---------------Estágio usada para runtime
FROM build AS runtime
ENTRYPOINT entrypoint.sh

#---------------Estágio usada para publicação (kubernetes/npm)
FROM tjmt/publicador:latest as deploy
COPY . /var/release/source

FROM runtime AS final
#!/bin/sh
echo 'RUNNING entrypoint.sh'
sh -c "until (/opt/mssql/bin/sqlservr); do sleep 1; done & until (/opt/mssql-tools/bin/sqlcmd -l 40 -S localhost -U sa -P ${SA_PASSWORD} -d tempdb -q \"If(db_id('${DATABASE}') IS NULL) CREATE DATABASE ${DATABASE}\"); do sleep 1; done; until (flyway info -user='sa' -password='${SA_PASSWORD}' -url='jdbc:sqlserver://localhost:1433;databaseName=${DATABASE}'); do sleep 5; done; if [ -z \"$(ls -A /flyway/sql)\" ]; then echo 0; else flyway migrate -user='sa' -password='${SA_PASSWORD}' -url='jdbc:sqlserver://localhost:1433;databaseName=${DATABASE}'; flyway info -user='sa' -password='${SA_PASSWORD}' -url='jdbc:sqlserver://localhost:1433;databaseName=${DATABASE}'; fi; wait"

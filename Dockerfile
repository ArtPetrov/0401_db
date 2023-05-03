FROM postgres:14.5-alpine as base

ARG DBNAME=db
ARG DBUSER=app
ARG DBPASS=pass

ENV POSTGRES_DB=$DBNAME
ENV POSTGRES_USER=$DBUSER
ENV POSTGRES_PASSWORD=$DBPASS

COPY ["./docker-entrypoint-initdb.d/schema.sql", "/docker-entrypoint-initdb.d/1_schema.sql"]
COPY ["./docker-entrypoint-initdb.d/data.sql", "/docker-entrypoint-initdb.d/data.sql"]

RUN ["sed", "-i", "s/exec \"$@\"/echo \"skipping...\"/", "/usr/local/bin/docker-entrypoint.sh"]
RUN ["/usr/local/bin/docker-entrypoint.sh", "postgres"]


FROM postgres:14.5-alpine
COPY --from=base $PGDATA $PGDATA
EXPOSE 5432
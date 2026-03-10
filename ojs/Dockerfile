FROM pkpofficial/ojs:3_4_0-7

# Instal dependensi untuk ekstensi PHP PostgreSQL menggunakan package manager Alpine
RUN apk add --no-cache postgresql-dev && \
    (apk add --no-cache php81-pdo_pgsql php81-pgsql || \
     apk add --no-cache php82-pdo_pgsql php82-pgsql || \
     apk add --no-cache php83-pdo_pgsql php83-pgsql || \
     apk add --no-cache php-pdo_pgsql php-pgsql)

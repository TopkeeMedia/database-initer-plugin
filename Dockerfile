FROM ubuntu:20.04

LABEL MAINTAINER ="Young"

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    apt-get update && apt-get install -y mysql-client curl && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["docker-entrypoint.sh"]
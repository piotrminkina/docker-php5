#!/bin/sh
set -e


VERSIONS="5.3 5.4 5.5 5.6"

for VERSION in ${VERSIONS}; do
    cp src/files/entrypoint.sh src/${VERSION}-fpm/

    docker build \
        -t piotrminkina/php5-fpm:${VERSION} \
        "${@}" \
        src/${VERSION}-fpm/

    docker tag \
        -f \
        piotrminkina/php5-fpm:${VERSION} \
        piotrminkina/php5-fpm:latest
done

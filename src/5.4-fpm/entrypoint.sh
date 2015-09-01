#!/bin/bash
set -e


SERVICE_NAME="php-fpm"
SERVICE_DESCRIPTION="PHP FastCGI Process Manager"
SERVICE_ENDPOINT="/usr/bin/php-fpm"
SERVICE_ARGUMENTS="--nodaemonize"
SYSLOG_FACILITY="daemon.info"

RUN=0
PID=
SYSLOG_PID=
EXIT_CODE=255

service_install() {
    # nothing to do
    return 0
}

service_start() {
    log "Starting the ${SERVICE_DESCRIPTION}"
    ${SERVICE_ENDPOINT} ${SERVICE_ARGUMENTS} "${@}" & PID=$!
    RUN=1
}

service_reload() {
    log "Reloading the ${SERVICE_DESCRIPTION}"
    kill -s HUP ${PID}
}

service_stop() {
    log "Stopping the ${SERVICE_DESCRIPTION}"
    kill -s TERM ${PID}
    wait ${PID}
    RUN=0
}

syslog_start() {
    /bin/busybox syslogd -nSO /dev/stdout & SYSLOG_PID=$!

    while [ ! -e /dev/log ]; do
        sleep 0.01
    done
}

syslog_stop() {
    kill -s TERM ${SYSLOG_PID}
}

configure_signals() {
    log "Configuring signals for ${SERVICE_DESCRIPTION}"
    trap 'service_reload' HUP
    trap 'service_stop' INT TERM QUIT
}

process_wait() {
    set +e

    while [ 1 -eq ${RUN} ] && /bin/ps ${PID} > /dev/null; do
        wait ${PID}
        EXIT_CODE=${?}
    done
}

log() {
    local facility="${2:-${SYSLOG_FACILITY}}" message="${1}"
    logger -t "entrypoint[${$}]" -p "${facility}" "${message}"
}

if [[ $# -lt 1 ]] || [[ "${1}" == "-"* ]]; then
    syslog_start
    service_install
    service_start "$@"
    configure_signals
    process_wait
    service_stop
    syslog_stop

    exit ${EXIT_CODE}
elif [ "${1}" = 'service-install' ]; then
    syslog_start
    service_install
    syslog_stop
else
    exec "${@}"
fi

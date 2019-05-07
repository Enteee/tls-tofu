#!/usr/bin/env sh
# tls-tofu default entrypoint
set -eo pipefail


TLS_TOFU_DEFAULT="-connect ${TLS_TOFU_SERVER_DEFAULT}:${TLS_TOFU_PORT} -servername ${TLS_TOFU_SERVER_DEFAULT}"
TLS_TOFU="${TLS_TOFU:-${TLS_TOFU_DEFAULT}}"

/tls-tofu.sh ${TLS_TOFU}
exec sh -c "${*}"

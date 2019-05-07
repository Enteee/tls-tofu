#!/usr/bin/env sh
# tls-tofu default entrypoint
set -eo pipefail

TLS_TOFU_SERVER_DEFAULT="google.ch"
TLS_TOFU_DEFAULT="-connect ${TLS_TOFU_SERVER_DEFAULT}:443 -servername ${TLS_TOFU_SERVER_DEFAULT}"
#
# Environment:
#   Arguments for tls-tofu.sh
TLS_TOFU=${TLS_TOFU:-${TLS_TOFU_DEFAULT}}

/tls-tofu.sh ${TLS_TOFU}
exec sh -c "${*}"

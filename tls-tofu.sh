#!/usr/bin/env sh
set -eo pipefail
# Trust On First Use (TOFU) for TLS certificates.
#
# Environment:
#
# Enable TLS_TOFU
TLS_TOFU="${TLS_TOFU:-true}"
# Host to do tls-tofu with
TLS_TOFU_HOST="${TLS_TOFU_HOST:-"google.com"}"
# Port on host
TLS_TOFU_PORT="${TLS_TOFU_PORT:-"443"}"
# Additional arguments for openssl s_client
TLS_TOFU_S_CLIENT_ARGS="${TLS_TOFU_S_CLIENT_ARGS:-"-servername ${TLS_TOFU_HOST}"}"
# Path to the kamikaze binary
TLS_TOFU_KAMIKAZE_BIN="${TLS_TOFU_KAMIKAZE_BIN:-/kamikaze}"
# Path to the ca-certificates file
TLS_TOFU_CA_CERTIFICATES="${TLS_TOFU_CA_CERTIFICATES:-/etc/ssl/certs/ca-certificates.crt}"
# Enable debug output
TLS_TOFU_DEBUG="${TLS_TOFU_DEBUG:-false}"

# Derived constants
S_CLIENT_ARGS="-connect "${TLS_TOFU_HOST}:${TLS_TOFU_PORT}" ${TLS_TOFU_S_CLIENT_ARGS}"

# Ensure that the kamikaze binary is destroyed when we exit
function destroy_kamikaze(){
  if [ -x "${TLS_TOFU_KAMIKAZE_BIN}" ]; then "${TLS_TOFU_KAMIKAZE_BIN}" true; fi
}
trap "destroy_kamikaze" EXIT

[ "${TLS_TOFU_DEBUG}" = "true" ] && set -x

if [ "${TLS_TOFU}" = "true" ]; then
  if ! openssl s_client -verify_return_error ${S_CLIENT_ARGS} &>/dev/null < /dev/null; then
    # Only install certificates if the initial verification failed
    openssl s_client -showcerts ${S_CLIENT_ARGS} 2>/dev/null < /dev/null \
    | tee /dev/tty \
    | sed -n '/-----BEGIN/,/-----END/p' \
    | "${TLS_TOFU_KAMIKAZE_BIN}" tee -a "${TLS_TOFU_CA_CERTIFICATES}" > /dev/null
  fi
fi

destroy_kamikaze
exec sh -c "${*}"

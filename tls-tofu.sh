#!/usr/bin/env sh
# Trust On First Use (TOFU) for TLS certificates.
#
# Synopsis:
#   tls-tofu <openssl s_client arguments>
#
# Example usage:
#   tls-tofu -connect localhost:8081 -servername duckpond.ch
set -eo pipefail

#
# Environment:
#   Path to the kamikaze binary
KAMIKAZE_BIN="${KAMIKAZE_BIN:-/kamikaze}"
#   Path to the ca-certificates file
CA_CERTIFICATES="${CA_CERTIFICATES:-/etc/ssl/certs/ca-certificates.crt}"


(
  # DEBUG: Enable debug output, default: false
  [ ! -z ${DEBUG+x} ] && set -x

  # Ensure that the kamikaze binary is destroyed when we leave this subshell
  trap "[ -x "${KAMIKAZE_BIN}" ] && "${KAMIKAZE_BIN}" true" EXIT
  if [ ! -z "${*}" ]; then
    if ! openssl s_client -verify_return_error ${@} &>/dev/null < /dev/null; then
      # Only install certificates if the initial verification failed
      openssl s_client -showcerts ${@} 2>/dev/null < /dev/null \
      | tee /dev/tty \
      | sed -n '/-----BEGIN/,/-----END/p' \
      | "${KAMIKAZE_BIN}" tee -a "${CA_CERTIFICATES}" \
      | sha256sum
    fi
  fi
)

# tls-tofu [![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/Enteee/tls-tofu/Build/master)](https://github.com/Enteee/tls-tofu) [![Docker Pulls](https://img.shields.io/docker/pulls/enteee/tls-tofu)](https://hub.docker.com/r/enteee/tls-tofu)
_Docker images implementing Transport Layer Security (TLS) -  Trust On First Use (TOFU)_

## Usage

```sh
$ docker run \
  --rm \
  enteee/tls-tofu
```

## Environment Variables

| Variable | Description | Mandatory | Default |
| -------- | ----------- | :-------: | ------- |
| `TLS_TOFU` | Enable TLS-TOFU | No | `true` |
| `TLS_TOFU_HOST` | Host to do TLS-TOFU with | No | `google.com` |
| `TLS_TOFU_PORT` | Port on host | No | `443` |
| `TLS_TOFU_S_CLIENT_ARGS` | Additional arguments for `openssl s_client` | No | `-servername ${TLS_TOFU_HOST}` |
| `TLS_TOFU_KAMIKAZE_BIN` | Path to the kamikaze binary | No | `/kamikaze` |
| `TLS_TOFU_CA_CERTIFICATES` | Path to the ca-certificates file | No | `/etc/ssl/certs/ca-certificates.crt` |
| `TLS_TOFU_DEBUG` | Enable debug output | No | `undefined` |

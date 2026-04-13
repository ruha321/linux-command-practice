#! /usr/bin/env bash
set -euo pipefail

export PATH=$PATH:/usr/local/bin

NAME="fedora-podman"
USER_NAME="ruha321"
HOST_NAME="host.docker.internal"
PORT="2222"
SOCKET_PATH="/run/user/1000/podman/podman.sock"

podman system connection rm -f "${NAME}" >/dev/null 2>&1 || true

podman system connection add --default "${NAME}" \
    --port "${PORT}" \
    --socket-path "${SOCKET_PATH}" \
    "${USER_NAME}@${HOST_NAME}"

podman --connection "${NAME}" info >/dev/null
echo "Podman remote connection '${NAME}' is ready."
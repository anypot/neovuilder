#!/bin/sh
# We use the shebang /bin/sh because Alpine comes with ash as the default shell.

BASE_IMAGE=$1
EXTRA_SYSTEM_PACKAGES=$2

case "${BASE_IMAGE}" in
alpine:3)
  SYSTEM_PACKAGES="alpine-sdk git lazygit neovim neovim-doc xclip curl unzip gzip ripgrep fd npm python3"
  SYSTEM_PACKAGES="${SYSTEM_PACKAGES} ${EXTRA_SYSTEM_PACKAGES}"
  RUN_CMD="apk add --no-cache ${SYSTEM_PACKAGES}"
  RUN_CMD="${RUN_CMD} && addgroup -S neo && adduser -S neo -G neo"
  ;;
archlinux:base)
  SYSTEM_PACKAGES="git lazygit neovim gcc xclip unzip ripgrep fd npm python3"
  SYSTEM_PACKAGES="${SYSTEM_PACKAGES} ${EXTRA_SYSTEM_PACKAGES}"
  RUN_CMD="pacman -Syu --noconfirm && pacman -S ${SYSTEM_PACKAGES} --noconfirm && pacman -Scc --noconfirm"
  RUN_CMD="${RUN_CMD} && useradd -m -s /bin/bash neo"
  ;;
*)
  echo "Unknown base image '${BASE_IMAGE}'!" && exit 1
  ;;
esac

>&2 echo "System packages to install: ${SYSTEM_PACKAGES}"
>&2 echo "RUN command: ${RUN_CMD}"
eval "${RUN_CMD}"

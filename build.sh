#!/bin/bash

[[ $# -eq 0 ]] && BUNDLE=minimal || BUNDLE=$1
[[ $# -gt 1 ]] && DOCKER_REPOSITORY=$2 || DOCKER_REPOSITORY="anypot/neovim"
BASE_IMAGE="alpine:3"

case "${BUNDLE}" in
minimal) ;;
ansible)
  EXTRA_LANGS="python ansible"
  EXTRA_SYSTEM_PKGS="ansible"
  ;;
docker)
  EXTRA_LANGS="docker"
  ;;
go)
  EXTRA_LANGS="go"
  EXTRA_SYSTEM_PKGS="go"
  ;;
python)
  EXTRA_LANGS="python"
  ;;
rust)
  EXTRA_LANGS="rust"
  EXTRA_SYSTEM_PKGS="rustup"
  EXTRA_SYSTEM_CMDS="rustup toolchain install stable --component rust-src --component rust-analyzer && echo PATH=\${PATH}:/usr/lib/rustup/bin >> .bashrc"
  BASE_IMAGE="archlinux:base"
  ;;
terraform)
  EXTRA_LANGS="terraform"
  ;;
*)
  printf "The bundle '%s' does not exist!\n" "${BUNDLE}" && exit 1
  ;;
esac

echo "
NNNNNNNN        NNNNNNNNEEEEEEEEEEEEEEEEEEEEEE     OOOOOOOOO     VVVVVVVV           VVVVVVVVIIIIIIIIIIMMMMMMMM               MMMMMMMM
N:::::::N       N::::::NE::::::::::::::::::::E   OO:::::::::OO   V::::::V           V::::::VI::::::::IM:::::::M             M:::::::M
N::::::::N      N::::::NE::::::::::::::::::::E OO:::::::::::::OO V::::::V           V::::::VI::::::::IM::::::::M           M::::::::M
N:::::::::N     N::::::NEE::::::EEEEEEEEE::::EO:::::::OOO:::::::OV::::::V           V::::::VII::::::IIM:::::::::M         M:::::::::M
N::::::::::N    N::::::N  E:::::E       EEEEEEO::::::O   O::::::O V:::::V           V:::::V   I::::I  M::::::::::M       M::::::::::M
N:::::::::::N   N::::::N  E:::::E             O:::::O     O:::::O  V:::::V         V:::::V    I::::I  M:::::::::::M     M:::::::::::M
N:::::::N::::N  N::::::N  E::::::EEEEEEEEEE   O:::::O     O:::::O   V:::::V       V:::::V     I::::I  M:::::::M::::M   M::::M:::::::M
N::::::N N::::N N::::::N  E:::::::::::::::E   O:::::O     O:::::O    V:::::V     V:::::V      I::::I  M::::::M M::::M M::::M M::::::M
N::::::N  N::::N:::::::N  E:::::::::::::::E   O:::::O     O:::::O     V:::::V   V:::::V       I::::I  M::::::M  M::::M::::M  M::::::M
N::::::N   N:::::::::::N  E::::::EEEEEEEEEE   O:::::O     O:::::O      V:::::V V:::::V        I::::I  M::::::M   M:::::::M   M::::::M
N::::::N    N::::::::::N  E:::::E             O:::::O     O:::::O       V:::::V:::::V         I::::I  M::::::M    M:::::M    M::::::M
N::::::N     N:::::::::N  E:::::E       EEEEEEO::::::O   O::::::O        V:::::::::V          I::::I  M::::::M     MMMMM     M::::::M
N::::::N      N::::::::NEE::::::EEEEEEEE:::::EO:::::::OOO:::::::O         V:::::::V         II::::::IIM::::::M               M::::::M
N::::::N       N:::::::NE::::::::::::::::::::E OO:::::::::::::OO           V:::::V          I::::::::IM::::::M               M::::::M
N::::::N        N::::::NE::::::::::::::::::::E   OO:::::::::OO              V:::V           I::::::::IM::::::M               M::::::M
NNNNNNNN         NNNNNNNEEEEEEEEEEEEEEEEEEEEEE     OOOOOOOOO                 VVV            IIIIIIIIIIMMMMMMMM               MMMMMMMM
"

if [[ -z ${EXTRA_LANGS+x} ]]; then
  printf "This neovim bundle will be minimal with no lang extra.\n"
else
  printf "The neovim bundle '%s' will include these lang extras: %s\n" "${BUNDLE}" "${EXTRA_LANGS}"
fi
printf "The base image used will be %s\n" "${BASE_IMAGE}"

printf "Press 'y' to confirm.\n"
read -rsn1 key
[[ "${key}" = "y" ]] || exit 0

cd "$(dirname -- "$(readlink -f -- "$0")")" || {
  printf "cd failed..."
  exit 1
}

DOCKER_TAG="${BUNDLE}-$(date '+%Y%m%d')"
sudo docker build --no-cache -t "neovim:${DOCKER_TAG}" \
  --build-arg "BASE_IMAGE=${BASE_IMAGE}" \
  --build-arg "EXTRA_SYSTEM_PKGS=${EXTRA_SYSTEM_PKGS}" \
  --build-arg "EXTRA_SYSTEM_CMDS=${EXTRA_SYSTEM_CMDS}" \
  --build-arg "EXTRA_LANGS=${EXTRA_LANGS}" .

printf "\n\nPress 'y' if you want to perform a checkhealth command. Else press any key to continue.\n"
read -rsn1 key
if [[ "${key}" = "y" ]]; then
  sudo docker run --rm "neovim:${DOCKER_TAG}" --headless "+checkhealth" +"%print" +qa
fi

printf "\n\nPress 'y' if you want to tag and push the image to '%s'. Else press any key to continue.\n" "${DOCKER_REPOSITORY}:${DOCKER_TAG}"
read -rsn1 key
if [[ "${key}" = "y" ]]; then
  sudo docker tag "neovim:${DOCKER_TAG}" "${DOCKER_REPOSITORY}:${DOCKER_TAG}"
  sudo docker push "${DOCKER_REPOSITORY}:${DOCKER_TAG}"
fi

printf "\nENJ0Y <3\n"

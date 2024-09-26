#!/bin/bash

REQUIRED_LANGS=("lua" "bash")
LANGS=("${REQUIRED_LANGS[@]}" "$@")
MASON_PACKAGES=()

>&2 echo Lang extras: "${LANGS[@]}"

for lang in "${LANGS[@]}"; do
  case "$lang" in
  ansible)
    MASON_PACKAGES+=("ansible-language-server" "ansible-lint")
    ;;
  bash)
    MASON_PACKAGES+=("bash-language-server" "shellcheck" "shfmt")
    ;;
  docker)
    MASON_PACKAGES+=("dockerfile-language-server" "docker-compose-language-service" "hadolint")
    ;;
  go)
    MASON_PACKAGES+=("gopls" "goimports" "gofumpt")
    ;;
  lua)
    MASON_PACKAGES+=("lua-language-server" "stylua")
    ;;
  markdown)
    MASON_PACKAGES+=("marksman" "markdownlint-cli2" "markdown-toc")
    ;;
  python)
    MASON_PACKAGES+=("pyright" "ruff")
    ;;
  rust)
    MASON_PACKAGES+=("taplo" "codelldb")
    ;;
  terraform)
    MASON_PACKAGES+=("terraform-ls" "tflint")
    ;;
  yaml)
    MASON_PACKAGES+=("yaml-language-server")
    ;;
  *)
    echo "Language '${lang}' is not managed by the build." && exit 1
    ;;
  esac
done

>&2 echo Mason packages to install: "${MASON_PACKAGES[@]}"
echo "${MASON_PACKAGES[@]}"

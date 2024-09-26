ARG BASE_IMAGE=alpine:3

# hadolint ignore=DL3006
FROM $BASE_IMAGE
ARG BASE_IMAGE
ARG EXTRA_LANGS
ARG EXTRA_SYSTEM_PKGS
ARG EXTRA_SYSTEM_CMDS
COPY install-system.sh /root
RUN /root/install-system.sh "${BASE_IMAGE}" "${EXTRA_SYSTEM_PKGS}" && \
  rm -f /root/install-system.sh

USER neo
ENV NEO_HOME=/home/neo
WORKDIR ${NEO_HOME}
ENV DISPLAY=toto
COPY --chown=neo:neo edit-lazy-config.sh ${NEO_HOME}
COPY --chown=neo:neo list-mason-packages.sh ${NEO_HOME}

# TODO: Use a default config in the neovuilder repo instead of mine
# hadolint ignore=SC2086
RUN eval "${EXTRA_SYSTEM_CMDS}" && \
  git clone https://github.com/anypot/dotfiles "${NEO_HOME}/dotfiles" && \
  mkdir -p "${NEO_HOME}/.config" && \
  cp -R "${NEO_HOME}/dotfiles/desktop/neovim/.config/nvim" "${NEO_HOME}/.config/nvim" && \
  rm -fr "${NEO_HOME}/dotfiles" && \
  "${NEO_HOME}/edit-lazy-config.sh" ${EXTRA_LANGS} && \
  nvim --headless +"MasonInstall $("${NEO_HOME}/list-mason-packages.sh" ${EXTRA_LANGS})" +qa && \
  nvim --headless +"Lazy! sync" +qa && \
  rm -f "${NEO_HOME}/edit-lazy-config.sh" "${NEO_HOME}/list-mason-packages.sh"
WORKDIR ${NEO_HOME}/.config/nvim
ENTRYPOINT [ "nvim" ]

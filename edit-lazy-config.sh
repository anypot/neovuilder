#!/bin/bash

EXTRA_LANGS=("$@")

for lang in "${EXTRA_LANGS[@]}"; do
  IMPORT_LINES+='\ \ \ \ { import = "lazyvim.plugins.extras.lang.'${lang}'" },\n'
done
IMPORT_LINES+='\ \ \ \ { import = "lazyvim.plugins.extras.util.dot" }, -- bash'

sed -i -n '/-- Extra plugins/{p; :a; N; /-- import\/override/!ba; s/.*\n//}; p' "${NEO_HOME}/.config/nvim/lua/config/lazy.lua"
sed -i '/-- Extra plugins and configs for languages/a '"${IMPORT_LINES}" "${NEO_HOME}/.config/nvim/lua/config/lazy.lua"

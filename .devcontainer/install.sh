#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

echo -e "\n${GREEN}> Configure environment.${ENDCOLOR}\n"

sudo chgrp vscode /workspaces/app/.venv
sudo chown vscode /workspaces/app/.venv

git config --global --add safe.directory /workspaces/app
git config core.eol lf
git config core.autocrlf false

python3 -m venv /workspaces/app/.venv
PATH="/workspaces/app/.venv/bin:$PATH"

echo -e "Done.\n"

echo -e "${GREEN}> Update pip tool and install dependencies.${ENDCOLOR}\n"

source /workspaces/app/.venv/bin/activate
pip install --upgrade pip

# pip install keyring artifacts-keyring

# cat <<EOF >> /workspaces/app/.venv/pip.conf
# [global]
# extra-index-url=https://pkgs.dev.azure.com/...
# EOF

pip install -r /workspaces/app/requirements-dev.txt
pip install -r /workspaces/app/requirements.txt

/workspaces/app/.devcontainer/check-post-install.sh

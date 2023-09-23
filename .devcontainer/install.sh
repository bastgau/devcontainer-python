#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

echo -e "\n${BLUE}################################"
echo -e "${BLUE}####       INSTALL.SH       ####${ENDCOLOR}"
echo -e "${BLUE}################################"

echo -e "\n${GREEN}> Configure virtual environment.${ENDCOLOR}\n"

sudo chgrp vscode /workspaces/app/.venv
sudo chown vscode /workspaces/app/.venv

python3 -m venv /workspaces/app/.venv
PATH="/workspaces/app/.venv/bin:$PATH"

mkdir -p /home/vscode/.local/
mkdir -p /workspaces/app/.venv/lib
ln -s /workspaces/app/.venv/lib /home/vscode/.local/
echo -e "Done."

echo -e "\n${GREEN}> Configure Git.${ENDCOLOR}\n"

git config --global --add safe.directory /workspaces/app
git config --global core.eol lf
git config --global core.autocrlf false

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

echo -e "Done.\n"

echo -e "${GREEN}> Update PIP tool.${ENDCOLOR}\n"
pip install --upgrade pip

echo -e "\n${GREEN}> Identify the packaging and dependency manager to install.${ENDCOLOR}\n"

PIP_MANAGER=false
POETRY_MANAGER=false

if [ "$DEPENDENCY_MANAGER"  != "" ];
then
    echo -e "Environment Variable 'DEPENDENCY_MANAGER' was found with the value : $DEPENDENCY_MANAGER\n"
fi

if [ "$DEPENDENCY_MANAGER" = "PIP" ];
then
    PIP_MANAGER=true
fi

if [ "$DEPENDENCY_MANAGER" = "POETRY" ];
then
    POETRY_MANAGER=true
fi

if [ "$POETRY_MANAGER" = false ] && [ "$PIP_MANAGER" = false ];
then
    echo -e "${RED}> No packaging and dependency manager was configured.${ENDCOLOR}\n"
    exit 1
fi

source /workspaces/app/.venv/bin/activate

if [ "$PIP_MANAGER" = true ];
then

    if [ -f "/workspaces/app/requirements-dev.txt" ];
    then
        echo -e "${GREEN}> Install dependencies with PIP (requirements-dev.txt).${ENDCOLOR}\n"
        pip install -r /workspaces/app/requirements-dev.txt
        echo -e "Done.\n"
    else
        echo -e "${GREEN}> Initialize PIP Manager (requirements-dev.txt).${ENDCOLOR}\n"
        echo -e "PIP configuration file was created (requirements-dev.txt).\n"
        touch /workspaces/app/requirements-dev.txt
    fi

    if [ -f "/workspaces/app/requirements.txt" ];
    then
        echo -e "${GREEN}> Install dependencies with PIP (requirements.txt).${ENDCOLOR}\n"
        pip install -r /workspaces/app/requirements.txt
        echo -e "Done.\n"
    else
        echo -e "${GREEN}> Initialize PIP Manager (requirements.txt).${ENDCOLOR}\n"
        echo -e "PIP configuration file was created (requirements.txt).\n"
        touch /workspaces/app/requirements.txt
    fi

fi

if [ "$POETRY_MANAGER" = true ];
then

    echo -e "${GREEN}> Install POETRY tool and install dependencies.${ENDCOLOR}\n"
    curl -sSL https://install.python-poetry.org | python3 -
    poetry completions bash >> ~/.bash_completion

    if [ ! -f "pyproject.toml" ];
    then
        poetry init
    fi

    poetry install

fi

chmod +x /workspaces/app/.devcontainer/check-post-install.sh
/workspaces/app/.devcontainer/check-post-install.sh

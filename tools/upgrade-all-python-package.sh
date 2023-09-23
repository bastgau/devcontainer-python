#!/bin/bash

source /workspaces/app/.venv/bin/activate
sleep 0.5

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
BOLD="\e[1m"

ENDCOLOR="\e[0m"

clear

echo -e "\n${GREEN}> Identify the packaging and dependency manager to install.${ENDCOLOR}\n"

if [ "$DEPENDENCY_MANAGER"  != "" ];
then
    echo -e "Environment Variable 'DEPENDENCY_MANAGER' was found with the value : $DEPENDENCY_MANAGER\n"
fi

if [ "$DEPENDENCY_MANAGER" = "PIP" ];
then

    echo -e "${GREEN}> Update dependencies with PIP (requirements.txt).${ENDCOLOR}\n"
    pip install -r /workspaces/app/requirements.txt --upgrade
    echo -e "Done.\n"

    echo -e "${GREEN}> Update dependencies with PIP (requirements-dev.txt).${ENDCOLOR}\n"
    pip install -r /workspaces/app/requirements-dev.txt --upgrade
    echo -e "Done.\n"

fi

if [ "$DEPENDENCY_MANAGER" = "POETRY" ];
then
    poetry update
fi

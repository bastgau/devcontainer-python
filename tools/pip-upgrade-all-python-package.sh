#!/bin/bash

source /workspaces/app/.venv/bin/activate
sleep 0.5

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
BOLD="\e[1m"

ENDCOLOR="\e[0m"

echo -e "\n${YELLOW}> Use: requirements-dev.txt${ENDCOLOR}\n"
pip install -r /workspaces/app/requirements-dev.txt --upgrade

echo -e "\n${YELLOW}> Use: requirements.txt${ENDCOLOR}\n"
pip install -r /workspaces/app/requirements.txt --upgrade

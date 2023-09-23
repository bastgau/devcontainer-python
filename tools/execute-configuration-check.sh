#!/bin/bash

SETUP_CFG_FILE=$WORKSPACE_PATH/setup.cfg

source $WORKSPACE_PATH/.venv/bin/activate
sleep 0.5

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
BOLD="\e[1m"

ENDCOLOR="\e[0m"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####      CHECK CONFOGURATION FILES (YAML / JSON)      #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${YELLOW}> YAML Lint.${ENDCOLOR}"
yamllint $SOURCE_PATH

if [ "$?" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}\n"
fi

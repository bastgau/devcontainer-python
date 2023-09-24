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

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####           CHECK PACKAGE FILES (PYTHON)            #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

VIRTUAL_ENVIRONMENT_DIRECTORY="/workspaces/app/.venv/bin"

# TOOL : pyright

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/pyright" ]; then
    echo -e "\n${YELLOW}> Pyright / Pylance.${ENDCOLOR}\n"
    pyright $PACKAGE_PATH
fi

# TOOL : pylint

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/pylint" ]; then
    echo -e "\n${YELLOW}> Pylint.${ENDCOLOR}\n"
    pylint $PACKAGE_PATH --score=false --jobs=10

    if [ "$?" -eq 0 ]; then
        echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
    fi
fi

# TOOL : flake8

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/flake8" ]; then
    echo -e "\n${YELLOW}> Flake8.${ENDCOLOR}\n"
    flake8 $PACKAGE_PATH

    if [ "$?" -eq 0 ]; then
        echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
    fi
fi

# TOOL : mypy

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/mypy" ]; then
    echo -e "\n${YELLOW}> Mypy.${ENDCOLOR}\n"
    mypy $PACKAGE_PATH
fi

# TOOL : yapf

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/yapf" ]; then
    echo -e "\n${YELLOW}> Yapf.${ENDCOLOR}\n"
    result=$(yapf --diff $PACKAGE_PATH --recursive | grep "(reformatted)" | grep "+++")

    if [ "$result" = "" ]; then
        echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
    else
        result_modified=$(echo "$result" | sed 's/+++/would reformat/g; s/(reformatted)//g')
        echo -e "${BOLD}$result_modified${ENDCOLOR}"
    fi
fi

# TOOL : black

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/black" ]; then
    echo -e "\n${YELLOW}> Black.${ENDCOLOR}\n"
    black --check $PACKAGE_PATH
fi

echo -e "\n${BLUE}All verifications are done.${ENDCOLOR}\n"

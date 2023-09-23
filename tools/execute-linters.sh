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

VIRTUAL_ENVIRONMENT_DIRECTORY="/workspaces/app/.venv/bin"

# TOOL : yamllint

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/yamllint" ]; then

    echo -e "\n${YELLOW}> YAML Lint.${ENDCOLOR}"
    yamllint /workspaces/app/src/

    if [ "$?" -eq 0 ]; then
        echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
    fi

fi

# TOOL : pyright

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/pyright" ]; then

    echo -e "\n${YELLOW}> Pyright / Pylance.${ENDCOLOR}"
    result=$(pyright /workspaces/app/src)

    if [ "$?" -eq 0 ]; then
        echo -e "${GREEN}${BOLD}Success: $result${ENDCOLOR}"
    else
        echo -e $result
    fi

fi

# TOOL : pylint

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/pylint" ]; then
    echo -e "\n${YELLOW}> Pylint.${ENDCOLOR}"
    pylint /workspaces/app/src --score=false --jobs=10

    if [ "$?" -eq 0 ]; then
        echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
    fi
fi

# TOOL : flake8

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/flake8" ]; then
    echo -e "\n${YELLOW}> Flake8.${ENDCOLOR}"
    flake8 /workspaces/app/src

    if [ "$?" -eq 0 ]; then
        echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
    fi
fi

# TOOL : mypy

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/mypy" ]; then
    echo -e "\n${YELLOW}> Mypy.${ENDCOLOR}"
    mypy /workspaces/app/src
fi

# TOOL : yapf

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/yapf" ]; then
    echo -e "\n${YELLOW}> Yapf.${ENDCOLOR}"
    yapf --diff /workspaces/app/src --recursive

    if [ "$?" -eq 0 ]; then
        echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
    fi
fi

# TOOL : black

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/black" ]; then
    echo -e "\n${YELLOW}> Black.${ENDCOLOR}"
    black /workspaces/app/src
fi

# TOOL : pytest

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/pytest" ]; then
    echo -e "\n${YELLOW}> Pytest.${ENDCOLOR}\n"
    pytest ./tests/test_*.py -v -s -n auto --no-header --no-summary
fi

echo -e "\n${BLUE}All verifications are done.${ENDCOLOR}\n"

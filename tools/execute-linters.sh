#!/bin/bash

source /workspaces/app/.venv/bin/activate
sleep 0.5

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
BOLD="\e[1m"

ENDCOLOR="\e[0m"

echo -e "\n${YELLOW}> YAML Lint.${ENDCOLOR}"
yamllint /workspaces/app/snow_revoke_privileges/

if [ "$?" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
fi

echo -e "\n${YELLOW}> Pyright / Pylance.${ENDCOLOR}"
result=$(pyright /workspaces/app/snow_revoke_privileges/)

if [ "$?" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}Success: $result${ENDCOLOR}"
else
    echo -e $result
fi

echo -e "\n${YELLOW}> Pylint.${ENDCOLOR}"
pylint /workspaces/app/snow_revoke_privileges/ --score=false --jobs=10

if [ "$?" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
fi

echo -e "\n${YELLOW}> Flake8.${ENDCOLOR}"
flake8 /workspaces/app/snow_revoke_privileges/

if [ "$?" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
fi

echo -e "\n${YELLOW}> Mypy.${ENDCOLOR}"
mypy /workspaces/app/snow_revoke_privileges/

echo -e "\n${YELLOW}> Pylama.${ENDCOLOR}"
pylama /workspaces/app/snow_revoke_privileges/

if [ "$?" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
fi

echo -e "\n${YELLOW}> Yapf.${ENDCOLOR}"
yapf --diff /workspaces/app/snow_revoke_privileges/ --recursive

if [ "$?" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
fi

echo -e "\n${YELLOW}> Pytest.${ENDCOLOR}\n"
pytest ./tests/test_*.py -v -s -n auto --no-header --no-summary

echo -e "\n${BLUE}All verifications are done.${ENDCOLOR}\n"

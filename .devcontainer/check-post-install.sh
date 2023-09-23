#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

echo -e "\n${BLUE}#####################################"
echo -e "${BLUE}####    CHECK-POST-INSTALL.SH    ####${ENDCOLOR}"
echo -e "${BLUE}#####################################"

source $WORKSPACE_PATH/.venv/bin/activate

if which pip >/dev/null; then
    echo -e "\n${GREEN}> Display PIP info/version.${ENDCOLOR}\n"
    pip --version
fi

if which poetry >/dev/null; then
    echo -e "\n${GREEN}> Display POETRY info/version.${ENDCOLOR}\n"
    poetry --version
fi

# ADD [here] your other verification todo.

echo -e "\n${YELLOW}Installation is finished!${ENDCOLOR}"
echo -e "${YELLOW}You can close this terminal and re-open a new terminal!${ENDCOLOR}\n"

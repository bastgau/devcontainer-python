#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     CHECK DEPENDENCY MANAGER VERSION              #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

if which pip >/dev/null; then
    echo -e "\n${GREEN}> Display PIP info/version.${ENDCOLOR}\n"
    pip --version
fi

if which poetry >/dev/null; then
    echo -e "\n${GREEN}> Display POETRY info/version.${ENDCOLOR}\n"
    poetry --version
fi

echo -e ""

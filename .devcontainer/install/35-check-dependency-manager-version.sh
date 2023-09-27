#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Check dependency manager version              #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

if which pip >/dev/null; then
    echo -e "\n${GREEN}> Display pip version.${ENDCOLOR}\n"
    pip --version
fi

if which poetry >/dev/null; then
    echo -e "\n${GREEN}> Display POETRY version.${ENDCOLOR}\n"
    poetry --version
fi

echo -e ""

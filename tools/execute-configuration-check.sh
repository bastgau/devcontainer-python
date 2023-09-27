#!/bin/bash

SETUP_CFG_FILE=$WORKSPACE_PATH/setup.cfg

source $WORKSPACE_PATH/.venv/bin/activate
sleep 0.5

. "$WORKSPACE_PATH/tools/color.sh"

clear

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####      Check configuration files (YAML)             #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

VIRTUAL_ENVIRONMENT_DIRECTORY="/workspaces/app/.venv/bin"

# TOOL : YAML Lint

if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/yamllint" ]; then

    echo -e "\n${YELLOW}> YAML Lint.${ENDCOLOR}"

    $VIRTUAL_ENVIRONMENT_DIRECTORY/yamllint $SOURCE_PATH

    if [ "$?" -eq 0 ]; then
        echo -e "\n${GREEN}${BOLD}Success: no issues found${ENDCOLOR}\n"
    fi

fi

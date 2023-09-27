#!/bin/bash

source $WORKSPACE_PATH/.venv/bin/activate
sleep 0.5

. "$WORKSPACE_PATH/tools/color.sh"

clear

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####      Upgrade Python packages                      #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Identify the packaging and dependency manager to install.${ENDCOLOR}\n"

DEPENDENCY_MANAGER=$(jq -r '.customizations.vscode.settings."python.dependencyManager"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$DEPENDENCY_MANAGER"  != "" ]; then
    echo -e "The dependency manager used for the project is ${YELLOW}$DEPENDENCY_MANAGER${ENDCOLOR}.\n"
fi

if [ "$DEPENDENCY_MANAGER" != "pip" ] && [ "$DEPENDENCY_MANAGER" != "poetry" ]; then
    echo -e "${RED}No correct packaging and dependency manager was configured.${ENDCOLOR}"
    echo -e "${RED}Only pip and poetry manager are supported.${ENDCOLOR}\n"
    exit 1
fi

if [ "$DEPENDENCY_MANAGER" = "pip" ]; then

    echo -e "${GREEN}> Update dependencies with PIP (requirements.txt).${ENDCOLOR}\n"
    pip install -r /workspaces/app/requirements.txt --upgrade
    echo -e "Done\n"

    echo -e "${GREEN}> Update dependencies with PIP (requirements-dev.txt).${ENDCOLOR}\n"
    pip install -r /workspaces/app/requirements-dev.txt --upgrade
    echo -e "Done\n"

    echo -e "${GREEN}> Update dependencies with PIP (requirements-test.txt).${ENDCOLOR}\n"
    pip install -r /workspaces/app/requirements-test.txt --upgrade
    echo -e "Done\n"

fi

if [ "$DEPENDENCY_MANAGER" = "poetry" ]; then
    poetry update
fi

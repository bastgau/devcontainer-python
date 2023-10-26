#!/bin/bash

# can-be-removed-after-installation

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Update pip / Identify dependency manager      #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

echo -e "\n${GREEN}> Update pip tool.${ENDCOLOR}\n"
pip install --upgrade pip

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

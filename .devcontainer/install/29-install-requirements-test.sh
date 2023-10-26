#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Install requirements.txt (test)               #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

DEPENDENCY_MANAGER=$(jq -r '.customizations.vscode.settings."python.dependencyManager"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$DEPENDENCY_MANAGER" = "pip" ]; then

    if [ ! -f "$WORKSPACE_PATH/requirements-test.txt" ]; then
        echo -e "${GREEN}> Initialize pip Manager (requirements-test.txt).${ENDCOLOR}\n"

        unittest_package=""
        coverage_package=""

        active=$(jq -r '.customizations.vscode.settings."python.testing.pytestEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

        if [ "$active" = "true" ]; then
            unittest_package="pytest-xdist"
        fi

        active=$(jq -r '.customizations.vscode.settings."python.testing.coverageEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

        if [ "$active" = "true" ]; then
            coverage_package="coverage"
        fi

        # On recupère le fichier par defaut + le specifique + on complete + dedoublonne + supprime ligne vide

        echo -e "Pip configuration file was created (requirements-test.txt).\n"
    fi

    echo -e "${GREEN}> Install dependencies with pip (requirements-test.txt).${ENDCOLOR}\n"

    if [ -z "$(cat $WORKSPACE_PATH/requirements-test.txt)" ]; then
        echo -e "No package to install\n"
    else
        pip install -r $WORKSPACE_PATH/requirements-test.txt
        echo -e "\nDone\n"
    fi

else
    echo -e "\n${YELLOW}Nothing to do because PIP is not used.${ENDCOLOR}"
fi

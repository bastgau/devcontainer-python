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
        echo -e "\n${GREEN}> Initialize pip Manager (requirements-test.txt).${ENDCOLOR}\n"

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

        CONTAINER_TYPE=$(jq -r '.customizations.vscode.settings."container.type"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

        echo "" > /tmp/tmp_requirements.txt

        if [ -f "$WORKSPACE_PATH/.devcontainer/templates/default/requirements-test.txt" ]; then
            cat "$WORKSPACE_PATH/.devcontainer/templates/default/requirements-test.txt" >> /tmp/tmp_requirements.txt
        fi

        if [ -f "$WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/requirements-test.txt" ]; then
            cat "$WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/requirements-test.txt" >> /tmp/tmp_requirements.txt
        fi

        sed -i "s/{coverage_package}/$coverage_package/" /tmp/tmp_requirements.txt
        sed -i "s/{unittest_package}/$unittest_package/" /tmp/tmp_requirements.txt

        sed -i '/^$/d' /tmp/tmp_requirements.txt
        sort -u /tmp/tmp_requirements.txt > $WORKSPACE_PATH/requirements-test.txt

        rm -f /tmp/tmp_requirements.txt

        echo -e "Pip configuration file was created (requirements-test.txt)."
    fi

    echo -e "\n${GREEN}> Install dependencies with pip (requirements-test.txt).${ENDCOLOR}\n"

    if [ -z "$(cat $WORKSPACE_PATH/requirements-test.txt)" ]; then
        echo -e "No package to install\n"
    else
        pip install -r $WORKSPACE_PATH/requirements-test.txt
        echo -e "\nDone\n"
    fi

else
    echo -e "\n${YELLOW}Nothing to do because PIP is not used.${ENDCOLOR}"
fi

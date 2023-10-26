#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Install requirements.txt (dev)                #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

DEPENDENCY_MANAGER=$(jq -r '.customizations.vscode.settings."python.dependencyManager"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$DEPENDENCY_MANAGER" = "pip" ]; then

    # PREPARE PRE-COMMIT PACKAGE IF NEEDED.

    echo -e "\n${GREEN}> Pre-commit status.${ENDCOLOR}\n"

    PRE_COMMIT_ENABLED=$(jq -r '.customizations.vscode.settings."git.preCommitEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    if [ $PRE_COMMIT_ENABLED = "true" ]; then
        echo -e "Pre-commit will be activated for the project."
    else
        echo -e "Pre-commit won't be activated for the project."
    fi

    # PREPARE FORMATTER PACKAGE IF NEEDED.

    echo -e "\n${GREEN}> Identity the Python formatter to use from devcontainer.json.${ENDCOLOR}\n"

    defaultFormatter=$(jq -r '.customizations.vscode.settings."editor.defaultFormatter"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    formatter_package=""

    if [ "$defaultFormatter" = "ms-python.black-formatter" ]; then
        formatter_package="black"
    fi

    if [ "$defaultFormatter" = "eeyore.yapf" ]; then
        formatter_package="yapf"
    fi

    if [ "$defaultFormatter" = "ms-python.autopep8" ]; then
        formatter_package="autopep8"
    fi

    if [ "$defaultFormatter" = "null" ]; then
        echo -e "${RED}No Python formatter specified (not recommended).${ENDCOLOR}"
    else
        echo -e "Python formatter used in the project : '$defaultFormatter'"
    fi

    if [ ! -f "$WORKSPACE_PATH/requirements-dev.txt" ]; then
        echo -e "\n${GREEN}> Initialize pip Manager (requirements-dev.txt).${ENDCOLOR}\n"

        precommit_package=""

        if [ "$PRE_COMMIT_ENABLED" = "true" ]; then
            precommit_package="pre-commit"
        fi

        CONTAINER_TYPE=$(jq -r '.customizations.vscode.settings."container.type"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

        echo "" > /tmp/tmp_requirements.txt

        if [ -f "$WORKSPACE_PATH/.devcontainer/templates/default/requirements-dev.txt" ]; then
            cat "$WORKSPACE_PATH/.devcontainer/templates/default/requirements-dev.txt" >> /tmp/tmp_requirements.txt
        fi

        if [ -f "$WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/requirements-dev.txt" ]; then
            cat "$WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/requirements-dev.txt" >> /tmp/tmp_requirements.txt
        fi

        sed -i "s/{precommit_package}/$precommit_package/" /tmp/tmp_requirements.txt
        sed -i "s/{formatter_package}/$formatter_package/" /tmp/tmp_requirements.txt

        sed -i '/^$/d' /tmp/tmp_requirements.txt
        sort -u /tmp/tmp_requirements.txt > $WORKSPACE_PATH/requirements-dev.txt

        rm -f /tmp/tmp_requirements.txt

        echo -e "Pip configuration file was created (requirements-dev.txt)."

    fi

    echo -e "\n${GREEN}> Install dependencies with pip (requirements-dev.txt).${ENDCOLOR}\n"

    if [ -z "$(cat $WORKSPACE_PATH/requirements-dev.txt)" ]; then
        echo -e "No package to install\n"
    else
        pip install -r $WORKSPACE_PATH/requirements-dev.txt
        echo -e "\nDone\n"
    fi

else
    echo -e "\n${YELLOW}Nothing to do because PIP is not used.${ENDCOLOR}"
fi

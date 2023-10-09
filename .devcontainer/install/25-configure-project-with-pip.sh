#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Configure project with pip                    #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

DEPENDENCY_MANAGER=$(jq -r '.customizations.vscode.settings."python.dependencyManager"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$DEPENDENCY_MANAGER" = "pip" ]; then

    echo -e "\n${GREEN}> Pre-commit status.${ENDCOLOR}\n"

    PRE_COMMIT_ENABLED=$(jq -r '.customizations.vscode.settings."git.preCommitEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    if [ $PRE_COMMIT_ENABLED = "true" ]; then
        echo -e "Pre-commit will be activated for the project."
    else
        echo -e "Pre-commit won't be activated for the project."
    fi

    echo -e "\n${GREEN}> Identity the Python formatter to use from devcontainer.json.${ENDCOLOR}\n"

    defaultFormatter=$(jq -r '.customizations.vscode.settings."editor.defaultFormatter"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    formatter_package=""

    if [ "$defaultFormatter" = "ms-python.black-formatter" ]; then
        formatter_package="black"
    fi

    if [ "$defaultFormatter" = "eeyore.yapf" ]; then
        formatter_package="yapf"
    fi

    if [ "$defaultFormatter" = "null" ]; then
        echo -e "No Python formatter specified."
    else
        echo -e "Python formatter used in the project : '$defaultFormatter'"
    fi

    if [ ! -f "$WORKSPACE_PATH/requirements.txt" ]; then
        echo -e "\n${GREEN}> Initialize pip Manager (requirements.txt).${ENDCOLOR}\n"
        touch $WORKSPACE_PATH/requirements.txt
        echo -e "Pip configuration file was created (requirements.txt)."
    fi

    echo -e "\n${GREEN}> Install dependencies with pip (requirements.txt).${ENDCOLOR}\n"

    if [ -z "$(cat $WORKSPACE_PATH/requirements.txt)" ]; then
        echo -e "No package to install\n"
    else
        pip install -r $WORKSPACE_PATH/requirements.txt
        echo -e "\nDone\n"
    fi

    if [ ! -f "$WORKSPACE_PATH/requirements-dev.txt" ]; then
        echo -e "${GREEN}> Initialize pip Manager (requirements-dev.txt).${ENDCOLOR}\n"

        precommit_package=""

        if [ "$PRE_COMMIT_ENABLED" = "true" ]; then
            precommit_package="pre-commit"
        fi

cat <<EOF >>$WORKSPACE_PATH/requirements-dev.txt
yamllint
pyright
pylint
flake8
mypy
$formatter_package
$precommit_package
EOF

        echo -e "Pip configuration file was created (requirements-dev.txt).\n"

    fi

    echo -e "${GREEN}> Install dependencies with pip (requirements-dev.txt).${ENDCOLOR}\n"

    if [ -z "$(cat $WORKSPACE_PATH/requirements-dev.txt)" ]; then
        echo -e "No package to install\n"
    else
        pip install -r $WORKSPACE_PATH/requirements-dev.txt
        echo -e "\nDone\n"
    fi

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

cat <<EOF >>$WORKSPACE_PATH/requirements-test.txt
$unittest_package
$coverage_package
EOF

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
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}"
fi

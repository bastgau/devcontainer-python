#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

if [ "$DEPENDENCY_MANAGER" = "PIP" ];
then

    echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
    echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
    echo -e "${BLUE}#####     CONFIGURE PROJECT WITH PIP                    #####${ENDCOLOR}"
    echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
    echo -e "${BLUE}#############################################################${ENDCOLOR}"

    source $WORKSPACE_PATH/.venv/bin/activate

    echo -e "\n${GREEN}> Identity the Python formatter to use from devcontainer.json.${ENDCOLOR}\n"

    defaultFormatter=$(jq -r '.customizations.vscode.settings."editor.defaultFormatter"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    formatter_package=""

    if [ "$defaultFormatter" = "ms-python.black-formatter" ];
    then
        formatter_package="black"
    fi

    if [ "$defaultFormatter" = "eeyore.yapf" ];
    then
        formatter_package="yapf"
    fi

    if [ "$defaultFormatter" = "null" ];
    then
        echo -e "No Python formatter specified."
    else
        echo -e "Python formatter found is : '$defaultFormatter'"
    fi

    if [ ! -f "$WORKSPACE_PATH/requirements.txt" ];
    then
        echo -e "\n${GREEN}> Initialize PIP Manager (requirements.txt).${ENDCOLOR}\n"
        touch $WORKSPACE_PATH/requirements.txt
        echo -e "PIP configuration file was created (requirements.txt)."
    fi

    echo -e "\n${GREEN}> Install dependencies with PIP (requirements.txt).${ENDCOLOR}"
    pip install -r $WORKSPACE_PATH/requirements.txt
    echo -e "\nDone.\n"

    if [ ! -f "$WORKSPACE_PATH/requirements-dev.txt" ];
    then
        echo -e "${GREEN}> Initialize PIP Manager (requirements-dev.txt).${ENDCOLOR}\n"

        precommit_package=""

        if [ "$USE_PRE_COMMIT" = 1 ];
        then
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

        echo -e "PIP configuration file was created (requirements-dev.txt).\n"

    fi

    echo -e "${GREEN}> Install dependencies with PIP (requirements-dev.txt).${ENDCOLOR}\n"
    pip install -r $WORKSPACE_PATH/requirements-dev.txt
    echo -e "\nDone.\n"

    if [ ! -f "$WORKSPACE_PATH/requirements-test.txt" ];
    then
        echo -e "${GREEN}> Initialize PIP Manager (requirements-test.txt).${ENDCOLOR}\n"

        unittest_package=""
        coverage_package=""

        active=$(jq -r '.customizations.vscode.settings."python.testing.pytestEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

        if [ "$active" = "true" ];
        then
            unittest_package="pytest-xdist"
        fi

        active=$(jq -r '.customizations.vscode.settings."python.testing.coverageEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

        if [ "$active" = "true" ];
        then
            coverage_package="coverage"
        fi


cat <<EOF >>$WORKSPACE_PATH/requirements-test.txt
$unittest_package
$coverage_package
EOF

        echo -e "PIP configuration file was created (requirements-test.txt).\n"
    fi

    echo -e "${GREEN}> Install dependencies with PIP (requirements-test.txt).${ENDCOLOR}\n"
    pip install -r $WORKSPACE_PATH/requirements-test.txt
    echo -e "Done.\n"

else
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}"
fi

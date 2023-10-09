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

# INSTALL PACKAGE FROM REQUIREMENTS.TXT

    if [ ! -f "$WORKSPACE_PATH/requirements.txt" ]; then
        echo -e "\n${GREEN}> Initialize pip Manager (requirements.txt).${ENDCOLOR}\n"
        touch $WORKSPACE_PATH/requirements.txt
        echo -e "Pip configuration file was created (requirements.txt)."

        quantity=0

        echo -e "\n${GREEN}> Install package in the project (requirements.txt).${ENDCOLOR}\n"

        while true; do

            if [ "$quantity" -eq 0 ]; then
                echo -e "${BLUE}You can directly edit the 'requirements.txt' file to add packages faster and answer 'no' to the next question.${ENDCOLOR}"
                echo -e "\n${YELLOW}Do you want to install a package (pandas, numpy, snowflake-connector-python, streamlit, etc.)? (y/n)${ENDCOLOR}"
                read -p "> " choice
            else
                echo -e "\n${YELLOW}Do you want to install another package (pandas, numpy, snowflake-connector-python, streamlit, etc.)? (y/n)${ENDCOLOR}"
                read -p "> " choice
            fi

            case "$choice" in
                [Yy]*)

                    echo -e "\n${YELLOW}What is the package name?${ENDCOLOR}"
                    read -p "> " package_name

                    echo -e ""
                    pip install "$package_name"

                    if pip show "$package_name" >/dev/null 2>&1; then
                        echo -e "\n${BLUE}The package '$package_name' is now installed.${ENDCOLOR}"
                        echo $package_name >> $WORKSPACE_PATH/requirements.txt
                    else
                        echo -e "\n${RED}The package '$package_name' cannot be installed.${ENDCOLOR}"
                    fi

                    quantity=$((quantity + 1))

                ;;
                [Nn]*) echo -n ""; break ;;
                *) echo -e "\n${RED}Please answer with 'y' (yes) or 'n' (no).${ENDCOLOR}" ;;

            esac

        done

    fi

    echo -e "\n${GREEN}> Install dependencies with pip (requirements.txt).${ENDCOLOR}\n"

    if [ -z "$(cat $WORKSPACE_PATH/requirements.txt)" ]; then
        echo -e "No package to install"
    else
        pip install -r $WORKSPACE_PATH/requirements.txt
        echo -e "\nDone"
    fi

    if [ ! -f "$WORKSPACE_PATH/requirements-dev.txt" ]; then
        echo -e "\n${GREEN}> Initialize pip Manager (requirements-dev.txt).${ENDCOLOR}\n"

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

        echo -e "Pip configuration file was created (requirements-dev.txt)."

    fi

    echo -e "\n${GREEN}> Install dependencies with pip (requirements-dev.txt).${ENDCOLOR}\n"

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

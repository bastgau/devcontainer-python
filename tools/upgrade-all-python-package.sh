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

    CONTAINER_TYPE=$(jq -r '.customizations.vscode.settings."container.type"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    echo "" > /tmp/requirements.txt
    echo "" > /tmp/tmp_requirements.txt

    if [ "$CONTAINER_TYPE" == "azure-function-python" ]; then

        requirements_files=`find "$SOURCE_PATH" -mindepth 2 -maxdepth 2 -type f -name 'requirements.txt'`
        projects=`find "$SOURCE_PATH" -mindepth 1 -maxdepth 1 -type d -name "*"`

        if [ ! -n "$requirements_files" ]; then
            echo -e "${RED}No 'requirements.txt' files was found.${ENDCOLOR}\n"
        else

            IFS=$'\n'
            for file in $requirements_files; do
                cat "$file" >> /tmp/tmp_requirements.txt
            done

            sort -u /tmp/tmp_requirements.txt > /tmp/requirements.txt

            echo -e "${BLUE}The following files will be used.${ENDCOLOR}\n"

            for file in $requirements_files; do
                echo -e "- $file"
            done

            if [ "$(echo "$requirements_files" | wc -l)" -ne "$(echo "$projects" | wc -l)" ]; then
                echo -e "${RED}The number of 'requirements.txt' files should match the number of Azure Function projects.${ENDCOLOR}\n"
            fi

            echo -e ""

        fi

    else
        cat /workspaces/app/requirements.txt > /tmp/requirements.txt
    fi

    # INSTALL 'requirements.txt' FILES

    echo -e "${GREEN}> Update dependencies with PIP (requirements.txt).${ENDCOLOR}\n"
    pip install -r /tmp/requirements.txt --upgrade
    echo -e "Done\n"

    rm -f /tmp/requirements.txt /tmp/tmp_requirements.txt

    # INSTALL 'requirements-dev.txt' FILES

    echo -e "${GREEN}> Update dependencies with PIP (requirements-dev.txt).${ENDCOLOR}\n"
    pip install -r /workspaces/app/requirements-dev.txt --upgrade
    echo -e "Done\n"

    # INSTALL 'requirements-test.txt' FILES

    echo -e "${GREEN}> Update dependencies with PIP (requirements-test.txt).${ENDCOLOR}\n"
    pip install -r /workspaces/app/requirements-test.txt --upgrade
    echo -e "Done\n"

fi

if [ "$DEPENDENCY_MANAGER" = "poetry" ]; then
    poetry update
fi

#!/bin/bash

# ignored: poetry-dependency-manager

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####  Install requirements.txt                         #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

DEPENDENCY_MANAGER=$(jq -r '.customizations.vscode.settings."python.dependencyManager"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$DEPENDENCY_MANAGER" = "pip" ]; then

    # INSTALL PACKAGE FROM REQUIREMENTS.TXT

    if [ ! -f "$WORKSPACE_PATH/requirements.txt" ]; then
        echo -e "\n${GREEN}> Initialize pip Manager (requirements.txt).${ENDCOLOR}\n"

        echo "" > /tmp/tmp_requirements.txt

        if [ -f "$WORKSPACE_PATH/.devcontainer/templates/default/config/requirements.txt" ]; then
            cat "$WORKSPACE_PATH/.devcontainer/templates/default/config/requirements.txt" >> /tmp/tmp_requirements.txt
        fi

        CONTAINER_TYPE=$(jq -r '.customizations.vscode.settings."container.type"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

        if [ -f "$WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/config/requirements.txt" ]; then
            cat "$WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/config/requirements.txt" >> /tmp/tmp_requirements.txt
        fi

        sed -i '/^$/d' /tmp/tmp_requirements.txt
        sort -u /tmp/tmp_requirements.txt > $WORKSPACE_PATH/requirements.txt

        rm -f /tmp/tmp_requirements.txt

        echo -e "Pip configuration file was created (requirements.txt)."

        quantity=0

        echo -e "\n${GREEN}> Install package in the project (requirements.txt).${ENDCOLOR}\n"

        while true; do

            if [ "$quantity" -eq 0 ]; then
                echo -e "${BLUE}You can directly edit the 'requirements.txt' file to add packages faster and answer 'no' to the next question.${ENDCOLOR}"
                echo -e "\n${YELLOW}Do you want to install a package (pandas, numpy, marshmallow, streamlit, etc.)? (y/n)${ENDCOLOR}"
                read -p "> " choice
            else
                echo -e "\n${YELLOW}Do you want to install another package (pandas, numpy, marshmallow, streamlit, etc.)? (y/n)${ENDCOLOR}"
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
                *) echo -e "\n${RED}Please answer with 'y' (yes) or 'n' (no).${ENDCOLOR}\n" ;;

            esac

        done

    fi

    echo -e "\n${GREEN}> Install dependencies with pip (requirements.txt).${ENDCOLOR}\n"

    if [ -z "$(cat $WORKSPACE_PATH/requirements.txt)" ]; then
        echo -e "No package to install"
    else
        pip install -r $WORKSPACE_PATH/requirements.txt
        echo -e "\nDone\n"
    fi

else
    echo -e "\n${YELLOW}Nothing to do because PIP is not used.${ENDCOLOR}"
fi

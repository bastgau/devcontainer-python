#!/bin/bash

# ignored: azure-function-python

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####  Install requirements.txt (app-python version)    #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

DEPENDENCY_MANAGER=$(jq -r '.customizations.vscode.settings."python.dependencyManager"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$DEPENDENCY_MANAGER" = "pip" ]; then

    # INSTALL PACKAGE FROM REQUIREMENTS.TXT

    no_existing_file=true

    projects=`find "$SOURCE_PATH" -mindepth 1 -maxdepth 1 -type d -name "*"`
    requirements_files=`find "$SOURCE_PATH" -mindepth 2 -maxdepth 2 -type f -name 'requirements.txt'`

    if [ -n "$requirements_files" ]; then

        echo -e "\n${GREEN}> Initialize pip Manager (requirements.txt).${ENDCOLOR}"
        echo -e "\n${BLUE}At least one 'requirements.txt' file was found.${ENDCOLOR}\n"
        IFS=$'\n'
        for file in $requirements_files; do
            echo -e "- $file"
        done
        echo -e "\n${BLUE}These files will be used and not modified. No other file will be created.${ENDCOLOR}\n"
        no_existing_file=false

        if [ "$(echo "$requirements_files" | wc -l)" -ne "$(echo "$projects" | wc -l)" ]; then
            echo -e "${RED}The number of 'requirements.txt' files should match the number of Azure Function projects.${ENDCOLOR}\n"
        fi

    fi

    if [ "$no_existing_file" == true ]; then

        echo -e "\n${GREEN}> Initialize pip Manager (requirements.txt).${ENDCOLOR}\n"

        IFS=$'\n'
        CONTAINER_TYPE=$(jq -r '.customizations.vscode.settings."container.type"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

        for project in $projects; do

            echo "" > /tmp/tmp_requirements.txt

            if [ -f "$WORKSPACE_PATH/.devcontainer/templates/default/requirements.txt" ]; then
                cat "$WORKSPACE_PATH/.devcontainer/templates/default/requirements.txt" >> /tmp/tmp_requirements.txt
            fi

            if [ -f "$WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/requirements.txt" ]; then
                cat "$WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/requirements.txt" >> /tmp/tmp_requirements.txt
            fi

            sed -i '/^$/d' /tmp/tmp_requirements.txt
            sort -u /tmp/tmp_requirements.txt > $project/requirements.txt

            rm -f /tmp/tmp_requirements.txt

        done

        echo -e "Pip configuration file was created (requirements.txt)."

        quantity=0

        echo -e "\n${GREEN}> Install package in the project (requirements.txt).${ENDCOLOR}\n"

        requirements_files=`find "$SOURCE_PATH" -mindepth 2 -maxdepth 2 -type f -name 'requirements.txt'`

        for file in $requirements_files; do
            cat "$file" >> /tmp/tmp_requirements.txt
        done

        sort -u /tmp/tmp_requirements.txt > /tmp/requirements.txt

        if [ ! -z "$(cat /tmp/requirements.txt)" ]; then
            echo -e "${BLUE}> The following packages will be automatically installed.${ENDCOLOR}\n"
            cat /tmp/requirements.txt
        fi

        rm -f /tmp/requirements.txt /tmp/tmp_requirements.txt

        while true; do

            if [ "$quantity" -eq 0 ]; then
                echo -e "\n${BLUE}You can directly edit the 'requirements.txt' files to add packages faster and answer 'no' to the next question.${ENDCOLOR}"
                echo -e "\n${YELLOW}Do you want to install a package (pandas, numpy, snowflake-connector-python, streamlit, etc.)? (y/n)${ENDCOLOR}"
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

                        for project in $projects; do
                            echo $package_name >> $project/requirements.txt
                        done

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

    echo "" > /tmp/requirements.txt
    echo "" > /tmp/tmp_requirements.txt

    requirements_files=`find "$SOURCE_PATH" -mindepth 2 -maxdepth 2 -type f -name 'requirements.txt'`

    for file in $requirements_files; do
        cat "$file" >> /tmp/tmp_requirements.txt
    done

    sort -u /tmp/tmp_requirements.txt > /tmp/requirements.txt

    if [ -z "$(cat /tmp/requirements.txt)" ]; then
        echo -e "No package to install\n"
    else
        pip install -r /tmp/requirements.txt
        echo -e "\nDone\n"
    fi

    rm -f /tmp/requirements.txt /tmp/tmp_requirements.txt

else
    echo -e "\n${YELLOW}Nothing to do because PIP is not used.${ENDCOLOR}"
fi

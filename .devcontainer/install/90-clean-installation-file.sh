#!/bin/bash

# can-be-removed-after-installation

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Clean the installation files                  #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Clean the installation files.${ENDCOLOR}\n"

echo -e "${BLUE}This is the last script. You can now clean the installation files which are used only for a new project.${ENDCOLOR}"

while true; do

    echo -e "\n${YELLOW}Do you want to remove all installation files used only for a new project? (y/n)${ENDCOLOR}"
    read -p "> " choice

    case "$choice" in
        [Yy]*)
            rm -rf "$WORKSPACE_PATH/.devcontainer/templates"
            rm -rf "$WORKSPACE_PATH/docs/dev-container-configuration"

            install_files=()

            echo -e ""

            while IFS= read -r -d $'\0' current_file ; do
                if grep -q "# can-be-removed-after-installation" "$current_file"; then
                    echo -e "- Deleted: "$current_file
                    rm $current_file
                    continue
                fi

                CONTAINER_TYPE=$(jq -r '.customizations.vscode.settings."container.type"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

                if grep -q "# ignored: $CONTAINER_TYPE" "$current_file"; then
                    echo -e "- Deleted: "$current_file
                    rm $current_file
                    continue
                fi

                DEPENDENCY_MANAGER=$(jq -r '.customizations.vscode.settings."python.dependencyManager"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

                if grep -q "# ignored: $DEPENDENCY_MANAGER-dependency-manager" "$current_file"; then
                    echo -e "- Deleted: "$current_file
                    rm $current_file
                    continue
                fi

            done < <(find ./ -type f -name "*.sh" -print0)

            echo -e "\nDone. The installation files are deleted.\n"

            break
        ;;
        [Nn]*)
            echo -e "\nNo file was deleted.\n"
            break
        ;;
        *) echo -e "\n${RED}Please answer with 'y' (yes) or 'n' (no).${ENDCOLOR}" ;;
    esac

done

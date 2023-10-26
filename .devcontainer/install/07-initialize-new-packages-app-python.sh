#!/bin/bash

# ignored: azure-function-python

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Initialize new packages (app python)          #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

mkdir -p $SOURCE_PATH

if [ "$(ls -A "$SOURCE_PATH" | wc -l)" -ge 1 ]; then
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}"
else

    quantity=0

    while true; do

        if [ "$quantity" -eq 0 ]; then
            echo -e "\n${YELLOW}Do you want to create a package? (y/n)${ENDCOLOR}"
            read -p "> " choice
        else
            echo -e "\n${YELLOW}Do you want to create another package? (y/n)${ENDCOLOR}"
            read -p "> " choice
        fi

        case "$choice" in
            [Yy]*)

                echo -e "\n${YELLOW}How do you name the package?${ENDCOLOR}"
                read -p "> " package_name

                if [ -z "$package_name" ]; then
                    echo -e "\n${RED}The package name cannot be empty. Please enter a valid name.${ENDCOLOR}"
                elif [ -d "$SOURCE_PATH/$package_name" ]; then
                    echo -e "\n${RED}This package has already been created.${ENDCOLOR}"
                else

                    mkdir -p "$SOURCE_PATH/$package_name"
                    cp -r "$WORKSPACE_PATH/.devcontainer/templates/app-python/new_package/"* "$SOURCE_PATH/$package_name"

                    files=(`ls $SOURCE_PATH/$package_name/*.py`)

                    for file in "${files[@]}"; do
                        sed -i "s/{package_name}/$package_name/" "$file"
                    done

                    quantity=$((quantity + 1))

                fi
            ;;
            [Nn]*) break ;;
            *) echo -e "\n${RED}Please answer with 'y' (yes) or 'n' (no).${ENDCOLOR}" ;;

        esac

    done

    if [ "$quantity" -ge 1 ]; then
        echo -e "\n${BLUE}You have created $quantity package(s).${ENDCOLOR}"
    fi

fi

echo -e ""

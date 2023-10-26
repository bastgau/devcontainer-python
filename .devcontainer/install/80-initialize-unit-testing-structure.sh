#!/bin/bash

# ignored: azure-function-python

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Initialize Unit Testing structure             #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

mkdir -p $SOURCE_PATH

pytest_enabled=$(jq -r '.customizations.vscode.settings."python.testing.pytestEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$pytest_enabled" != "true" ] || [ "$(ls -A "$SOURCE_PATH" | wc -l)" -eq 0 ]; then
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}"
else

    echo -e "\n${GREEN}> Unit Testing directory structure will be created.${ENDCOLOR}"

    mkdir -p "$UNIT_TESTING_PATH"
    touch "$UNIT_TESTING_PATH/__init__.py"

    package_directories=$(ls "$SOURCE_PATH" | sort)

    quantity=0

    CONTAINER_TYPE=$(jq -r '.customizations.vscode.settings."container.type"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    for package_name in $package_directories; do

        if [ ! -d "$UNIT_TESTING_PATH/tests_$package_name" ];
        then

            mkdir -p "$UNIT_TESTING_PATH/tests_$package_name"
            touch "$UNIT_TESTING_PATH/tests_$package_name/__init__.py"

            cp -r "$WORKSPACE_PATH/.devcontainer/templates/$CONTAINER_TYPE/unittest/"* "$UNIT_TESTING_PATH/tests_$package_name/"

            files=(`ls "$UNIT_TESTING_PATH/tests_$package_name/"*.py`)

            for file in "${files[@]}"; do
                sed -i "s/{package_name}/$package_name/" "$file"
            done

            echo -e "\nUnit Testing directory for 'tests_$package_name' created"
            quantity=$((quantity + 1))
        fi

    done


    if [ "$quantity" -eq 0 ]; then
        echo -e "\nNo Unit Testing directory has been created"
    fi

fi

echo -e ""

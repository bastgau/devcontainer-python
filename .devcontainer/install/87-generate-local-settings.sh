#!/bin/bash

# ignored: app-python

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Generate local.settings.json file             #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

projects=(`ls $SOURCE_PATH/`)

created=false

for project in "${projects[@]}"; do

    if [ ! -f "$SOURCE_PATH/$project/local.settings.json" ]; then
        echo -e "\n${GREEN}> Generate local.settings.json file for ${project}.${ENDCOLOR}"
        cp "$SOURCE_PATH/$project/local.settings.json-example" "$WORKSPACE_PATH/src/$project/local.settings.json"
        echo -e "\nDone."
        created=true
    fi

done

if [ $created == false ]; then
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}"
fi

echo -e ""

#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Generate .vscode/launch.json file             #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

mkdir -p $SOURCE_PATH

if [ -f "$WORKSPACE_PATH/.vscode/launch.json" ]; then
    echo -e "\n${YELLOW}Nothing to do because file is already existing.\n${ENDCOLOR}"
else

    echo -e "\n${GREEN}> Generate file '.vscode/launch.json'.${ENDCOLOR}\n"


    # Create initial file.
    merged_content=$(echo '{"version": "0.2.0", "configurations": []}' | jq '.')

    # Add configuration specifically for the container type.
    CONTAINER_TYPE=$(jq -r '.customizations.vscode.settings."container.type"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    if [ -f "$WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/launch.json" ]; then
        content=$(cat ./.devcontainer/templates/${CONTAINER_TYPE}/launch.json)
        merged_content=$(echo "$merged_content" | jq ".configurations += $content")
    fi

    # Add other configurations.
    if [ -f "$WORKSPACE_PATH/.devcontainer/templates/default/launch.json" ]; then
        content=$(cat ./.devcontainer/templates/default/launch.json)
        merged_content=$(echo "$merged_content" | jq ".configurations += $content")
    fi

    # Pretty-print the content and create the file.
    formatted_content=$(echo $merged_content | jq -c '.')
    echo $formatted_content | python -m json.tool --indent=2  > "$WORKSPACE_PATH/.vscode/launch.json"

    echo -e "Done.\n"

fi

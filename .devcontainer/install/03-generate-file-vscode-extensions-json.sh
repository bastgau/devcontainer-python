#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Generate .vscode/extensions.json file         #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

mkdir -p $SOURCE_PATH

if [ -f "$WORKSPACE_PATH/.vscode/extensions.json" ]; then
    echo -e "\n${YELLOW}Nothing to do because file is already existing.\n${ENDCOLOR}"
else

    echo -e "\n${GREEN}> Generate file '.vscode/extensions.json'.${ENDCOLOR}\n"

    # Create initial file.
    merged_content=$(echo '{"recommendations": []}' | jq '.')

    # Add extensions specifically for the container type.
    CONTAINER_TYPE=$(jq -r '.customizations.vscode.settings."container.type"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    if [ -f "$WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/extensions.json" ]; then
        content=$(cat ./.devcontainer/templates/${CONTAINER_TYPE}/extensions.json)
        merged_content=$(echo "$merged_content" | jq ".recommendations += $content")
    fi

    # Add extensions specifically for the default formatter.
    defaultFormatter=$(jq -r '.customizations.vscode.settings."editor.defaultFormatter"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    if [ "$defaultFormatter" == "ms-python.autopep8" ] || [ "$defaultFormatter" == "ms-python.black-formatter" ] || [ "$defaultFormatter" == "eeyore.yapf" ]; then
        content="[\"$defaultFormatter\"]"
        merged_content=$(echo "$merged_content" | jq ".recommendations += $content")
    fi

    # Add other extensions.
    if [ -f "$WORKSPACE_PATH/.devcontainer/templates/default/extensions.json" ]; then
        content=$(cat ./.devcontainer/templates/default/extensions.json)
        merged_content=$(echo "$merged_content" | jq ".recommendations += $content")
    fi

    # Pretty-print the content and create the file.
    formatted_content=$(echo $merged_content | jq -c '.')
    echo $formatted_content | python -m json.tool --indent=2  > "$WORKSPACE_PATH/.vscode/extensions.json"

    echo -e "Done.\n"

fi

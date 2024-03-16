#!/bin/bash

# can-be-removed-after-installation

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Generate .vscode/extensions.json file         #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

mkdir -p $SOURCE_PATH
mkdir -p "$WORKSPACE_PATH/.vscode"

echo -e "\n${GREEN}> Generate file '.vscode/extensions.json'.${ENDCOLOR}\n"

if [ -f "$WORKSPACE_PATH/.vscode/extensions.json" ]; then
    echo -e "${YELLOW}Nothing to do because file is already existing.\n${ENDCOLOR}"
else

    # Create initial file.
    merged_content=$(echo '{"recommendations": []}' | jq '.')

    # Add extensions specifically for the container type.
    CONTAINER_TYPE=$(jq -r '.customizations.vscode.settings."container.type"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    if [ -f "$WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/config/extensions.json" ]; then
        content=$(cat $WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/config/extensions.json)
        merged_content=$(echo "$merged_content" | jq ".recommendations += $content")
    fi

    # Add other extensions.
    if [ -f "$WORKSPACE_PATH/.devcontainer/templates/default/config/extensions.json" ]; then
        content=$(cat $WORKSPACE_PATH/.devcontainer/templates/default/config/extensions.json)
        merged_content=$(echo "$merged_content" | jq ".recommendations += $content")
    fi

    # Pretty-print the content and create the file.
    formatted_content=$(echo $merged_content | jq -c '.')
    echo $formatted_content | python -m json.tool --indent=2  > "$WORKSPACE_PATH/.vscode/extensions.json"

    echo -e "Done.\n"

fi

# Add extensions specifically for the default formatter in 'devcontainer.json' file.
defaultFormatter=$(jq -r '.customizations.vscode.settings."editor.defaultFormatter"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$defaultFormatter" == "ms-python.autopep8" ] || [ "$defaultFormatter" == "ms-python.black-formatter" ] || [ "$defaultFormatter" == "eeyore.yapf" ]; then
    exist=`cat $WORKSPACE_PATH/.devcontainer/devcontainer.json | jq ".customizations.vscode.extensions | contains([\"$defaultFormatter\"])"`
    if [ $exist == 'false' ]; then
        echo -e "${GREEN}> Update file '.devcontainer/devcontainer.json'.${ENDCOLOR}\n"
        cat $WORKSPACE_PATH/.devcontainer/devcontainer.json | jq ".customizations.vscode.extensions += [\"$defaultFormatter\"]" > /tmp/devcontainer.json
        mv /tmp/devcontainer.json $WORKSPACE_PATH/.devcontainer/devcontainer.json
        echo -e "Done.\n"
    fi
fi

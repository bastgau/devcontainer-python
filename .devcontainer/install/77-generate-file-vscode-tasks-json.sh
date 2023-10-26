#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Generate .vscode/tasks.json file              #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

mkdir -p $SOURCE_PATH

if [ -f "$WORKSPACE_PATH/.vscode/tasks.json" ]; then
    echo -e "\n${YELLOW}Nothing to do because file is already existing.\n${ENDCOLOR}"
else

    echo -e "\n${GREEN}> Generate file '.vscode/tasks.json'.${ENDCOLOR}\n"

    # Create initial file.
    merged_content=$(echo '{"version":"2.0.0", "tasks":[]}' | jq '.')

    # Add configuration specifically for the container type.
    CONTAINER_TYPE=$(jq -r '.customizations.vscode.settings."container.type"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    if [ -f "$WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/tasks.json" ]; then

        projects=(`ls $SOURCE_PATH/`)

        for project in "${projects[@]}"; do
            content=$(cat $WORKSPACE_PATH/.devcontainer/templates/${CONTAINER_TYPE}/tasks.json)
            path=$(echo "$SOURCE_PATH/$project" | sed 's/\//\\\//g')
            content=$(echo "$content" | sed "s/{project_path}/$path/")
            merged_content=$(echo "$merged_content" | jq ".tasks += $content")
        done

    fi

    # Add other configurations.
    if [ -f "$WORKSPACE_PATH/.devcontainer/templates/default/tasks.json" ]; then
        content=$(cat $WORKSPACE_PATH/.devcontainer/templates/default/tasks.json)
        merged_content=$(echo "$merged_content" | jq ".tasks += $content")
    fi

    # Pretty-print the content and create the file.
    formatted_content=$(echo $merged_content | jq '(.tasks | unique) as $unique_tasks | .tasks = $unique_tasks' | jq '.tasks |= sort_by(.label)' | jq -c '.')
    echo $formatted_content | python -m json.tool --indent=2  > "$WORKSPACE_PATH/.vscode/tasks.json"

    echo -e "Done.\n"

fi

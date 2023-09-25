#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Generate file .vscode/launch.json             #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

if [ -f "$WORKSPACE_PATH/.vscode/launch.json" ]; then
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}"
else

    echo -e "\n${GREEN}> Generate file .vscode/launch.json.${ENDCOLOR}\n"

cat <<EOF >"$WORKSPACE_PATH/.vscode/launch.json"
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Execute current file",
            "type": "python",
            "request": "launch",
            "program": "\${file}",
            "console": "integratedTerminal"
        }
    ]
}
EOF

    package_directories=$(ls /workspaces/app/src | sort)

    for package_directory in $package_directories; do

new_config=$(
cat <<EOF
        {
            "name": "Execute module '$package_directory'",
            "type": "python",
            "request": "launch",
            "module": "$package_directory"
        }
EOF
)

        jq --argjson new_config "$new_config" '.configurations += [$new_config]' "$WORKSPACE_PATH/.vscode/launch.json" > /tmp/temporary_launch.json
        mv /tmp/temporary_launch.json "$WORKSPACE_PATH/.vscode/launch.json"

    done

    echo -e "Done"

fi

echo -e ""

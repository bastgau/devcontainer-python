#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Configure additional package indexes          #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

echo -e "\n${GREEN}> Configure additional package indexes.${ENDCOLOR}\n"

PIP_EXTRA_INDEX_URL=$(jq -r '.customizations.vscode.settings."python.pip.extraIndexUrl"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$PIP_EXTRA_INDEX_URL" != "" ] && [ "$PIP_EXTRA_INDEX_URL" != "null" ]; then

    echo -e "An additional package indexes is specified (value: ${YELLOW}$PIP_EXTRA_INDEX_URL${ENDCOLOR}).\n"

    DEPENDENCY_MANAGER=$(jq -r '.customizations.vscode.settings."python.dependencyManager"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

    if [ "$DEPENDENCY_MANAGER" = "pip" ]; then

        echo -e "${GREEN}> Update file '.venv/pip.conf'.${ENDCOLOR}\n"

        if [ ! -f "$WORKSPACE_PATH/.venv/pip.conf" ]; then

cat <<EOF >"$WORKSPACE_PATH/.venv/pip.conf"
[global]
EOF

        fi

        sed -i "/^\[global\]$/,/^\[/ {/extra-index-url/d}" "$WORKSPACE_PATH/.venv/pip.conf"
        sed -i "/^\[global\]$/a extra-index-url=$PIP_EXTRA_INDEX_URL" "$WORKSPACE_PATH/.venv/pip.conf"

        echo -e "Done"

        echo -e "\n${GREEN}> Install pakages needed for the authentification.${ENDCOLOR}\n"
        pip install keyring artifacts-keyring

        echo -e ""

    else
        echo -e "${RED}Only implemented for the projects using 'pip' as dependency manager.${ENDCOLOR}\n"
    fi



else
    echo -e "${YELLOW}Nothing to do.${ENDCOLOR}\n"
fi

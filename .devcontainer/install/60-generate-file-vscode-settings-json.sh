#!/bin/bash

# can-be-removed-after-installation

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Generate file .vscode/settings.json           #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

if [ -f "$WORKSPACE_PATH/.vscode/settings.json" ]; then
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}"
else

    echo -e "\n${GREEN}> Generate file '.vscode/settings.json'.${ENDCOLOR}\n"

cat <<EOF >$WORKSPACE_PATH/.vscode/settings.json
{
}
EOF

    echo -e "Done"

fi

echo -e ""

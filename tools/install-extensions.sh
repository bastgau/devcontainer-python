#!/bin/bash

source $WORKSPACE_PATH/.venv/bin/activate
sleep 0.5

. "$WORKSPACE_PATH/tools/color.sh"

clear

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####      Install extensions                           #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${YELLOW}> Extension related to the formatter${ENDCOLOR}\n"

defaultFormatter=$(jq -r '.customizations.vscode.settings."editor.defaultFormatter"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$defaultFormatter" == "ms-python.autopep8" ] || [ "$defaultFormatter" == "ms-python.black-formatter" ] || [ "$defaultFormatter" == "eeyore.yapf" ]; then
    echo -e "- $defaultFormatter:\n"
    code --install-extension "$defaultFormatter"
else
    echo -e "${RED}The formatter '$defaultFormatter' mentionned in the configuration is not recognized.${ENDCOLOR}"
    echo -e "${RED}Please check your configuration!${ENDCOLOR}\n"
fi

echo -e "\n${YELLOW}> Extensions defined in .devcontainer/devcontainer.json${ENDCOLOR}\n"

extensions=$(jq -r '.customizations.vscode.extensions[]' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

for extension in $extensions; do
    echo -e "- $extension:\n"
    code --install-extension "$extension"
    echo -e ""
done

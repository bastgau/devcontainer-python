#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Fix VSCode Settings File                      #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Fix VSCode Settings File.${ENDCOLOR}\n"

jq 'del(.["python.formatting.autopep8Path",
        "python.formatting.blackPath",
        "python.linting.flake8Path",
        "python.linting.flake8Enabled",
        "python.linting.mypyPath",
        "python.linting.mypyEnabled",
        "python.linting.pylintPath",
        "python.linting.pylintEnabled"
])' $HOME/.vscode-server/data/Machine/settings.json > /tmp/.vscode-server-settings.json

mv /tmp/.vscode-server-settings.json $HOME/.vscode-server/data/Machine/settings.json

echo -e "File '$HOME/.vscode-server/data/Machine/settings.json' has been modified to fix slow issue with linters.\n"

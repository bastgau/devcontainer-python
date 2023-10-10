#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Initialize & Check pyright version            #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

if which pyright >/dev/null; then
    echo -e "\n${GREEN}> Initialize & Check pyright version.${ENDCOLOR}\n"

    if [ -d "$HOME/.cache/pyright-python/nodeenv" ]; then
        quantity=$(find "$HOME/.cache/pyright-python/nodeenv" -maxdepth 1 -type f | wc -l)

        if [ "$quantity" -eq 0 ]; then
            rm -rf /home/vscode/.cache/pyright-python/nodeenv
        fi
    fi

    timeout --preserve-status 5s pyright --version

    if [ "$?" == 143 ]; then
        rm -rf "$HOME/.cache/pyright-python/nodeenv"
        echo -e "\n\n${RED}Initialization has failed. Version cannot be found.${RED}"
    fi

fi

echo -e ""

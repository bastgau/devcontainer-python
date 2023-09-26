#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Configure Git                                 #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"


echo -e "\n${GREEN}> Configure Git.${ENDCOLOR}\n"

git config --global --add safe.directory $WORKSPACE_PATH
git config --global core.eol lf
git config --global core.autocrlf false
git config --global pull.rebase true

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

echo -e "Done\n"

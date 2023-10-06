#!/bin/bash

source $WORKSPACE_PATH/.venv/bin/activate
sleep 0.5

. "$WORKSPACE_PATH/tools/color.sh"

clear

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####      Reset project                                #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Reset project files.${ENDCOLOR}\n"

pre-commit uninstall

rm -vf "$WORKSPACE_PATH/.devonctainer/user.env"

rm -vf "$WORKSPACE_PATH/.vscode/launch.json"
rm -vf "$WORKSPACE_PATH/.vscode/settings.json"

rm -vf "$WORKSPACE_PATH/requirements-dev.txt"
rm -vf "$WORKSPACE_PATH/requirements-test.txt"
rm -vf "$WORKSPACE_PATH/requirements.txt"

rm -vf "$WORKSPACE_PATH/.coverage"
rm -vf "$WORKSPACE_PATH/.pre-commit-config.yaml"

rm -rvf "$WORKSPACE_PATH/src/"
rm -rvf "$WORKSPACE_PATH/tests/"

echo -e "Done\n"

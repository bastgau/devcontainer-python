#!/bin/bash

source /workspaces/app/.venv/bin/activate
sleep 0.5

. "$WORKSPACE_PATH/tools/color.sh"

clear

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####      Purge Python file cache                      #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${YELLOW}> Remove __pycache__ files.${ENDCOLOR}"
find $WORKSPACE_PATH -type d -iregex ".*__pycache__.*" -exec rm -rf {} +
echo -e "\nDone"

echo -e "\n${YELLOW}> Remove mypy_cache files.${ENDCOLOR}"
find $WORKSPACE_PATH -type d -iregex ".*\.mypy_cache" -exec rm -rf {} +
echo -e "\nDone"

echo -e "\n${YELLOW}> Remove pytest_cache files.${ENDCOLOR}"
find $WORKSPACE_PATH -type d -iregex ".*\.pytest_cache" -exec rm -rf {} +
echo -e "\nDone\n"

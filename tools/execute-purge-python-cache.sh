#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
BOLD="\e[1m"

ENDCOLOR="\e[0m"

clear

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####           PURGE PYTHON CACHE                      #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${YELLOW}> Remove __pycache__ files.${ENDCOLOR}"
find $WORKSPACE_PATH -type d -iregex ".*__pycache__.*" -exec rm -rf {} +
echo -e "Done."

echo -e "\n${YELLOW}> Remove mypy_cache files.${ENDCOLOR}"
find $WORKSPACE_PATH -type d -iregex ".*\.mypy_cache" -exec rm -rf {} +
echo -e "Done."

echo -e "\n${YELLOW}> Remove pytest_cache files.${ENDCOLOR}"
find $WORKSPACE_PATH -type d -iregex ".*\.pytest_cache" -exec rm -rf {} +
echo -e "Done.\n"

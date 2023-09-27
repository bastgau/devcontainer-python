#!/bin/bash

source $WORKSPACE_PATH/.venv/bin/activate
sleep 0.5

. "$WORKSPACE_PATH/tools/color.sh"

clear

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####      Build package                                #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${RED}Not yet implemented${ENDCOLOR}\n"

# echo -e "\n${YELLOW}> Install build library.${ENDCOLOR}"
# python3 -m pip install --upgrade build

# echo -e "\n${YELLOW}> Build project $PACKAGE_NAME.${ENDCOLOR}"
# python3 -m build

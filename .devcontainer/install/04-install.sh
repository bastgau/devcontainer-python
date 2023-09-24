#!/bin/bash

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     UPDATE PIP / IDENTIFY DEPENDENCY MANAGER      #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

echo -e "\n${GREEN}> Update PIP tool.${ENDCOLOR}\n"
pip install --upgrade pip

echo -e "\n${GREEN}> Identify the packaging and dependency manager to install.${ENDCOLOR}\n"

if [ "$DEPENDENCY_MANAGER"  != "" ];
then
    echo -e "Environment Variable 'DEPENDENCY_MANAGER' was found with the value : $DEPENDENCY_MANAGER\n"
fi

if [ "$DEPENDENCY_MANAGER" != "PIP" ] && [ "$DEPENDENCY_MANAGER" != "POETRY" ];
then
    echo -e "${RED}> No packaging and dependency manager was configured.${ENDCOLOR}\n"
    exit 1
fi

#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     CONFIGURE PROJECT WITH POETRY                 #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

if [ "$DEPENDENCY_MANAGER" = "POETRY" ];
then

    source $WORKSPACE_PATH/.venv/bin/activate

    echo -e "${GREEN}> Install POETRY tool and install dependencies.${ENDCOLOR}\n"
    curl -sSL https://install.python-poetry.org | python3 -
    poetry completions bash >> ~/.bash_completion

    if [ ! -f "pyproject.toml" ];
    then
        poetry init
    fi

    poetry install

else
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}\n"
fi

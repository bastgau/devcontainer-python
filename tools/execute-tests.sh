#!/bin/bash

source $WORKSPACE_PATH/.venv/bin/activate
sleep 0.5

. "$WORKSPACE_PATH/tools/color.sh"

clear

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####      Check & execute unit tests                   #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

VIRTUAL_ENVIRONMENT_DIRECTORY="/workspaces/app/.venv/bin"

if [ -d "$WORKSPACE_PATH/tests" ]; then

    # TOOL : pyright

    if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/pyright" ]; then
        echo -e "\n${YELLOW}> Pyright / Pylance.${ENDCOLOR}\n"
        pyright $WORKSPACE_PATH/tests
    fi

    # TOOL : pylint

    if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/pylint" ]; then
        echo -e "\n${YELLOW}> Pylint.${ENDCOLOR}\n"
        pylint $WORKSPACE_PATH/tests --score=false --jobs=10

        if [ "$?" -eq 0 ]; then
            echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
        fi
    fi

    # TOOL : flake8

    if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/flake8" ]; then
        echo -e "\n${YELLOW}> Flake8.${ENDCOLOR}\n"
        flake8 $WORKSPACE_PATH/tests

        if [ "$?" -eq 0 ]; then
            echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
        fi
    fi

    # TOOL : mypy

    if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/mypy" ]; then
        echo -e "\n${YELLOW}> Mypy.${ENDCOLOR}\n"
        mypy $WORKSPACE_PATH/tests
    fi

    # TOOL : yapf

    if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/yapf" ]; then
        echo -e "\n${YELLOW}> Yapf.${ENDCOLOR}\n"
        result=$(yapf --diff $WORKSPACE_PATH/tests --recursive | grep "(reformatted)" | grep "+++")

        if [ "$result" = "" ]; then
            echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
        else
            result_modified=$(echo "$result" | sed 's/+++/would reformat/g; s/(reformatted)//g')
            echo -e "${BOLD}$result_modified${ENDCOLOR}"
        fi
    fi

    # TOOL : black

    if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/black\n" ]; then
        echo -e "\n${YELLOW}> Black.${ENDCOLOR}"
        $VIRTUAL_ENVIRONMENT_DIRECTORY/black --check $WORKSPACE_PATH/tests
    fi

    if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/pytest" ]; then
        echo -e "\n${YELLOW}> Pytest.${ENDCOLOR}\n"
        pytest $WORKSPACE_PATH/tests/*/test_*.py -v -s -n auto
    fi

    if [ -x "$VIRTUAL_ENVIRONMENT_DIRECTORY/coverage" ]; then
        echo -e "\n${YELLOW}> Coverage Analysis.${ENDCOLOR}\n"
        coverage run -m pytest $WORKSPACE_PATH/tests/*/test_*.py -q

        echo -e "\n${YELLOW}> Coverage Report.${ENDCOLOR}\n"
        coverage report -m
    fi

    echo -e "\n${BLUE}All verifications are Done${ENDCOLOR}\n"

else
    echo -e "\n${YELLOW}No directory '$WORKSPACE_PATH/tests' found.${YELLOW}\n"
fi

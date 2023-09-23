#!/bin/bash

source $WORKSPACE_PATH/.venv/bin/activate
sleep 0.5

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
BOLD="\e[1m"

ENDCOLOR="\e[0m"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####          CHECK & EXECUTE UNIT TEST (PYTHON)       #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${YELLOW}> Pyright / Pylance.${ENDCOLOR}"
pyright $WORKSPACE_PATH/tests -p $WORKSPACE_PATH/tools/pyrightconfig.json

echo -e "\n${YELLOW}> Pylint${ENDCOLOR}"
pylint $WORKSPACE_PATH/tests --score=false --jobs=10 --rcfile=$WORKSPACE_PATH/setup.cfg

if [ "$?" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
fi

echo -e "\n${YELLOW}> Flake8.${ENDCOLOR}"
flake8 $WORKSPACE_PATH/tests --config=$WORKSPACE_PATH/setup.cfg

if [ "$?" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
fi

echo -e "\n${YELLOW}> Mypy.${ENDCOLOR}"
mypy $WORKSPACE_PATH/tests --config-file=$WORKSPACE_PATH/setup.cfg

echo -e "\n${YELLOW}> Pylama.${ENDCOLOR}"
pylama $WORKSPACE_PATH/tests --option $WORKSPACE_PATH/setup.cfg

if [ "$?" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
fi

echo -e "\n${YELLOW}> Yapf.${ENDCOLOR}"
yapf --diff $WORKSPACE_PATH/tests --recursive

if [ "$?" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}Success: no issues found${ENDCOLOR}"
fi

echo -e "\n${YELLOW}> Pytest.${ENDCOLOR}\n"
pytest $WORKSPACE_PATH/tests/*/test_*.py $WORKSPACE_PATH/tests/test_*.py -v -s -n auto

echo -e "\n${YELLOW}> Coverage Analysis.${ENDCOLOR}\n"
coverage run -m pytest $WORKSPACE_PATH/tests/*/test_*.py $WORKSPACE_PATH/tests/test_*.py -q

echo -e "\n${YELLOW}> Coverage Report.${ENDCOLOR}\n"
coverage report -m

echo -e "\n${BLUE}All verifications are done.${ENDCOLOR}\n"

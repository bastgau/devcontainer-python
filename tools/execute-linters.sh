#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

echo -e "\n${YELLOW}> Pylint.${ENDCOLOR}\n"

pylint my_project/

echo -e "\n${YELLOW}> Flake8.${ENDCOLOR}\n"

flake8 my_project/

echo -e "\n${YELLOW}> Mypy.${ENDCOLOR}\n"

mypy my_project/

echo -e "\n${YELLOW}> Pylama.${ENDCOLOR}\n"

pylama my_project/

echo -e "\n${BLUE}All verifications are done.${ENDCOLOR}\n"

#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Initialize new packages                       #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

mkdir -p $SOURCE_PATH

if [ "$(ls -A "$SOURCE_PATH" | wc -l)" -ge 1 ]; then
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}"
else

    quantity=0

    while true; do

        if [ "$quantity" -eq 0 ]; then
            echo -e "\n${YELLOW}Do you want to create a package? (y/n)${ENDCOLOR}"
            read -p "> " choice
        else
            echo -e "\n${YELLOW}Do you want to create another package? (y/n)${ENDCOLOR}"
            read -p "> " choice
        fi

        case "$choice" in
            [Yy]*)

                echo -e "\n${YELLOW}How do you name the package?${ENDCOLOR}"
                read -p "> " package_name

                if [ -z "$package_name" ]; then
                    echo -e "\n${RED}The package name cannot be empty. Please enter a valid name.${ENDCOLOR}"
                elif [ -d "$SOURCE_PATH/$package_name" ]; then
                    echo -e "\n${RED}This package has already been created.${ENDCOLOR}"
                else

                    mkdir -p "$SOURCE_PATH/$package_name"

                    touch "$SOURCE_PATH/$package_name/py.typed"
                    touch "$SOURCE_PATH/$package_name/__init__.py"

cat <<EOF >"$SOURCE_PATH/$package_name/application.py"
""" File: src/$package_name/application.py """


def run() -> None:  # pylint: disable=unused-variable
    """
    The \`run\` function calls the \`hello\` function and prints the returned message.
    """
    message: str = hello()
    print(message)


def hello(name: str = "John Doe") -> str:
    """
    The function \`hello\` takes an optional \`name\` parameter and returns a greeting message with the
    provided name or a default name if none is provided.

    Args:
    name (str): The \`name\` parameter is a string that represents a person's name.
    It has a default value of "John Doe" if no value is provided when calling the \`hello\` function.

    Returns:
    the string "Hello {name} from $package_name! How are you today!"
    """

    return f"Hello {name} from $package_name! How are you today?"
EOF

cat <<EOF >"$SOURCE_PATH/$package_name/__main__.py"
""" File: src/$package_name/__main__.py """

import $package_name.application as app

if __name__ == "__main__":
    app.run()
EOF

                    # Si le package streamlit est installé alors on ajoute le fichier run_streamlit.py
                    streamlit_package=(`pip freeze | grep streamlit | wc -l`)

                    if [ "$streamlit_package" == "1" ]; then

cat <<EOF >"$SOURCE_PATH/$package_name/run_streamlit.py"
""" File: src/$package_name/run_streamlit.py """

from typing import Any

import streamlit as st
import $package_name.application as app


def run_streamlit() -> None:  # pylint: disable=unused-variable
    """
    The \`run_streamlit\` function calls the \`hello\` function and start a streamlit app.
    """
    message: Any = app.hello()
    st.write(message)  # type: ignore


run_streamlit()
EOF

                    fi

                    quantity=$((quantity + 1))

                fi
            ;;
            [Nn]*) break ;;
            *) echo -e "\n${RED}Please answer with 'y' (yes) or 'n' (no).${ENDCOLOR}" ;;

        esac

    done

    if [ "$quantity" -ge 1 ]; then
        echo -e "\n${BLUE}You have created $quantity package(s).${ENDCOLOR}"
    fi

fi

echo -e ""

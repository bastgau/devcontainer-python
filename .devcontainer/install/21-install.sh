#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     INITIALIZE NEW PACKAGES                       #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

mkdir -p $SOURCE_PATH

if [ "$(ls -A "$SOURCE_PATH")" ]; then
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
                    mkdir -p "$UNIT_TESTING_PATH/tests_$package_name"

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
    the string "Hello {name}! How are you today!"
    """

    return f"Hello {name}! How are you today?"
EOF

cat <<EOF >"$SOURCE_PATH/$package_name/__main__.py"
""" File: src/$package_name/__main__.py """

import $package_name.application as app

if __name__ == "__main__":
    app.run()
EOF

                    touch "$UNIT_TESTING_PATH/tests_$package_name/__init__.py"

cat <<EOF >"$UNIT_TESTING_PATH/tests_$package_name/test_application.py"
""" File : tests/tests_$package_name/test_application.py """

import $package_name.application as app


def test_hello() -> None:  # pylint: disable=unused-variable
    """..."""

    assert app.hello() == "Hello John Doe! How are you today?"
    assert app.hello("Jane Doe") == "Hello Jane Doe! How are you today?"
EOF

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

# if [ ! -d $WORKSPACE_FOLDER/src/$PACKAGE_NAME ];
# then
#     mkdir -p $WORKSPACE_FOLDER/src/$PACKAGE_NAME
# fi

# if [ ! -d $UNIT_TESTING_PATH ];
# then
#     mkdir -p $UNIT_TESTING_PATH
# fi

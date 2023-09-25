#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Initialize Unit Testing structure             #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

mkdir -p $SOURCE_PATH

pytest_enabled=$(jq -r '.customizations.vscode.settings."python.testing.pytestEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$pytest_enabled" != "true" ] || [ "$(ls -A "$SOURCE_PATH" | wc -l)" -eq 0 ]; then
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}"
else

    echo -e "\n${GREEN}> Unit testing directory structure will be created.${ENDCOLOR}\n"

    mkdir -p $UNIT_TESTING_PATH

    package_directories=$(ls "$SOURCE_PATH" | sort)

    for package_directory in $package_directories; do

        if [ ! -d "$UNIT_TESTING_PATH/tests_$package_directory" ];
        then

            mkdir -p "$UNIT_TESTING_PATH/tests_$package_directory"
            touch "$UNIT_TESTING_PATH/tests_$package_directory/__init__.py"

cat <<EOF >"$UNIT_TESTING_PATH/tests_$package_directory/test_application.py"
""" File : tests/tests_$package_directory/test_application.py """

import $package_directory.application as app


def test_hello() -> None:  # pylint: disable=unused-variable
    """..."""

    assert app.hello() == "Hello John Doe! How are you today?"
    assert app.hello("Jane Doe") == "Hello Jane Doe! How are you today?"
EOF

        fi

    done

    echo -e "Done"

fi

echo -e ""

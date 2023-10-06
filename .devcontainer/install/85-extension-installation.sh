#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     VS Code extention installation                #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

mkdir -p $SOURCE_PATH

defaultFormatter=$(jq -r '.customizations.vscode.settings."editor.defaultFormatter"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$defaultFormatter" == "ms-python.autopep8" ] || [ "$defaultFormatter" == "ms-python.black-formatter" ] || [ "$defaultFormatter" == "eeyore.yapf" ]; then

    echo -e "\n${GREEN}> The project is configured to use a formatter.${ENDCOLOR}"

    case "$defaultFormatter" in
        "ms-python.autopep8")
            defaultFormatter_name="Autopep8"
            defaultFormatter_url="https://marketplace.visualstudio.com/items?itemName=ms-python.autopep8"
            defaultFormatter_id="ms-python.autopep8"
            ;;
        "ms-python.black-formatter")
            defaultFormatter_name="Black"
            defaultFormatter_url="https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter"
            defaultFormatter_id="ms-python.black-formatter"
            ;;
        "eeyore.yapf")
            defaultFormatter_name="Yapf"
            defaultFormatter_url="https://marketplace.visualstudio.com/items?itemName=eeyore.yapf"
            defaultFormatter_id="eeyore.yapf"
            ;;
        *)
            # Código a ejecutar si no se encuentra coincidencia con ningún PATRÓN
            ;;
    esac

    if [ "$defaultFormatter_name" != "" ]; then

        echo -e "${YELLOW}\nYou have to install the following extension to be compliant with the configuration.${ENDCOLOR}\n"
        echo -e "${YELLOW}Formatter name:${ENDCOLOR} '$defaultFormatter_name'"
        echo -e "${YELLOW}VS Marketplace Link:${ENDCOLOR} '$defaultFormatter_url'"

        echo -e "\n${BLUE}The extension will be installed automatically.${ENDCOLOR}\n"
        code --install-extension "$defaultFormatter_id"

        quantity=(`code --list-extensions --show-versions | grep "$defaultFormatter_id" | wc -l`)

        if [ $quantity == 0 ]; then

            echo -e "\n${RED}The extension has not been automatically installed.${ENDCOLOR}"

            echo -e "\n${BLUE}To install the extension manually, you can in the sidebar on the left, in the 'extension' menu (ctrl+shift+x) search for the extension from its extension id which is:${ENDCOLOR} '$defaultFormatter_id'\n"

            echo -e "${YELLOW}... When the extension is installed, press any key to continue ..."
            read -s -p " " -n 1 -r
            echo -e "${ENDCOLOR}"

            quantity=(`code --list-extensions --show-versions | grep "$defaultFormatter_id" | wc -l`)

        fi

        echo "$quantity"

        if [ "$quantity" == "code or code-insiders is not installed" ]; then
            echo -e "\nNot able to check if the installation is correctly installed. Check will be done later."
        elif [ "$quantity" == "0" ]; then
            echo -e "\n${RED}The extension seems not to be installed. Please check again!${ENDCOLOR}"
            echo -e "${RED}Failure to adhere to a common code formatting tool in a Python project can lead to style inconsistencies, merge conflicts, and reduced team productivity.${ENDCOLOR}\n"
            echo -e "${RED}Despite this anomaly, the container installation processus will continue.${ENDCOLOR}"
        else
            echo -e "\nDone. Extension is installed."
        fi

    else
        echo -e "${RED}\nThe formatter mentionned in the configuration is not recognized. Please check your configuration!${ENDCOLOR}"
        echo -e "${RED}Please check your configuration!${ENDCOLOR}"
    fi

else
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}"
fi

echo -e ""

#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Configure additional package indexes          #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

echo -e "\n${GREEN}> Configure additional package indexes.${ENDCOLOR}\n"

if [ ! -f "$WORKSPACE_PATH/.devcontainer/project.env" ]; then
    touch "$WORKSPACE_PATH/.devcontainer/project.env"
fi

source "$WORKSPACE_PATH/.devcontainer/project.env"

if [ "$DEPENDENCY_MANAGER" = "PIP" ]; then

    if [ ! -v $EXTRA_INDEX_URL ]; then

        while true; do

                if [ "$quantity" -eq 0 ]; then
                    echo -e "\n${YELLOW}Do you want to configure an additional package indexes? (y/n)${ENDCOLOR}"
                    read -p "> " choice
                fi

                case "$choice" in
                    [Yy]*)

                        echo -e "\n${YELLOW}Indicate the url of the additional package indexes?${ENDCOLOR}"
                        read -p "> " url_package_indexes

                        if [ -z "$url_package_indexes" ]; then
                            echo -e "\n${RED}The url of the additional package indexes cannot be empty. Please enter a valid url.${ENDCOLOR}"
                        else

cat <<EOF >>"$WORKSPACE_PATH/.venv/project.env"
EXTRA_INDEX_URL=$url_package_indexes
EOF
                        fi
                    ;;
                    [Nn]*) break ;;
                    *) echo -e "\n${RED}Please answer with 'y' (yes) or 'n' (no).${ENDCOLOR}" ;;

                esac

        done

    fi

fi

source "$WORKSPACE_PATH/.devcontainer/project.env"

if [ ! -f "$WORKSPACE_PATH/.venv/pip.conf" ]; then

cat <<EOF >>"$WORKSPACE_PATH/.venv/pip.conf"
[global]
EOF

fi

sed -i '/^\[global\]$/,/^\[/ {/extra-index-url/d}' "$WORKSPACE_PATH/.devcontainer/project.env"

if [ "$EXTRA_INDEX_URL" != "" ]; then
    # pip install keyring artifact-keyring
    sed -i '/^\[global\]$/a $EXTRA_INDEX_URL' "$WORKSPACE_PATH/.devcontainer/project.env"
fi
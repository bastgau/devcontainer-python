#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Configure Git                                 #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Configure Git.${ENDCOLOR}\n"

if [ ! -f "$WORKSPACE_PATH/.devcontainer/user.env" ]; then
    touch "$WORKSPACE_PATH/.devcontainer/user.env"
fi

source "$WORKSPACE_PATH/.devcontainer/user.env"

if [ "$GIT_USERNAME" = "" ]; then

    while true; do

        echo -e "${YELLOW}What is your name (format: Firstname Lastname)?${ENDCOLOR}"
        read -p "> " git_name

        if [ -z "$git_name" ]; then
            echo -e "${RED}Your name cannot be empty. Please enter a valid name.${ENDCOLOR}"
        else
            echo "GIT_USERNAME=\"$git_name\"" >> "$WORKSPACE_PATH/.devcontainer/user.env"
            break
        fi

    done

fi

if [ "$GIT_EMAIL" = "" ]; then

    while true; do

        echo -e "\n${YELLOW}What is your email?${ENDCOLOR}"
        read -p "> " git_email
        echo ""

        if [ -z "$git_email" ]; then
            echo -e "\n${RED}Your email cannot be empty. Please enter a valid email.${ENDCOLOR}"
        else
            echo "GIT_EMAIL=\"$git_email\"" >> "$WORKSPACE_PATH/.devcontainer/user.env"
            break
        fi

    done

fi
set -o allexport
source "$WORKSPACE_PATH/.devcontainer/user.env"
set +o allexport

git config --global --add safe.directory "$WORKSPACE_PATH"
git config --global core.eol lf
git config --global core.autocrlf false
git config --global pull.rebase true

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

echo -e "Done"

echo -e "\n${GREEN}> Update '.bashrc' file.${ENDCOLOR}\n"

script_name=$(basename "$0" | tr '[:lower:]' '[:upper:]')

sed -i  "/# \[START\]:GENERATED_FROM_$script_name/,/# \[END\]:GENERATED_FROM_$script_name/d" ~/.bashrc

cat <<EOF >>~/.bashrc
# [START]:GENERATED_FROM_$script_name
source "\$WORKSPACE_PATH/.devcontainer/user.env"
# [END]:GENERATED_FROM_$script_name
EOF

echo -e "Done\n"

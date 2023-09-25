#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     PREPARE VENV / CONFIGURE GIT                  #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Configure virtual environment.${ENDCOLOR}\n"

sudo chgrp vscode $WORKSPACE_PATH/.venv
sudo chown vscode $WORKSPACE_PATH/.venv

python3 -m venv $WORKSPACE_PATH/.venv
PATH="$WORKSPACE_PATH/.venv/bin:$PATH"

mkdir -p /home/vscode/.local/
mkdir -p $WORKSPACE_PATH/.venv/lib

if [ -e /home/vscode/.local/lib ];
then
    rm -rf /home/vscode/.local/lib
fi

ln -s $WORKSPACE_PATH/.venv/lib /home/vscode/.local/

if [ ! -f $WORKSPACE_PATH/.vscode/settings.json ];
then
cat <<EOF >$WORKSPACE_PATH/.vscode/settings.json
{
}
EOF
fi

echo -e "Done."

echo -e "\n${GREEN}> Configure Git.${ENDCOLOR}\n"

git config --global --add safe.directory $WORKSPACE_PATH
git config --global core.eol lf
git config --global core.autocrlf false
git config --global pull.rebase true

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

echo -e "Done.\n"

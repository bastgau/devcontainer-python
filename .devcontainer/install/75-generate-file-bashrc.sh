#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Generate file .bashrc                         #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Generate file '.bashrc'.${ENDCOLOR}\n"

script_name=$(basename "$0" | tr '[:lower:]' '[:upper:]')

sed -i  "/# \[START\]:GENERATED_FROM_$script_name/,/# \[END\]:GENERATED_FROM_$script_name/d" ~/.bashrc

cat <<EOF >>~/.bashrc
# [START]:GENERATED_FROM_$script_name

source /usr/lib/git-core/git-sh-prompt
source /usr/share/bash-completion/completions/git

export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_HIDE_IF_PWD_IGNORED=1
PS1='\[\e[33;52m\][\t] \[\033[01;34m\]\w\[\e[1;32m\]\$(__git_ps1 " (%s)")\[\e[0;37m\] \$\[\033[00m\] '

RED="\e[31m"
ENDCOLOR="\e[0m"

defaultFormatter=\$(jq -r '.customizations.vscode.settings."editor.defaultFormatter"' \$WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "\$defaultFormatter" == "ms-python.autopep8" ] || [ "\$defaultFormatter" == "ms-python.black-formatter" ] || [ "\$defaultFormatter" == "eeyore.yapf" ]; then

        quantity=(\`code --list-extensions --show-versions 2>/dev/null | grep "\$defaultFormatter" | wc -l\`)

        if [ "\$quantity" == "0" ]; then
                echo -e "\n\${RED}The extension '\$defaultFormatter' related to the formatter seems not to be installed."
                echo -e "Please check again or install the extensions via the task named 'Tools: Install extensions'.\n"
                echo -e "Failure to adhere to a common code formatting tool in a Python project can lead to style inconsistencies, merge conflicts, and reduced team productivity.\${ENDCOLOR}\n"
        fi

else
    echo -e "\n\${RED}The formatter '\$defaultFormatter' mentionned in the configuration is not recognized.\${ENDCOLOR}"
    echo -e "\${RED}Please check your configuration!\${ENDCOLOR}\n"
fi

export PATH="$WORKSPACE_PATH/tools:\$PATH"
source /workspaces/app/.venv/bin/activate

# [END]:GENERATED_FROM_$script_name
EOF

echo -e "Done\n"

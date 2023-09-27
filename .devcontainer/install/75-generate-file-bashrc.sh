#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Generate file .bashrc                         #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Generate file '.bashrc'.${ENDCOLOR}\n"

script_name=$(basename "$0" | tr '[:lower:]' '[:upper:]')

sed -i  "/# \[START\]:GENERATED_01/,/# \[END\]:GENERATED_01/d" ~/.bashrc

cat <<EOF >>~/.bashrc
# [START]:GENERATED_FROM_$script_name

source /usr/lib/git-core/git-sh-prompt
source /usr/share/bash-completion/completions/git

export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_HIDE_IF_PWD_IGNORED=1
PS1='\[\e[33;52m\][\t] \[\033[01;34m\]\w\[\e[1;32m\]\$(__git_ps1 " (%s)")\[\e[0;37m\] \$\[\033[00m\] '

export PATH="$WORKSPACE_PATH/tools:\$PATH"

# [END]:GENERATED_FROM_$script_name
EOF

echo -e "Done\n"

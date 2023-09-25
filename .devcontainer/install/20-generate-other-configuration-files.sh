#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Generate other configuration files            #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Generate file for Vim.${ENDCOLOR}\n"

cat <<EOF >~/.vimrc
filetype on          " Détection du type de fichier
syntax on            " Coloration syntaxique
set background=dark  " Adapte les couleurs pour un fond noir (idéeal dans PuTTY)
set linebreak        " Coupe les lignes au dernier mot et pas au caractère (requier Wrap lines, actif par défaut)
set visualbell       " Utilisation du clignotement à la place du "beep"
set showmatch        " Surligne le mots recherchés dans le texte
set hlsearch         " Surligne tous les résultats de la recherche
set autoindent       " Auto-indentation des nouvelles lignes
set expandtab        " Remplace les "Tabulation" par des espaces
set shiftwidth=4     " (auto) Indentation de 2 espaces
set smartindent      " Active "smart-indent" (améliore l'auto-indentation, notamment en collant du texte déjà indenté)
set smarttab         " Active "smart-tabs" (améliore l'auto-indentation, Gestion des espaces en début de ligne pour l'auto-indentation)
set softtabstop=4    " Tabulation = 2 espaces
set mouse-=a
set backspace=indent,eol,start
EOF

echo -e "Done\n"

echo -e "${GREEN}> Generate file for .bashrc.${ENDCOLOR}\n"

script_name=$(basename "$0" | tr '[:lower:]' '[:upper:]')

sed -i  "/# \[START\]:AUTO-GENERATED_01/,/# \[END\]:AUTO-GENERATED_01/d" ~/.bashrc

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

#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Generate file .vimrc                          #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Generate file '.vimrc'.${ENDCOLOR}\n"

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

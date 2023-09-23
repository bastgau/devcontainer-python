#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####           GENERAL INSTALLATION                    #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Configure virtual environment.${ENDCOLOR}\n"

sudo chgrp vscode $WORKSPACE_PATH/.venv
sudo chown vscode $WORKSPACE_PATH/.venv

python3 -m venv $WORKSPACE_PATH/.venv
PATH="$WORKSPACE_PATH/.venv/bin:$PATH"

mkdir -p /home/vscode/.local/
mkdir -p $WORKSPACE_PATH/.venv/lib
ln -s $WORKSPACE_PATH/.venv/lib /home/vscode/.local/
echo -e "Done."

echo -e "\n${GREEN}> Configure Git.${ENDCOLOR}\n"

git config --global --add safe.directory $WORKSPACE_PATH
git config --global core.eol lf
git config --global core.autocrlf false
git config --global pull.rebase true

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

echo -e "Done.\n"

echo -e "${GREEN}> Update PIP tool.${ENDCOLOR}\n"
pip install --upgrade pip

echo -e "\n${GREEN}> Identify the packaging and dependency manager to install.${ENDCOLOR}\n"

PIP_MANAGER=false
POETRY_MANAGER=false

if [ "$DEPENDENCY_MANAGER"  != "" ];
then
    echo -e "Environment Variable 'DEPENDENCY_MANAGER' was found with the value : $DEPENDENCY_MANAGER\n"
fi

if [ "$DEPENDENCY_MANAGER" = "PIP" ];
then
    PIP_MANAGER=true
fi

if [ "$DEPENDENCY_MANAGER" = "POETRY" ];
then
    POETRY_MANAGER=true
fi

if [ "$POETRY_MANAGER" = false ] && [ "$PIP_MANAGER" = false ];
then
    echo -e "${RED}> No packaging and dependency manager was configured.${ENDCOLOR}\n"
    exit 1
fi

source $WORKSPACE_PATH/.venv/bin/activate

if [ "$PIP_MANAGER" = true ];
then

    if [ ! -f "$WORKSPACE_PATH/requirements.txt" ];
    then
        echo -e "${GREEN}> Initialize PIP Manager (requirements.txt).${ENDCOLOR}\n"
        touch $WORKSPACE_PATH/requirements.txt
        echo -e "PIP configuration file was created (requirements.txt).\n"
    fi

    echo -e "${GREEN}> Install dependencies with PIP (requirements.txt).${ENDCOLOR}\n"
    pip install -r $WORKSPACE_PATH/requirements.txt
    echo -e "Done.\n"

    if [ ! -f "$WORKSPACE_PATH/requirements-dev.txt" ];
    then
        echo -e "${GREEN}> Initialize PIP Manager (requirements-dev.txt).${ENDCOLOR}\n"

        defaultFormatter=$(jq -r '.customizations.vscode.settings."editor.defaultFormatter"' .devcontainer/devcontainer.json);

        formatter_package=""

        if [ "$defaultFormatter" = "ms-python.black-formatter" ];
        then
            formatter_package="black"
        fi

        if [ "$defaultFormatter" = "eeyore.yapf" ];
        then
            formatter_package="yapf"
        fi

cat <<EOF >>$WORKSPACE_PATH/requirements-dev.txt
yamllint
pyright
pylint
flake8
mypy
$formatter_package
EOF

        echo -e "PIP configuration file was created (requirements-dev.txt).\n"

    fi

    echo -e "${GREEN}> Install dependencies with PIP (requirements-dev.txt).${ENDCOLOR}\n"
    pip install -r $WORKSPACE_PATH/requirements-dev.txt
    echo -e "Done.\n"

    if [ ! -f "$WORKSPACE_PATH/requirements-test.txt" ];
    then
        echo -e "${GREEN}> Initialize PIP Manager (requirements-test.txt).${ENDCOLOR}\n"

        unittest_active=$(jq -r '.customizations.vscode.settings."python.testing.pytestEnabled"' .devcontainer/devcontainer.json);

        unittest_package=""

        if [ "$unittest_active" = "true" ];
        then
            unittest_package="pytest"
        fi

cat <<EOF >>$WORKSPACE_PATH/requirements-test.txt
$unittest_package
EOF

        echo -e "PIP configuration file was created (requirements-test.txt).\n"
    fi

    echo -e "${GREEN}> Install dependencies with PIP (requirements-test.txt).${ENDCOLOR}\n"
    pip install -r $WORKSPACE_PATH/requirements-test.txt
    echo -e "Done.\n"

fi

if [ "$POETRY_MANAGER" = true ];
then

    echo -e "${GREEN}> Install POETRY tool and install dependencies.${ENDCOLOR}\n"
    curl -sSL https://install.python-poetry.org | python3 -
    poetry completions bash >> ~/.bash_completion

    if [ ! -f "pyproject.toml" ];
    then
        poetry init
    fi

    poetry install

fi

sudo chmod +x $WORKSPACE_PATH/.devcontainer/install-post.sh
$WORKSPACE_PATH/.devcontainer/install-post.sh

cd $WORKSPACE_PATH

if [ "$USE_PRECOMMIT" = 1 ];
then
    pre-commit install
fi

cat <<EOF >>~/.vimrc
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

cat <<EOF >>~/.bashrc
source /usr/lib/git-core/git-sh-prompt
source /usr/share/bash-completion/completions/git

export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_HIDE_IF_PWD_IGNORED=1
PS1='\[\e[33;52m\][\t] \[\033[01;34m\]\w\[\e[1;32m\]\$(__git_ps1 " (%s)")\[\e[0;37m\] \$\[\033[00m\] '

export PATH="$WORKSPACE_PATH/tools:$PATH"
export PACKAGE_PATH="$WORKSPACE_PATH/src/$PACKAGE_NAME"
EOF

echo -e "\n${YELLOW}Installation is finished!${ENDCOLOR}"
echo -e "${YELLOW}You can close this terminal and re-open a new terminal!${ENDCOLOR}\n"

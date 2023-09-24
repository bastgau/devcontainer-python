#!/bin/bash

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     PRE-COMMIT INSTALLATION                       #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

cd $WORKSPACE_PATH

if [ "$USE_PRECOMMIT" = 1 ];
then

    if [ ! -f "$WORKSPACE_PATH/.pre-commit-config.yaml" ];
    then

        echo -e "\n${GREEN}> Create pre-commit file.${ENDCOLOR}\n"

        defaultFormatter=$(jq -r '.customizations.vscode.settings."editor.defaultFormatter"' .devcontainer/devcontainer.json);

        formater_precommit=""

        if [ "$defaultFormatter" = "eeyore.yapf" ];
        then
        formater_precommit=$(cat <<EOF
- repo: https://github.com/google/yapf
    rev: v0.40.1
    hooks:
      - id: yapf
        args: ["--diff"]
EOF
)
        fi

cat <<EOF >>$WORKSPACE_PATH/.pre-commit-config.yaml
---
repos:
  - repo: https://github.com/adrienverge/yamllint
    rev: v1.32.0
    hooks:
      - id: yamllint
        args: []
  - repo: https://github.com/PyCQA/flake8
    rev: 6.0.0
    hooks:
      - id: flake8
        args: []
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.4.1
    hooks:
      - id: mypy
        args: []
  - repo: https://github.com/pylint-dev/pylint
    rev: v2.17.4
    hooks:
      - id: pylint
        args: []
  - repo: https://github.com/necaris/pre-commit-pyright
    rev: '1.1.53'
    hooks:
      - id: pyright
  $formater_precommit
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.3.0
    hooks:
      - id: check-json
      # - id: check-yaml
      # - id: mixed-line-ending
      #  args: ['--fix=lf']
      - id: no-commit-to-branch
        args: [--branch, master, --branch, main]
EOF

    echo -e "Done.\n"

    fi

    echo -e "\n${GREEN}> Install pre-commit.${ENDCOLOR}\n"
    pre-commit install

else
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}"
fi

echo -e ""

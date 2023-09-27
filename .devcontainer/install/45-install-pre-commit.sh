#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Install pre-commit                            #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

source $WORKSPACE_PATH/.venv/bin/activate

cd $WORKSPACE_PATH

PRE_COMMIT_ENABLED=$(jq -r '.customizations.vscode.settings."git.preCommitEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

if [ "$PRE_COMMIT_ENABLED" = "true" ]; then

    if [ ! -f "$WORKSPACE_PATH/.pre-commit-config.yaml" ]; then

        echo -e "\n${GREEN}> Create pre-commit file.${ENDCOLOR}\n"

        defaultFormatter=$(jq -r '.customizations.vscode.settings."editor.defaultFormatter"' .devcontainer/devcontainer.json);

        formater_precommit=""

        if [ "$defaultFormatter" = "eeyore.yapf" ]; then
        formater_precommit=$(cat <<EOF
- repo: local
  hooks:
    - id: yapf
      name: yapf
      entry: /workspaces/app/.venv/bin/yapf
      language: system
      types: [python]
      files: ^.*\.py$
EOF
)
        fi

cat <<EOF >>$WORKSPACE_PATH/.pre-commit-config.yaml
---
repos:
  - repo: local
    hooks:
      - id: yamllint
        name: yamllint
        entry: /workspaces/app/.venv/bin/yamllint
        language: system
        types: [python]
        files: ^.*\.(yml|yaml)$

  - repo: local
    hooks:
      - id: pyright
        name: pyright
        entry: /workspaces/app/.venv/bin/pyright
        language: system
        types: [python]
        files: ^.*\.py$

  - repo: local
    hooks:
      - id: pylint
        name: pylint
        entry: /workspaces/app/.venv/bin/pylint
        language: system
        types: [python]
        files: ^.*\.py$

  - repo: local
    hooks:
      - id: flake8
        name: flake8
        entry: /workspaces/app/.venv/bin/flake8
        language: system
        types: [python]
        files: ^.*\.py$

  - repo: local
    hooks:
      - id: mypy
        name: mypy
        entry: /workspaces/app/.venv/bin/mypy
        language: system
        types: [python]
        files: ^.*\.py$

  - repo: local
    hooks:
      - id: yapf
        name: yapf
        entry: /workspaces/app/.venv/bin/yapf
        language: system
        types: [python]
        files: ^.*\.py$

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.3.0
    hooks:
      - id: check-json
      - id: no-commit-to-branch
        args: [--branch, master, --branch, main]

EOF

    echo -e "Done"

    fi

    echo -e "\n${GREEN}> Install pre-commit.${ENDCOLOR}\n"
    pre-commit install  --install-hooks

else
    echo -e "\n${YELLOW}Nothing to do.${ENDCOLOR}"
fi

echo -e ""

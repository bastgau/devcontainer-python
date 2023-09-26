#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Project review                                #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Project review.${ENDCOLOR}\n"

DEPENDENCY_MANAGER=$(jq -r '.customizations.vscode.settings."python.dependencyManager"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);
PRE_COMMIT_ENABLED=$(jq -r '.customizations.vscode.settings."git.preCommitEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);
PYTEST_ENABLED=$(jq -r '.customizations.vscode.settings."python.testing.pytestEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);
UNITTEST_ENABLED=$(jq -r '.customizations.vscode.settings."python.testing.unittestEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);
COVERAGE_ENABLED=$(jq -r '.customizations.vscode.settings."python.testing.coverageEnabled"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);
FORMATTER=$(jq -r '.customizations.vscode.settings."editor.defaultFormatter"' $WORKSPACE_PATH/.devcontainer/devcontainer.json);

echo -e "The dependency manager used for the project is ${YELLOW}$DEPENDENCY_MANAGER${ENDCOLOR}."
echo -e "The formatter used for the project is ${YELLOW}$FORMATTER${ENDCOLOR}.\n"

if [ $PRE_COMMIT_ENABLED = "true" ]; then
    echo -e "✔️ Pre-commit"
else
    echo -e "✖️ Pre-commit"
fi

if [ $PYTEST_ENABLED = "true" ]; then
    echo -e "✔️ Pytest"
else
    echo -e "✖️ Pytest"
fi

if [ $UNITTEST_ENABLED = "true" ]; then
    echo -e "✔️ Unittest"
else
    echo -e "✖️ Unittest"
fi

if [ $COVERAGE_ENABLED = "true" ]; then
    echo -e "✔️ Code coverage"
else
    echo -e "✖️ Code coverage"
fi

echo -e ""

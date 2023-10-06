######  **◀️ Previous step: [Configure code coverage](./05-configure-code-coverage.md)**

# Configure pre-commit (optional)

> A pre-commit is a script or a series of automated actions executed before a set of code changes is committed into a version control system like Git. It helps verify code compliance, apply style standards, and detect potential errors before they are integrated into the main repository.

You can skip this step if you don't want to set up pre-commit.

## Information about pre-commit

**Name:** Pre-commit<br>
**Website Link:** https://pre-commit.com/

## Modify the configuration

To set up pre-commit, you must modify the configuration file *'devcontainer.json'* located in the directory named *'.devcontainer/'*.

You must modify the value of the attribute named *'git.preCommitEnabled'*.

```txt
customizations
└── vscode
    └── settings
        └── settings
            └── git.preCommitEnabled <<<
```

The possible values are 'true' and 'false'. To activate pre-commit, the result should be :

```json
"git.preCommitEnabled": true,
```

###### **▶ Next step: [Information linters](./07-information-linters.md)****

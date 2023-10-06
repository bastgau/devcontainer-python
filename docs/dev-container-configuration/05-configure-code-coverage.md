######  **◀️ Previous step: [Configure unit tests](./04-configure-unit-tests.md)**

# Configure Code Coverage (recommended)

> Code coverage is a metric that measures the percentage of code lines or branches executed by a set of tests in a software application. It helps assess how thoroughly a codebase has been tested, identifying areas that may need more testing to improve software reliability.

You can skip this step if you don't want to set up coverage.

## Information about coverage

**Name:** Coverage<br>
**Website Link:** https://coverage.readthedocs.io/en

## Modify the configuration

To set up coverage, you must modify the configuration file *'devcontainer.json'* located in the directory named *'.devcontainer/'*.

You must modify the value of the attribute named *'python.testing.coverageEnabled'*.

```txt
customizations
└── vscode
    └── settings
        └── settings
            └── python.testing.coverageEnabled <<<
```

The possible values are 'true' and 'false'. To activate coverage, the result should be :

```json
"python.testing.coverageEnabled": true,
```

###### **▶ Next step: [Configure pre-commit](./06-configure-pre-commit.md)****

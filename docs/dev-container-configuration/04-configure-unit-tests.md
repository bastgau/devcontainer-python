######  **◀️ Previous step: [Configure a formater](./03-configure-a-formatter.md)**

# Configure unit tests (recommended)

> Unit tests are automated checks performed on individual code components to ensure their proper functioning. They help ensure software quality and reliability by isolating and testing each unit independently.

You can skip this step if you don't want to set up unit tests.

## Choose an unit test library

**Name:** Pytest<br>
**Website Link:** https://docs.pytest.org/en/

**Name:** Unittest<br>
**Website Link:** https://docs.python.org/3/library/unittest.html

You can decide to use the both libraries.

## Modify the configuration

When your choice is made, you must modify the configuration file *'devcontainer.json'* located in the directory named *'.devcontainer/'*.

You must modify the value of one or two attributes named *'python.testing.pytestEnabled'* and *'python.testing.unittestEnabled'*

```txt
customizations
└── vscode
    └── settings
        └── settings
            ├── python.testing.pytestEnabled <<<
            └── python.testing.unittestEnabled <<<
```

The possible values are 'true' and 'false'.

To activate pytest, the result should be :

```json
"python.testing.pytestEnabled": true,
```

To activate unittest, the result should be :

```json
"python.testing.unittestEnabled": true,
```

###### **▶ Next step: [Configure code coverage](./05-configure-code-coverage.md)**

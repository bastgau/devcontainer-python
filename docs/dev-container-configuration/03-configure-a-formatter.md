######  **◀️ Previous step: [Configure a packaging and dependency manager](./02-configure-packaging-dependency-manager.md)**

# Configure a formatter (mandatory)

> A code formatter is a tool that automates code formatting according to predefined style rules. It ensures consistent code presentation, making it easier to read, maintain, and collaborate within a development team.

To get started you need to set up a formatter.

## Choose a formatter

You can read this [article](https://blog.frank-mich.com/python-code-formatters-comparison-black-autopep8-and-yapf/) to make your choice!

**Name:** Autopep8<br>
**Website Link:** https://github.com/hhatto/autopep8

**Name:** Black<br>
**Website Link:** https://black.readthedocs.io/en/stable/

**Name:** Yapf<br>
**Website Link:** https://github.com/google/yapf

## Modify the configuration

When your choice is made, you must modify the configuration file *'devcontainer.json'* located in the directory named *'.devcontainer/'*.

You must modify the value of the attribute named *'editor.defaultFormatter'*.

```txt
customizations
└── vscode
    └── settings
        └── settings
            └── editor.defaultFormatter <<<
```

The possible values are :

- **ms-python.autopep8** for *'Autopep8'*
- **ms-python.black-formatter** for *'Black'*
- **eeyore.yapf** for *'Yapf'*

To use **autopep8**, the result should be :

```json
    "editor.defaultFormatter": "ms-python.autopep8",
```

To use **Black**, the result should be :

```json
    "editor.defaultFormatter": "ms-python.black-formatter",
```

To use **Yapf**, the result should be :

```json
    "editor.defaultFormatter": "eeyore.yapf",
```

The Visual Studio Code extension related to the formatter will be installed later.

###### **▶ Next step: [Configure unit tests](./04-configure-unit-tests.md)**

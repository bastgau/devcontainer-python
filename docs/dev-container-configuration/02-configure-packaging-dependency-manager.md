######  **◀️ Previous step: [Duplicate configuration example file](./01-duplicate-configuration-example-file.md)**

# Configure a packaging and dependency manager (mandatory)

> A packaging and dependency manager is a tool that facilitates the installation, management, and distribution of Python packages and their dependencies. It makes it easier to obtain and keep external elements that a Python project requires, ensuring they work well together.

To get started you need to set up a packaging and dependency manager.

## Choose a packaging and dependency manager

You can choose between two packaging and dependency managers.

**Name:** Pip<br>
**Website Link:** https://pip.pypa.io/en/stable/

**Name:** Poetry<br>
**Website Link:** https://python-poetry.org/

## Modify the configuration

When your choice is made, you must modify the configuration file *'devcontainer.json'* located in the directory named *'.devcontainer/'*.

You must modify the value of the attribute named 'python.dependencyManager'.

```txt
customizations
└── vscode
    └── settings
        └── settings
            └── python.dependencyManager <<<
```

The possible values are 'pip' or 'poetry'.

The result should be :

```
    "python.dependencyManager": "pip",
```

... or ...

```
    "python.dependencyManager": "poetry",
```


###### **▶ Next step: [Configure a formater](./03-configure-a-formatter.md)**

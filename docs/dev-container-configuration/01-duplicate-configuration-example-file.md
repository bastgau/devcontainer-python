######  **◀️ Previous step: [Introduction](./00-configure-new-project.md)**

# Duplicate configuration example file

Before you begin, you need to create a *'devcontainer.json'* file and a *'Dockerfile'* file in the directory *'.devcontainer/'*.

If you want to create a python application, you need to copy/paste the following files into the directory: *'.devcontainer/'*.

```
.devcontainer/templates/app-python/devcontainer.json
.devcontainer/templates/app-python/Dockerfile
```

If you want to create an application based on Azure Functions, you must copy/paste the following files into the directory: *'.devcontainer/'*:

```
.devcontainer/templates/azure-function-python/devcontainer.json
.devcontainer/templates/azure-function-python/Dockerfile
```

The new tree should look like :

```
.devcontainer/
├── Dockerfile
├── devcontainer.json
├── install-deps.sh
├── ...
└── install.sh
````



Now we will mainly modify this file.

###### **▶ Next step: [Configure a packaging and dependency manager](./02-configure-packaging-dependency-manager.md)**

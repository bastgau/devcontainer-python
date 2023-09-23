######  **◀️ Previous step: [Configure a packaging and dependency manager](./01-configure-packaging-dependency-manager.md)**

## Configure a formatter (recommanded)

### Choose a formatter

- Autopep8
- Back
- Yapf

### Install extension

Name: Black
VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter

Name: Yapf
VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=eeyore.yapf

### Modify the configuration

/workspaces/app/.devcontainer/devcontainer.json

"editor.defaultFormatter": null

Black "ms-python.black-formatter"
"__editor.defaultFormatter": "ms-python.black-formatter"

Yapf
"_editor.defaultFormatter": "eeyore.yapf"

###### **▶ Next step: [Configure Unit Testing](./03-configure-unit-testing.md)**

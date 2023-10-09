# How install your local development environment?

## Clone the project

**If you have have already cloned the project, skip this step.**

Clone the repository on your local machine.<br>
I recommend to clone the Git repository using the SSH protocol with a SSH key.

1/ Go to the [project home page](../).
2/ Click on the "code" button.
3/ Select "SSH" and copy the url.
4/ Open a terminal and paste this url.

The url should be like :

```
git@github.com:user/repo.git
```

## Information about SSH key

Your local .ssh directory will be available inside the container.<br>
You will be able to use your SSH key with the applications running inside the container.

The directory is mounted in read-only and it is located :

```bash
/home/vscode/.ssh/
```
You can locate your local .ssh directory depending on your host operating system.

| Host operating system | Host directory | Container directory |
| :---  | :--- | :--- |
| macOS | $HOME/.ssh | /home/vscode/.ssh |
| Linux | $HOME/.ssh | /home/vscode/.ssh |
| Windows | %userprofile%/.ssh | /home/vscode/.ssh |


## Build container

Now you are ready to build the container. Some personal information will be asked during the installation processus.

The installation will be completely finished when the following message will be displayed in the terminal **"You can close all terminal windows and reload the project".**

The steps to build the container are :

- Go to the "View" menu in the top bar.
- Select "Command Palette..." (or use the keyboard shortcut Ctrl+Shift+P).
- Type "Dev Containers: Rebuild Container" in the command palette search bar and select this option.

This step may take some time, depending on the complexity of your container and your internet connection speed. 😴

## Reload the project

After building the container, I recommend to reload your project.

- Go to the "View" menu in the top bar.
- Select "Command Palette..." (or use the keyboard shortcut Ctrl+Shift+P).
- Type "Developer: Reload Window" in the command palette search bar and select this option.

This will refresh the Visual Studio Code window with the changes made during the container rebuild.

## Running your application

Now that your container is ready and the project is reloaded, you can run your application.

- Go to the "Run and Debug" view in the lateral bar (or use the keyboard shortcut Ctrl+Shift+D).
- Choose the desired configuration from the list located at the top of the panel.
- Start Debugging.

...

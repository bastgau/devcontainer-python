# How install your local development environment?

## Clone the project

If you have have already cloned the project, skip this step.

Clone the repository on your local machine.

I recommend to clone the Git repository using the SSH protocol with a SSH key

## Configure your personal information

Before continuing, you have to configure your local environment with some personal information.

1. Create a new file named : _user.env_ in the directory : _/.devcontainer_
2. Copy/Paste the file content of _/.devcontainer/user.env-example_ into your file created precedently.
3. Edit the content of the file created precedently with your personnal information.

**Note:** The file created _/.devcontainer/user.env_ will be ignored by Git. This file mustn't be never pushed on the remote repository.

| Environment variable | Description                                       | Example              |
| :------------------- | :------------------------------------------------ | :------------------- |
| GIT_EMAIL            | Email address you associate with your Git commits | john.doe@example.com |
| GIT_USERNAME         | Username you associate with your Git commits      | John Doe             |

Maybe you have to configure some other variables specific to your project.

## Information about SSH key

    Your local .ssh directory will be available inside the container. You will be able to use your SSH key with the applications running inside the container.

The directory is mounted in read-only and it is located :

    /home/vscode/.ssh/

You can locate your local .ssh directory depending on your host operating system.

| Host operating system | Host directory | Container directory |
| :---  | :--- | :--- |
| macOS | $HOME/.ssh | /home/vscode/.ssh |
| Linux | $HOME/.ssh | /home/vscode/.ssh |
| Windows | %userprofile%/.ssh | /home/vscode/.ssh |


## Build container

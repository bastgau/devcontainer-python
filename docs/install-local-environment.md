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

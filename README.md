# Automatic-project-creation

This command line utility can help you automize something routine tasks when you want to create new project and push the initial commit to github.  

For example, if you want to create you project and create git repository then pushed to github, you have to create new folder in your default projects folders, then run ```git init```, then go to github website and so on...

With this utility you just can type in terminal:

```
create-proj -f <project name>
```

And all steps will be done automatically

## Features

- [x] Support MacOS
- [x] Support Linux system
- [ ] Support Windows system (Not support yet...)
- [x] Creating project Folder with tree folders and files
- [x] Creating repository on github.com
- [x] Init repo, add remote repository, push to init commit
- [ ] Creating different trees folders for different projects
- [x] Uninstall option = SUICIDE X)

***If you have any ideas what functionality can be added please leave issue***

## Getting Started

***Now Support only python3 with pip3.***

### Prerequisites

1. First of all you need to install all prerequisites. Follow the commands below:

    ```
    git clone https://github.com/ChesnovAE/Automatic-project-creation.git
    ```

2. This package need a several python dependeces. Install it:

    ```
    pip3 install -r requirements.txt
    ```

**If you have ssh key for github.com, you can pass step 3.**
**If you don't want create ssh key, you can pass step 3 and 4 and use utility without ssh key. Utility supports creating and pushing repository via your UserName and Password**

3. Type in your terminal:

    ```
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/github_id
    ```

4. Copy all content from ```~/.ssh/github_id.pub```

   Go to github.com > Settings > SSH and GPG keys. Click New SSH key and paste copied content.

5. Finally go to terminal and add your private key to ssh-agent

    ```
    eval "$(ssh-agent -s)"
    ```
    - For MacOS
        ```
        ssh-add -K ~/.ssh/github_id
        ```
    - For Linux
        ```
        ssh-add ~/.ssh/github_id
        ```

### Installing

First, make sure that you are in the root directory of the clonning repository and then run in terminal:

- For MacOS:

  ```
  ./install.sh
  ```

- For Linux:

  ```
  sudo ./install.sh
  ```

## Usage

After installation you can use utility in terminal.

1. Just type in terminal:

    - Via ssh (default)

        ```
        create-proj -f <project name>
        ```
    - Via UserName and Password

        ```
        create-proj -p -f <project name>
        ```

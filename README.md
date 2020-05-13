# Automatic-project-creation

This command line util can help you automize something routine tasks when you want to create new project and push the initial commit to github.  

For example, if you want to create you project and create git repository then pushed to github, you have to create new folder in your default projects folders, then run ```git init```, then go to github website and so on...

With this util you just can type in terminal:

```
create <project name>
```

And all steps will be done automatically

## Features

- [x] Support MacOS
- [x] Support Linux system
- [ ] Support Windows system (Not support yet)
- [x] Creating project Folder in default projects folder
- [x] Creating folders: **src**, **docs**
- [x] Creating files: **.gitignore**, **requirements.txt**, template **README** file, **src/__init__.py**
- [x] Creating remote github repository
- [x] Init repo, remote add and push to remote init commit
- [ ] Changing default projects directory
- [ ] Creating different trees folders for different projects
- [ ] Uninstall option = SUICIDE X)

***If you have any ideas what functionality can be added please leave issue***

## Getting Started

Support only python3 with pip3.

### Prerequisites

1. First of all you need to install all prerequisites. Follow the commands below:

    ```
    git clone https://github.com/ChesnovAE/Automatic-project-creation.git
    ```

2. This package need a several python dependeces. Install it:

    ```
    pip install -r requirements.txt
    ```

    or

    ```
    pip3 install -r requirements.txt
    ```

3. If you have ssh key for github.com you can pass step 3 and 4. If you don't have ssh key type in your terminal:

    ```
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/github_id
    ```

4. Copy all content from ~/.ssh/github.pub.

   Go to github.com > Settings > SSH and GPG keys. Click New SSH key and paste copied content.

5. Finalle go to terminal and add your private key to ssh-agent

    ```
    eval "$(ssh-agent -s)"
    ```

    ```
    ssh-add ~/.ssh/github_id
    ```

### Installing

First, make sure that you are in the root directory of the repository. Then run in terminal:

1. Just run the install.sh script and follow instructions

    ```
    ./install.sh
    ```

## Usage
After installation you can use util in terminal.
1. Just type in terminal:

    ```
    create <project name>
    ```

2. Enter your github password.
3. Congratulations!!! The repository was created

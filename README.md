# Automatic-project-creation

This command line util can help you automize something routine tasks when you want to create new project.  

For example, if you want to create you project and create git repository then pushed to github, you have to create new folder in your default projects folders, then run ```git init```, then go to github website and so on...

With this util you just can type in terminal:
```
create <project name>
```
And all steps will be done automatically

## Features

- [x] Creating project Folder in default projects folder
- [x] Creating folders: **src**, **docs**
- [x] Creating files: **.gitignore**, **requirements.txt**, template **README** file, **src/__init__.py**
- [x] Creating remote github repository
- [x] Init repo, remote add and push to remote init commit
- [ ] Changing default projects directory
- [ ] Creating different trees folders for different projects

## Getting Started

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

### Installing
First, make sure that you are in the root directory of the repository. Then run in terminal:
1. Run
    ```
    cmod u+x install.sh
    ```

2. Then just run the install.sh script and follow instructions

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

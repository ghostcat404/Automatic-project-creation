#!/bin/bash
function insert_some_code () {

    echo "Please enter your github.com username"
    read -p "Username: " uservar
    # Read directory path
    echo "Please enter your FULL PATH for default projects directory"
    # Check that directory exist
    while true;
    do
        read -p "Default projects directory path: " directory_path
        if [[ -d $directory_path ]];
        then
            break;
        else
            echo "$directory_path does not exist"
            echo "Please enter default projects directory path again"
        fi
    done
    cd bin/
    touch .conf
    echo "{\"user_name\":\"$uservar\", \"project_path\":\"$directory_path\"}" >> .conf
    cd ../
}

# Define installer folder
default_folder=$(pwd)
# Detect system
system_name=$(uname)

# Define the util path depending on the system
case "$system_name" in
    "Darwin" ) util_path="/usr/local/Cellar/create";;
    "Linux" ) util_path="/usr/local/";;
    * ) exit 1;;
esac

# Insert some strings in code
insert_some_code

# Copy all files to the desired folder
if [[ ! -d "$util_path" ]];
then
    mkdir $util_path
fi
cp -r ./bin $util_path

rm bin/.conf

# Go to folder with python script
cd "$util_path/bin"

chmod 400 .conf
# Compile the python file
pyinstaller create_project.py

# Add symbolic link to util
ln -s "$util_path/bin/.create_command.sh" "/usr/local/bin/create"

# Remove installation folder or not?
while true; do
    read -p "Do you wish to remove installation folder? [y/n]: " yn
    case $yn in
        [Yy]* ) rm -rf $default_folder; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
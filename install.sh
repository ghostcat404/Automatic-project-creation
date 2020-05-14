#!/bin/bash
set_git_user_info() {
    echo "Please enter your info for setting .gitconfig file"
    read -p "User name: " uservar
    read -p "User email: " useremail
    git config --global user.name "$uservar"
    git config --global user.email "$useremail"
}
configure_git_config() {
    if [[ -f "$HOME/.gitconfig" ]];
    then
        if [[ -z $(git config --get user.name) ]];
        then
            set_git_user_info
        fi
    else
        set_git_user_info
    fi
    # Read directory path
    echo "Please enter your FULL PATH for default projects directory"
    # Check that directory exist
    while true;
    do
        read -p "Default projects directory path: " directory_path
        if [[ -d $directory_path ]];
        then
            git config --global path.default "$directory_path";
            break
        else
            echo "$directory_path does not exist"
            echo "Please enter default projects directory path again"
        fi
    done
}

# Define installer folder
default_folder=$(pwd)
# Detect system
system_name=$(uname)

# Define the util path depending on the system
case "$system_name" in
    "Darwin" ) util_path="/usr/local/Cellar/create";;
    "Linux" ) util_path="/opt/create";;
    * ) exit 1;;
esac

# Configure git config
configure_git_config

# Copy all files to the desired folder
if [[ ! -d "$util_path" ]];
then
    mkdir $util_path
else
    echo ""
    echo "Directory $util_path already exist"
    while true; do
        read -p "Do you wish to REINSTALL util? All old files will be removed. [y/n]: " yn
        case $yn in
            [Yy]* | "yes" ) 
                rm -rf $util_path
                rm -rf "/usr/local/bin/create"
                break
                ;;
            [Nn]* | "no" )
                exit
                ;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    echo ""
    mkdir $util_path
fi
cp -r ./bin $util_path
cp -r ./src $util_path

# rm bin/.conf

# Go to folder with python script
cd "$util_path/bin"

# chmod 644 .conf

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
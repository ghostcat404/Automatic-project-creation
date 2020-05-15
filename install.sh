#!/bin/bash
set_git_user_info() {
    git config --global user.name "$uservar"
    git config --global user.email "$useremail"
}
configure_git() {
    read -p "User name for https://github.com: " uservar
    if [[ -z $(git config --get user.email) ]];
    then
        read -p "User email for https://github.com: " useremail
    fi
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
        # TODO: сделать так, чтобы можно было несколько раз делать ../../../
        read -p "Default projects directory path: " directory_path
        if [[ ${directory_path:0:2} == "~/" ]];
        then
            directory_path="$HOME/${directory_path:2}"
        elif [[ ${directory_path:0:1} == "." ]]
        then
            directory_path="$(pwd)"
        elif [[ ${directory_path:0:2} == "./" ]]
        then
            directory_path="$(pwd)"
        elif [[ ${directory_path:0:3} == "../" ]]
        then
            directory_path="$(pwd)${directory_path:2}"
        fi
        if [[ -d $directory_path ]];
        then
            break
        else
            echo "$directory_path does not exist"
            echo "Please enter default projects directory path again"
        fi
    done
    mkdir profile
    touch profile/config
    chmod 600 profile/config
    echo "GITUSERNAME=$uservar" >> profile/config
    echo "DEFAULTPROJECTPATH=$directory_path" >> profile/config
}

# Define installer folder
default_folder=$(pwd)
# Detect system
system_name=$(uname)
# Define user data
uservar=""
useremail=""

# Define the util path depending on the system
case "$system_name" in
    "Darwin" ) util_path="/usr/local/Cellar/create-proj";;
    "Linux" ) util_path="/opt/create-proj";;
    * ) exit 1;;
esac

# Configure git config
configure_git

# Copy all files to the desired folder
if [[ ! -d "$util_path" ]];
then
    mkdir $util_path
else
    echo ""
    echo "Directory $util_path already exist"
    while true;
    do
        read -p "Do you wish to REINSTALL util? [y/n]: " yn
        case $yn in
            [Yy]* | "yes" ) 
                rm -rf $util_path
                rm -rf "/usr/local/bin/create-proj"
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
cp -r ./profile $util_path
rm -rf ./profile
mv $util_path/bin/.create_command.sh $util_path

# Add symbolic link to util
ln -s "$util_path/.create_command.sh" "/usr/local/bin/create-proj"

# Remove installation folder or not?
while true; do
    read -p "Do you wish to remove installation folder? [y/n]: " yn
    case $yn in
        [Yy]* ) rm -rf $default_folder; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
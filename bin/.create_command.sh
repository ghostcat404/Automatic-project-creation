#!/bin/bash

##################################### IMPORTS ######################################
# . /usr/local/Cellar/create-proj/profile/.config
#################################### FUNCTIONS  ####################################

usage_options() {
    echo "USAGE: create-proj [options [arg]] ..."
    echo ""
    echo "OPTIONS:"
    echo ""
    echo "    -f, --file-name (required option)        Project folder name"
    echo "    -p, --use-password                       Use password or ssh-key to push \"Initial commit\" to github"
    echo "    --path                                   Create project in an another folder (Different from the default)"
    echo "    -h, --help                               Getting help for usage"
    echo ""
}

usage_examples() {
    echo "EXAMPLES:"
    echo ""
    echo "    By default using creating repository via ssh-key"
    echo "    (see README.md in https://github.com/ChesnovAE/Automatic-project-creation/blob/master/README.md)"
    echo "    Just type:"
    echo ""
    echo "        create-proj -f <project name>"
    echo ""
    echo "    For example, if you work not on your main computer, you can"
    echo "    create project using github UserName and Password:"
    echo ""
    echo "        create-proj -f <project name> -p"
    echo ""
    echo "    Creating project in another folder that different from the"
    echo "    default folder that was determined during installation"
    echo ""
    echo "        create-proj -f <project name> --path </full/path/to/folder>"
}

suicide() {
    echo "It is a pity that you decided to take this step..."
    echo ""
    echo "But, it's only your choice"
    echo "It was a pleasure working with you"
    echo "--------GOODBYE MOTH** ****ER--------"
    cd ../
    rm -rf create-proj
    rm -rf /usr/local/bin/create-proj
    cd ~/
}
#################################### END FUNCTIONS  #################################

#################################### START MAIN  ####################################

############################ Parse CLI args ############################
if [[ "$1" == "" ]];
then
    echo "Error! arguments required"
    usage
    exit 1
fi
# TODO: ADD checking arguments combination!
PROJECT_PATH=""
PROJECT_NAME=""
use_ssh_key=1
while [ "$1" != "" ]; do
    case "$1" in
        -p | --use-password )
            use_ssh_key=0
            ;;
        -f | --file-name )
            if [[ "$2" != "" ]];
            then
                PROJECT_NAME=$2
                shift
            else
                echo "Require name of your project!!!"
                echo "Use create -h to see examples"
                exit 1
    	    fi	
            ;;
        --path )
            if [[ "$2" != "" ]];
            then
                PROJECT_PATH=$2
                shift
            else
                echo "Require path to folder!!!"
                echo "Use create -h to see examples"
                exit 1
            fi
            ;;
        -h | --help )
            usage_options
            usage_examples
            exit
            ;;
        --suicide )
            echo "Are you seriously???"
            while true;
            do
                read -p "Do you want to KILL ME?! [y/n]: " yn
                case $yn in
                    [Yy]* | "yes" ) 
                        echo "Oh my GOD..."
                        echo ""
                        suicide
                        exit
                        ;;
                    [Nn]* | "no" )
                        echo "Ugh you scared me"
                        exit
                        ;;
                    * ) echo "Please answer yes or no.";;
                esac
            done
            ;;
        * )
	    echo "invalid option!!!"
            usage_options
            exit 1
    esac
    shift
done
if [[ -z $PROJECT_NAME ]];
then
    echo "-f <project name> is necessary option"
    echo "Use create -h to see examples"
    exit 1
fi
########################################################################

########################### Define variables ###########################
# Directory where source stored
dir=$(dirname $(readlink /usr/local/bin/create-proj))
declare $(env -i $(cat $dir/profile/config))

USER_NAME=$GITUSERNAME
if [[ -z $PROJECT_PATH ]];
then
    DEFAULT_PROJECT_PATH=$DEFAULTPROJECTPATH
else
    DEFAULT_PROJECT_PATH=$PROJECT_PATH
fi
if [[ "${DEFAULT_PROJECT_PATH: -1}" == '/' ]];
then
    path=$DEFAULT_PROJECT_PATH$PROJECT_NAME
else
    path="$DEFAULT_PROJECT_PATH/$PROJECT_NAME"
fi
if [[ -d "$path" ]];
then
    echo "Error: $path already exist"
    exit 1
fi
#########################################################################

######################## Create required folders ########################
mkdir "$path"
cd $path
touch "requirements.txt"
cp "$dir/src/README-Template.md" README.md
# Insert project name with vim
ex -s -c "1i|# $PROJECT_NAME" -c x README.md
touch ".gitignore"
mkdir "src/"
mkdir "docs/"
touch "src/__init__.py"
#########################################################################

######################## Create remote git repository ###################
echo "Please enter your github.com password"
read -sp "Password: " passvar
echo ""
python3 $dir/bin/create_project.py $USER_NAME $passvar $PROJECT_NAME
git init
if [[ use_ssh_key -eq 0 ]];
then
    git remote add origin https://github.com/$USER_NAME/$PROJECT_NAME.git
else
    git remote add origin git@github.com:$USER_NAME/$PROJECT_NAME.git
fi
git add .
git commit -m "Initial commit"
git push -u origin master
#########################################################################

##################### Run VS Code editor if available ###################
if [[ -f "/usr/local/bin/code" ]];
then
    code .
fi
if [[ -f "/usr/bin/code" ]];
then
    code .
fi
#########################################################################

#################################### END MAIN  ####################################

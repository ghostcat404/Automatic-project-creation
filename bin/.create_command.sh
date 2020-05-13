#!/bin/bash

#################################### FUNCTIONS  ####################################

usage() {
    echo "USAGE: create [options [arg]] ..."
    echo ""
    echo "OPTIONS:"
    echo ""
    echo "    -f, --file-name (required option)        Project folder name"
    echo "    -p, --use-password                       Use password or ssh-key to push \"Initial commit\" to github"
    echo "    --path                                   Create project in an another folder (Different from the default)"
    echo "    -h, --help                               Getting help for usage"
    echo ""
    echo "EXAMPLES:"
    echo ""
    echo "    By default using creating repository via ssh-key"
    echo "    (see README.md in https://github.com/ChesnovAE/Automatic-project-creation/blob/master/README.md)"
    echo "    Just type:"
    echo ""
    echo "        create -f <project name>"
    echo ""
    echo "    For example, if you work not on your main computer, you can"
    echo "    create project using github UserName and Password:"
    echo ""
    echo "        create -f <project name> -p"
    echo ""
    echo "    Creating project in another folder that different from the"
    echo "    default folder that was determined during installation"
    echo ""
    echo "        create -f <project name> --path </full/path/to/folder>"
}

######################### Function for json parsing ####################
parse_json() {
    echo $1 | \
    sed -e 's/[{}]/''/g' | \
    sed -e 's/", "/'\",\"'/g' | \
    sed -e 's/" ,"/'\",\"'/g' | \
    sed -e 's/" , "/'\",\"'/g' | \
    sed -e 's/","/'\"---SEPERATOR---\"'/g' | \
    awk -F=':' -v RS='---SEPERATOR---' "\$1~/\"$2\"/ {print}" | \
    sed -e "s/\"$2\"://" | \
    tr -d "\n\t" | \
    sed -e 's/\\"/"/g' | \
    sed -e 's/\\\\/\\/g' | \
    sed -e 's/^[ \t]*//g' | \
    sed -e 's/^"//'  -e 's/"$//'
}
########################################################################

#################################### END FUNCTIONS  #################################

#################################### START MAIN  ####################################

############################ Parse CLI args ############################
if [[ "$1" == "" ]];
then
    echo "Error! arguments required"
    usage
    exit 1
fi
PROJECT_PATH=""
use_ssh_key=1
while [ "$1" != "" ]; do
    case "$1" in
        -p | --use-password )
            use_ssh_key=0
            ;;
        -f | --file-name )
            PROJECT_NAME=$2
            shift
            ;;
        --path )
            PROJECT_PATH=$2
            shift
            ;;
        -h | --help )
            usage
            exit
            ;;
        * )
            usage
            exit 1
    esac
    shift
done
########################################################################

########################### Define variables ###########################
# Directory where source stored
dir=$(dirname $(readlink /usr/local/bin/create))
# Json config with user_name and default_project_path
conf=$(cat $dir/.conf)
USER_NAME=$(parse_json "$conf" user_name)
if [[ -z $PROJECT_PATH ]];
then
    DEFAULT_PROJECT_PATH=$(parse_json "$conf" project_path)
else
    DEFAULT_PROJECT_PATH=$PROJECT_PATH
fi
if [[ "${DEFAULT_PROJECT_PATH: -1}" == '/' ]];
then
    path=$DEFAULT_PROJECT_PATH$PROJECT_NAME
else
    path="$DEFAULT_PROJECT_PATH/$PROJECT_NAME"
fi
#########################################################################

######################## Create required folders ########################
mkdir "$path"
cd $path
touch "requirements.txt"
cp "$dir/README-Template.md" README.md
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
python3 $dir/create_project.py $USER_NAME $passvar $PROJECT_NAME
git init
if [[ use_ssh_key -eq 0 ]];
then
    git remote add origin git@github.com:$USER_NAME/$PROJECT_NAME.git
else
    git remote add origin https://github.com/$USER_NAME/$PROJECT_NAME.git
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
#########################################################################

#################################### END MAIN  ####################################
#!/bin/bash
# TODO: add the change directory ability
# TODO: add uninstall option
# $1 - name of new project
function parse_json()
{
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
########################### Define variables ###########################
dir=$(dirname $(readlink /usr/local/bin/create))
conf=$(cat $dir/.conf)
U_NAME=$(parse_json "$conf" user_name)
PROJECTPATH=$(parse_json "$conf" project_path)
# Check path
if [[ "${PROJECTPATH: -1}" == '/' ]];
then
    path=$PROJECTPATH$1
else
    path="$PROJECTPATH/$1"
fi
#########################################################################

######################## Create required folders ########################
mkdir "$path"
cd $path
touch "requirements.txt"
# Get template for README.md
cp "$dir/README-Template.md" README.md
# Insert project name with vim
ex -s -c "1i|# $1" -c x README.md
touch ".gitignore"
mkdir "src/"
mkdir "docs/"
touch "src/__init__.py"
#########################################################################

######################## Create remote git repository ###################
echo "Please enter your github.com password"
read -sp "Password: " passvar
echo ""
$dir/dist/create_project/./create_project $U_NAME $passvar $1
git init
git remote add origin git@github.com:$U_NAME/$1.git
git add .
git commit -m "Initial commit"
git push -u origin master
##########################################################################
#!/bin/bash
system_name=$(uname)
case "$system_name" in
    "Darwin" ) 
        rm -rf /usr/local/bin/create/
        rm -rf /usr/local/Cellar/create/
        ;;
    "Linux" ) echo "Not supported";;
    * ) exit 1;;
esac


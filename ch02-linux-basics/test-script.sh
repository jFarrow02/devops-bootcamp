#!/bin/bash

file_name=config.yaml

config_dir=$1

echo "using file $file_name to configure something"

if [ -d "config" ]
then
    echo "reading config dir contents"
    config_files=$(ls "$config_dir")
else
    echo "config dir not found. Creating..."
    mkdir "$config_dir"
    touch "$config_dir/config.sh"
fi

user_group=$2

if [ "$user_group" == "jamesbond" ]
then
    echo "configure the server"
elif [ "$user_group" == "admin" ]
then
    echo "administer the server"
else
    echo "No permission to configure server; wrong user group"
fi
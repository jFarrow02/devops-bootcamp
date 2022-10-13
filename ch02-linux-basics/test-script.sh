#!/bin/bash

file_name=config.yaml

echo "using file $file_name to configure something"

if [ -d "config" ]
then
    echo "reading config dir contents"
    config_files=$(ls config)
else
    echo "config dir not found. Creating..."
    mkdir config
fi

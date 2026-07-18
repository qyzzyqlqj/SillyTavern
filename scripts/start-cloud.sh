#!/bin/bash
set -e

cd /workspaces/SillyTavern

if [ ! -d "data/.git" ]; then
    echo "Cloning profile repository..."

    rm -rf data

    git clone \
    https://${GITHUB_TOKEN}@github.com/qyzzyqlqj/sillytavern_profiles.git \
    data

else
    echo "Updating profile repository..."

    cd data
    git pull
    cd ..
fi


echo "Starting SillyTavern..."

npm start
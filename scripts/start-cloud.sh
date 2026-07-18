#!/bin/bash
set -e

cd /workspaces/SillyTavern

# 同步个人数据仓库
if [ ! -d "data/.git" ]; then
    echo "Cloning profile repository..."

    rm -rf data

    git clone https://${PROFILE_TOKEN}@github.com/qyzzyqlqj/sillytavern_profiles.git data
else
    echo "Updating profile repository..."

    cd data
    git pull
    cd ..
fi


# 如果已经运行，避免重复启动
if pgrep -f "node server.js" > /dev/null; then
    echo "SillyTavern already running"
    exit 0
fi


echo "Starting SillyTavern..."

nohup node server.js \
    --listen 0.0.0.0 \
    > /tmp/sillytavern.log 2>&1 &


echo "SillyTavern started"
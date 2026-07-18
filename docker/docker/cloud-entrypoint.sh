#!/bin/sh
set -e


APP_HOME="/home/node/app"
DATA_DIR="$APP_HOME/data"


echo "=== Cloud Tavern Boot ==="


# 1. 恢复数据仓库
if [ -n "$DATA_REPO" ]; then

    if [ ! -d "$DATA_DIR/.git" ]; then
        echo "Cloning data repository..."

        rm -rf "$DATA_DIR"

        git clone \
        "https://${GITHUB_TOKEN}@github.com/${DATA_REPO}.git" \
        "$DATA_DIR"

    else
        echo "Updating data repository..."

        cd "$DATA_DIR"
        git pull
        cd "$APP_HOME"

    fi

fi



# 2. 后台自动备份

backup_loop(){

while true
do
    sleep 300

    cd "$DATA_DIR"

    git add .

    if ! git diff --cached --quiet
    then
        echo "Backup changes..."

        git commit \
        -m "auto backup $(date)"

        git push

    fi

done

}


if [ -n "$DATA_REPO" ]; then
    backup_loop &
fi



# 3. 交给官方入口

exec ./docker-entrypoint.sh "$@"

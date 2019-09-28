#!/bin/bash
set -e
set -x

# determine the current directory source:
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

# determine the current git hash
git_short_hash=`git rev-parse --short HEAD`
image_tag="ubuntu/donkey-docker:$git_short_hash"

# check if the image has been build previously
if [ -z $(docker images -q $image_tag) ]; then
    # image has not been build, building it
    echo "[torcs - docker build] docker image $image_tag not found."
    docker build -t $image_tag .
fi

# start the docker container
docker run \
    --rm \
    --user=`id -u`":"`id -g` \
    -ti \
    --network="host" \
    --runtime=nvidia \
    -p 8887:8887 \
    -p 9090:9090 \
    -v /dev/shm:/dev/shm \
    -v $DIR/mycar:/home/user/mycar \
    -v $DIR/login.sh:/home/user/login.sh:ro \
    $image_tag \
    /home/user/login.sh
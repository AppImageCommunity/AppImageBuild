#! /bin/bash

if [[ "$ARCH" == "" ]] || [[ "$DIST" == "" ]]; then
    echo "Usage: env ARCH=... DIST=... bash $0 [--pull] [--push]"
    exit 2
fi

set -e
set -x

log() { echo "$(tput setaf 2)$(tput bold)$*$(tput sgr0)" ; }

dockerfile="Dockerfile.$DIST-$ARCH"
image_name="quay.io/appimage/appimagebuild:$DIST-$ARCH"

pull=
push=

while [ "$1" != "" ]; do
    case "$1" in
        "--pull")
            pull=1
            ;;
        "--push")
            push=1
            ;;
    esac

    shift
done

if [ "$pull" != "" ]; then
     docker pull "$image_name"
fi

docker build --pull --cache-from "$image_name" -t '$image_name' -f '$dockerfile' .

if [ "$push" != "" ]; then
    log "pushing to quay.io"
    echo

    bash -xc "docker push '$image_name'"
fi

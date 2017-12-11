#! /bin/bash

# export BRANCH and/or COMMIT to modify the build process

log() { echo $(tput setaf 2)$(tput bold)"$*"$(tput sgr0) ; }

ARCH=${ARCH:-x86_64}

dockerfile="Dockerfile"
image_name="quay.io/appimage/appimagebuild"

case "$ARCH" in
    x86_64)
        ;;
    i386)
        image_name="$image_name-i386"
        dockerfile="$dockerfile.i386"
        ;;
    *)
        echo "Unknown architecture: $ARCH"
        ;;
esac

docker build -t "$image_name" -f "$dockerfile" .

if [ "$1" == "--push" ]; then
    log "Pushing to quay.io"
    echo

    docker push "$image_name"
fi

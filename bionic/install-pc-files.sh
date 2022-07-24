#! /bin/bash

set -exo pipefail


case "$ARCH" in
    x86_64|i386|aarch64)
        triplet="$ARCH"-linux-gnu
        ;;
    armhf)
        triplet=arm-linux-gnueabihf
        ;;
    *)
        echo "Error: unknown architecture: $ARCH"
        exit 2
        ;;
esac

for i in /bionic/*.pc; do
    sed "s|__triplet__|$triplet|g" < "$i" > /usr/lib/"$triplet"/pkgconfig/"$(basename "$i")"
done

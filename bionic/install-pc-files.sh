#! /bin/bash

set -exo pipefail

[[ "$ARCH" == "" ]] && exit 1

for i in /bionic/*.pc; do
    sed "s|__ARCH__|$ARCH|g" < "$i" > /usr/lib/"$ARCH"-linux-gnu/pkgconfig/"$(basename "$i")"
done

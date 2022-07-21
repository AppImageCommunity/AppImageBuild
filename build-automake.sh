#! /bin/bash

set -xe

wget https://ftp.gnu.org/gnu/automake/automake-"$AUTOMAKE_VERSION".tar.xz -O - | tar xJ

cd automake-"$AUTOMAKE_VERSION"

EXTRA_CONFIGURE_FLAGS=
if [ "$ARCH" == "i386" ]; then
    EXTRA_CONFIGURE_FLAGS=" --build=i686-linux-gnu --host=i686-linux-gnu --target=i686-linux-gnu"
elif [ "$ARCH" == "armhf" ] || [ "$ARCH" == "aarch64" ]; then
    EXTRA_CONFIGURE_FLAGS=" --host=$DEBARCH --target=$DEBARCH"

    # https://askubuntu.com/a/338670
    export PATH=/deps/bin:"$PATH"
fi

[ -f autogen.sh ] && ./autogen.sh

./configure --prefix=/deps $EXTRA_CONFIGURE_FLAGS

set +x
echo "+ make -j$(nproc)" 1>&2

if [ -z $VERBOSE ]; then
    make -j$(nproc) 2>&1 | while read line; do
        echo -n .
    done
    echo
else
    make -j$(nproc)
fi
set -x

make install

cd ../../
rm -rf automake-"$AUTOMAKE_VERSION"/

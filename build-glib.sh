#! /bin/bash

set -xe

wget https://ftp.fau.de/gnome/sources/glib/$(echo "$GLIB_VERSION" | cut -d. -f1-2)/glib-$GLIB_VERSION.tar.xz -O- | tar xJ

cd glib-$GLIB_VERSION

# required to make the compiler happy
export CFLAGS="$CFLAGS -Wno-error"

EXTRA_CONFIGURE_FLAGS=
if [ "$ARCH" == "i386" ]; then
    EXTRA_CONFIGURE_FLAGS=" --build=i686-linux-gnu --host=i686-linux-gnu --target=i686-linux-gnu"
elif [ "$ARCH" == "armhf" ] || [ "$ARCH" == "aarch64" ]; then
    EXTRA_CONFIGURE_FLAGS=" --host=$DEBARCH --target=$DEBARCH"

    # https://askubuntu.com/a/338670
    export PATH=/deps/bin:"$PATH"
fi

[ -f autogen.sh ] && ./autogen.sh

./configure --prefix=/deps --disable-selinux $EXTRA_CONFIGURE_FLAGS

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
rm -rf glib-$GLIB_VERSION/

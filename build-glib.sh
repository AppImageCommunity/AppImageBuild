#! /bin/bash

set -xe

wget https://ftp.fau.de/gnome/sources/glib/$(echo "$GLIB_VERSION" | cut -d. -f1-2)/glib-$GLIB_VERSION.tar.xz -O- | tar xJ

cd glib-$GLIB_VERSION

# required to make the compiler happy

# https://unix.stackexchange.com/a/353761
export CFLAGS="$CFLAGS -Wno-error -D_GNU_SOURCE -DF_SETPIPE_SZ=1024+7 -DF_GETPIPE_SZ=1024+8"

EXTRA_CONFIGURE_FLAGS=
if [ "$ARCH" == "i386" ]; then
    EXTRA_CONFIGURE_FLAGS=" --build=i686-linux-gnu --host=i686-linux-gnu --target=i686-linux-gnu"
elif [ "$ARCH" == "armhf" ] || [ "$ARCH" == "aarch64" ]; then
    EXTRA_CONFIGURE_FLAGS=" --host=$DEBARCH --target=$DEBARCH"

    # https://askubuntu.com/a/338670
    export PATH=/deps/bin:"$PATH"
fi

#[ -f autogen.sh ] && ./autogen.sh

export PCRE_CFLAGS="-I/deps/include"
export PCRE_LIBS="-L/deps/lib -lpcre"
export LD_LIBRARY_PATH="/deps/lib:$LD_LIBRARY_PATH"
./configure --verbose --prefix=/deps --disable-selinux --disable-libmount --enable-libmount=no $EXTRA_CONFIGURE_FLAGS || cat config.log

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

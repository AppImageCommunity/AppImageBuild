FROM centos:6.9

RUN yum install -y gcc gcc-c++ wget make gnupg zip git subversion glib2-devel automake libtool patch zlib-devel cairo-devel openssl-devel libstdc++

# inherited by build scripts
ARG VERBOSE=0

ARG GCC_VERSION=5.3.0
COPY build-gcc.sh /
RUN bash -x /build-gcc.sh

RUN bash -xc "yum install -y curl-devel"

ARG CMAKE_VERSION=3.10.0
COPY build-cmake.sh /
RUN bash -x /build-cmake.sh

ARG AUTOCONF_VERSION=2.69
COPY build-autoconf.sh /
RUN bash -x /build-autoconf.sh

ARG AUTOMAKE_VERSION=1.15
COPY build-automake.sh /
RUN bash -x /build-automake.sh

RUN bash -xc "yum install -y fuse-devel vim-common zlib-devel desktop-file-utils fuse fuse-libs gtest-devel && \
    wget https://github.com/kikitux/blog/raw/master/zsync/zsync-0.6.2-1.el6.rf.x86_64.rpm && \
    echo '08ebc834c300c885e71d4b1feadf5520  zsync-0.6.2-1.el6.rf.x86_64.rpm' | md5sum -c && \
    rpm -Uvh zsync-0.6.2-1.el6.rf.x86_64.rpm && \
    rm zsync-0.6.2-1.el6.rf.x86_64.rpm"

# desktop-integration dependencies
RUN bash -xc "yum install -y libXft-devel librsvg2-devel curl"

RUN bash -xc "yum install -y ncurses-devel texinfo"
ARG GDB_VERSION=7.10
COPY build-gdb.sh /
RUN bash -x /build-gdb.sh

# deps for glib
RUN bash -xc "yum install -y xz libffi-devel gettext-devel"

# pcre >= 8.13 required by glib 2.56
ARG PCRE_VERSION=8.43
COPY build-pcre.sh /
RUN bash -x /build-pcre.sh

# set up PKG_CONFIG_PATH to ensure that deps in /deps have precedence
# also, pcre is a dep of glib
ENV PKG_CONFIG_PATH=/deps/lib/pkgconfig:/deps/share/pkgconfig

RUN yum install -y centos-release-scl && \
    yum install -y python27
ARG GLIB_VERSION=2.56.0
COPY build-glib.sh /
RUN source /opt/rh/python27/enable && \
    bash -x /build-glib.sh

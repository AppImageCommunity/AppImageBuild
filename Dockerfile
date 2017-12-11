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

RUN bash -xc "yum install -y fuse-devel"

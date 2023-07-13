#! /bin/bash

set -eo pipefail

source /opt/rh/devtoolset-10/enable

export PATH=/deps/bin/:"$PATH"
export PKG_CONFIG_PATH=/deps/lib/pkgconfig:"$PKG_CONFIG_PATH"

exec "$@"

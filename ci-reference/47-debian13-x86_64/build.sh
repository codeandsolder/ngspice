#!/bin/bash
# Build the independent ngspice reference for the managed Debian 13 ABI.
set -euo pipefail
[[ $# == 2 ]] || { echo "Usage: $0 BUILD_IMAGE NEW_BUILD_DIRECTORY" >&2; exit 64; }
image=$1
recipe=$(cd -- "$(dirname -- "$0")" && pwd)
root=$(realpath -m -- "$2")
[[ ! -e "$root" && -d "$(dirname "$root")" ]]
[[ "$(docker image inspect "$image" --format '{{.Id}}')" == sha256:e970b90a372a510ad54458649de15180c8c94bbbd9bb7690d3501c0efd968101 ]]
mkdir -- "$root"
cd "$root"
archive=ngspice-47-source.tar.gz
curl -fsSL --retry 3 https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/47/ngspice-47.tar.gz -o "$archive"
printf '%s  %s\n' 0eec72a8450f6b654ea13ac62ea74c09a1f74093c8b3b88d098100bd0193df24f07ffe723dfe174dd576f6488f95484b2898934a20dee0865c3491b560dc6583 "$archive" | sha512sum -c -
tar -xzf "$archive"
cd ngspice-47
patch -p1 < "$recipe/cmpp-scanner-restart.patch"
sccache-runtime --image "$image" --host-toolchain -- ./configure --prefix=/opt/ngspice-47 --without-x --with-readline=no --enable-xspice --enable-cider --enable-openmp --disable-debug 'CC=/usr/local/libexec/sccache-client gcc' 'CXX=/usr/local/libexec/sccache-client g++'
sccache-runtime --image "$image" --host-toolchain -- make -j16
sccache-runtime --image "$image" --host-toolchain -- make install "DESTDIR=$root/install-root"
stage="$root/install-root/opt/ngspice-47"
cp COPYING "$stage/COPYING"
cd "$root"
tar --sort=name --mtime='2026-11-28 00:00:00Z' --owner=0 --group=0 --numeric-owner -C "$stage" -cf - . | gzip -n -9 > ngspice-47-debian13-x86_64.tar.gz
sha256sum ngspice-47-debian13-x86_64.tar.gz "$archive"

#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  autoconf automake libtool libtool-bin bison flex texinfo \
  pkg-config make gcc libreadline-dev libncurses-dev \
  libx11-dev libxext-dev libxmu-dev libxaw7-dev
command -v gcc

source_root="$PWD"
build_root="$(mktemp -d "$RUNNER_TEMP/ngspice-xspice-XXXXXXXX")"
trap 'rm -rf -- "$build_root"' EXIT

if ! ./autogen.sh >"$build_root/autogen.log" 2>&1; then
  tail -100 "$build_root/autogen.log"
  exit 1
fi
cd "$build_root"

if ! CC=gcc CFLAGS="-O2 -g" \
  "$source_root/configure" --prefix="$build_root/install" \
  --enable-xspice --enable-cider --with-readline=yes \
  --disable-debug >configure.log 2>&1; then
  tail -120 configure.log
  exit 1
fi
if ! make -j2 >build.log 2>&1; then
  tail -160 build.log
  exit 1
fi
if ! make -C tests/xspice/digital -j2 check >xspice-test.log 2>&1; then
  tail -150 xspice-test.log
  exit 1
fi

./src/ngspice --version
tail -25 xspice-test.log

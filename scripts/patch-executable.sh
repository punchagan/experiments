#!/usr/bin/env sh

set -exu

cd "$(dirname "$0")/.." || exit 1

dune clean
dune build
ldd _build/default/bin/main.exe

mkdir -p _build/default/lib
patchelf --set-rpath '$ORIGIN/../lib' _build/default/bin/main.exe

# Copy the required libraries to the lib directory
cp /usr/lib/libgmp.so.10 _build/default/lib/
cp /lib/libc.musl-x86_64.so.1 _build/default/lib/

# Copy the musl dynamic linker to the lib directory
cp /lib/ld-musl-x86_64.so.1 _build/default/lib/

# NOTE: Need to investigate if set-interpreter path can be relative to the
# executable. It seems like it can't be. We currently use path relative to the
# current directory...
patchelf --set-interpreter _build/default/lib/ld-musl-x86_64.so.1 _build/default/bin/main.exe

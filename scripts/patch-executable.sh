#!/usr/bin/env sh

set -exu

cd "$(dirname "$0")/.." || exit 1

dune clean
dune build
ldd _build/default/bin/main.exe

mkdir -p _build/default/lib
patchelf --set-rpath '$ORIGIN/../lib' _build/default/bin/main.exe

# Copy the required libraries to the lib directory
LIBRARIES=$(ldd _build/default/bin/main.exe  | sed -n 's/.* => \([^ ]*\/[^ ]*\).*/\1/p' | grep '^/')

for lib in $LIBRARIES; do
    cp "$lib" _build/default/lib/
    name=$(basename "$lib")
    # FIXME: This is a workaround for indirect dependencies?
    patchelf --set-rpath '$ORIGIN' _build/default/lib/"$name"
done

# muslc libc doesn't show up in this list
cp /lib/libc.musl-x86_64.so.1 _build/default/lib/

# Copy the musl dynamic linker to the lib directory
cp /lib/ld-musl-x86_64.so.1 _build/default/lib/

# NOTE: Need to investigate if set-interpreter path can be relative to the
# executable. It seems like it can't be. We currently use path relative to the
# current directory...
patchelf --set-interpreter _build/default/lib/ld-musl-x86_64.so.1 _build/default/bin/main.exe

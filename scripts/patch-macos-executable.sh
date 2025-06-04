#!/usr/bin/env bash

set -exu

cd "$(dirname "$0")/.." || exit 1

dune clean
dune build
otool -L _build/default/bin/main.exe

rm -rf dist
mkdir -p dist/lib
cp -p _build/default/bin/main.exe dist/

# Copy the required libraries to the lib directory (exclude system libraries)
# FIXME: Should we look for /usr/local/lib and /opt/homebrew explicitly?
LIBRARIES=$(otool -L dist/main.exe | grep .dylib | grep -v /usr/lib | awk '{print $1}')

for lib in $LIBRARIES; do
    cp "$lib" dist/lib/
    name=$(basename "$lib")
    install_name_tool -change "$lib" @executable_path/lib/"$name" dist/main.exe
    # Rewrite the library ID too
    install_name_tool -id @executable_path/lib/"$name" dist/lib/"$name"
done

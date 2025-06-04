#!/usr/bin/env bash

CURL_VERSION="8.13.0"

ALPINE_APK_DEPS=(pkgconf openssl-dev libpsl-dev)
apk add "${ALPINE_APK_DEPS[@]}"
cd /tmp

curl -L "https://curl.se/download/curl-${CURL_VERSION}.tar.gz" | tar xz

cd /tmp/curl-${CURL_VERSION}

./configure --with-ssl

make install

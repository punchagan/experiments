FROM alpine:3.21

RUN apk update && \
    apk add --no-cache \
        bash curl git gcc musl-dev make pkgconfig autoconf automake libtool opam patchelf

RUN opam init --disable-sandboxing -v && opam switch create 5.3.0 -v

COPY test_dynamic.opam /project/test_dynamic.opam

WORKDIR /project

RUN eval $(opam env) && \
    opam install --confirm-level=unsafe-yes -y --deps-only .

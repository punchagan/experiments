# Test dynamic linking

Setup an Alpine Docker container. Since, it seems like linking against musl may
be easier, though it might be possible that glibc is easy enough too.

## Usage

1. Build a docker image from the Dockerfile

   ``` sh
   docker build . --tag test-dynamic-linking
   ```

2. Run the docker image

   ``` sh
   docker run -it --rm -v .:/project -w /project test-dynamic-linking /bin/sh
   ```
   
3. Make sure env is set correctly to use the installed opam switch

   ```sh
   eval $(opam env --switch=5.3.0)
   ```
   
4. Run the patch script to build the executable and patch it...

   ```sh
   ./scripts/patch-executable.sh 
   ```
   
5. From the **host machine**, run the executable and `ldd` on it...

   ```sh
   ldd _build/default/bin/main.exe
   _build/default/bin/main.exe
   ```

Note, the curl code fails with `Error: error setting certificate file:
/etc/ssl/cert.pem ` when running the binary build on Alpine in Ubuntu.

But, linking the certificates file from `/usr/lib/ssl/cert.pem` fixes this
problem. (Just as a hack to see if everything else works.)

See also, https://github.com/curl/curl/issues/11411

Each distro's package compiles `libcurl` with the correct path of the
certificates. We'll need to compile our own version of curl and bundle our
certificates file, if we want to dynamically link with libcurl.

See Alpine's build [here](https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/curl/APKBUILD#L215-234). 
See Arch's build [here](https://gitlab.archlinux.org/archlinux/packaging/packages/curl/-/blob/main/PKGBUILD?ref_type=heads#L68-81).

Not sure if the `--disable-shared`
[here](https://github.com/semgrep/semgrep/blob/develop/scripts/build-static-libcurl.sh#30) also bundles the certificates? If not, how does this binary work on any
distro??!

``` sh
sudo ln -s /usr/lib/ssl/cert.pem /etc/ssl/cert.pem
```

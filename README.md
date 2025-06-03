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
   
5. From the host machine, run the executable and `ldd` on it...

   ```sh
   ldd _build/default/bin/main.exe
   _build/default/bin/main.exe
   ```

Note, the curl code fails with `Error: error setting certificate file:
/etc/ssl/cert.pem ` when running the binary build on Alpine in Ubuntu.

But, linking the certificates file from `/usr/lib/ssl/cert.pem` fixes this
problem. (Just as a hack to see if everything else works.)

See also, https://github.com/curl/curl/issues/11411

``` sh
sudo ln -s /usr/lib/ssl/cert.pem /etc/ssl/cert.pem
```

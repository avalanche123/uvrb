Put a libuv.(so|dll|dylib) in this directory to hint uvrb to use it. To use submoduled libuv, go to root directory of uvrb project and run:

```shell
git submodule update --init
rake libuv
```
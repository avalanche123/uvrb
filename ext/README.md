This directory contains libuv submodule the bindings are written for since there are no
versioning tags for the libuv itself yet. To use this local copy of libuv, got to root directory of the uvrb project and run:

```shell
git submodule update --init
rake libuv
```
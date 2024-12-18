Alpine Packaging 101
--------------------

## Setup

```shell
make build # build docker image to use for development
make dev # run a dev container
```

## Build a test package

I choose `crane` as a test package here because it's rather simple.

Once you inside the dev container, you will first need to generate a key with

```shell
abuild-keygen -an
```

And build it

```shell
cd packages/crane
abuild -r
```

Output should look like this

```
>>> crane: Validating /home/anh/Code/alpine-packaging-101/packages/crane/APKBUILD...
>>> WARNING: crane: Go packages require network connection to build. Maybe add 'net' to options
>>> crane: Analyzing dependencies...
>>> crane: Installing for build: build-base go
WARNING: opening /home/nonuser/packages//packages: No such file or directory
(1/2) Installing go (1.23.3-r0)
(2/2) Installing .makedepends-crane (20241121.145740)
Executing busybox-1.36.1-r15.trigger
OK: 428 MiB in 48 packages
>>> crane: Cleaning up srcdir
>>> crane: Cleaning up pkgdir
>>> crane: Cleaning up tmpdir
>>> crane: Fetching crane-0.20.2.tar.gz::https://github.com/google/go-containerregistry/archive/refs/tags/v0.20.2.tar.gz
Connecting to github.com (20.205.243.166:443)
Connecting to codeload.github.com (20.205.243.165:443)
saving to '/var/cache/distfiles/crane-0.20.2.tar.gz.part'
crane-0.20.2.tar.gz. 100% |************************************************************************************************************************| 4315k  0:00:00 ETA
'/var/cache/distfiles/crane-0.20.2.tar.gz.part' saved
>>> crane: Fetching crane-0.20.2.tar.gz::https://github.com/google/go-containerregistry/archive/refs/tags/v0.20.2.tar.gz
>>> crane: Checking sha512sums...
crane-0.20.2.tar.gz: OK
>>> crane: Unpacking /var/cache/distfiles/crane-0.20.2.tar.gz...
>>> crane: Building crane
^[[C^[[C=== RUN   TestDeps
=== RUN   TestDeps/github.com/google/go-containerregistry/cmd/crane
--- PASS: TestDeps (0.16s)
    --- PASS: TestDeps/github.com/google/go-containerregistry/cmd/crane (0.16s)
PASS
ok  	github.com/google/go-containerregistry/cmd/crane	0.168s
>>> crane: Entering fakeroot...
>>> crane*: Running postcheck for crane
>>> crane*: Preparing package crane...
>>> crane*: Stripping binaries
>>> crane*: Scanning shared objects
>>> crane*: Tracing dependencies...
	so:libc.musl-x86_64.so.1
>>> crane*: Package size: 11.4 MB
>>> crane*: Compressing data...
>>> crane*: Create checksum...
>>> crane*: Create crane-0.20.2-r0.apk
>>> crane: Build complete at Thu, 21 Nov 2024 14:57:58 +0000 elapsed time 0h 0m 19s
>>> crane: Cleaning up srcdir
>>> crane: Cleaning up pkgdir
>>> crane: Uninstalling dependencies...
(1/2) Purging .makedepends-crane (20241121.145740)
(2/2) Purging go (1.23.3-r0)
Executing busybox-1.36.1-r15.trigger
OK: 245 MiB in 46 packages
>>> crane: Updating the packages/x86_64 repository index...
>>> crane: Signing the index...
```

Congrats, you have built your first Alpine package.

## Let's go through the package APKBUILD spec

To be updated.

## Tips

### Install LICENSE & README if present

```
install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
install -Dm644 -t "$pkgdir"/usr/share/doc/"$pkgname" README.md
```

### If you disable test, make sure to add a comment why you disable it

```
options="!check" # tests require root privileges (clone, etc...)
```

### Remember Alpine is using musl instead of glibc

Example, you may face something like this

```
# github.com/containers/storage/pkg/unshare
unshare.c: In function 'copy_self_proc_exe':
unshare.c:235:19: warning: implicit declaration of function 'basename' [-Wimplicit-function-declaration]
  235 |         exename = basename(argv[0]);
      |                   ^~~~~~~~
unshare.c:235:17: warning: assignment to 'char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
  235 |         exename = basename(argv[0]);
```

This is serious and will segfault whenever possible.

The program expects a glibc version of `basename()`. If that's the only function used, we can patch it by adding `#include <libgen.h>`. As long as they don't depend on glibc-specific features, this should be enough.


## Submit a Merge request to Alpine's aports

First, you need to register an account with Alpine GitLab at https://gitlab.alpinelinux.org

To be updated.

## License

MIT License

Copyright (c) 2024 Tuan Anh Tran<me@tuananh.org> https://tuananh.org



# Writer's OS

A 55MB minimal Linux distro that boots directly into a text editor.

## Features
- 14MB kernel + 41MB rootfs
- No networking, no GUI, no bloat
- Boots straight to nano
- Persistent storage
- Built with Buildroot

## Build

1. Clone Buildroot:
   git clone https://github.com/buildroot/buildroot
   cd buildroot

2. Apply config:
   cp ../configs/buildroot_defconfig configs/writer_defconfig
   make writer_defconfig

3. Build:
   make -j8

4. Boot:
   qemu-system-x86_64 -kernel output/images/bzImage \
     -drive file=output/images/rootfs.ext4,format=raw

## Stats
- Build time: ~2 hours
- Boot time: <5 seconds
- Memory usage: <100MB

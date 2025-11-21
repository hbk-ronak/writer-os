# Writer's OS

A 55MB minimal Linux distro that boots directly into a text editor.

## Features
- 14MB kernel + 41MB rootfs
- No networking, no GUI, no bloat
- Boots straight to nano
- Persistent storage
- Built with Buildroot

## Build

install dependencies

```sh
sudo apt install build-essential libncurses-dev rsync dc cpio unzip wget file

./scripts/build.sh
dd if=/dev/zero of=userdata.ext4 bs=1M count=256
mkfs.ext4 -F userdata.ext4

qemu-system-x86_64 \                                                       ─╯
    -M pc \
    -drive file=disk.img,if=virtio,format=raw \
    -drive file=userdata.ext4,if=virtio \
    -net nic,model=virtio \
    -net user
```

## Stats
- Build time: ~2 hours
- Boot time: <5 seconds
- Memory usage: <100MB

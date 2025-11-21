# Writer OS

A minimal 55MB Linux distro that boots directly into a text editor.

**Features:** 14MB kernel + 41MB rootfs • No networking or GUI • Boots to nano • Persistent storage

## Quick Start

### Build

Install dependencies (Ubuntu/Debian):

```bash
sudo apt install build-essential libncurses-dev rsync dc cpio unzip wget file
```

Build the OS image:

```bash
./scripts/build.sh
```

Build time: ~2 hours on first run

### Run with QEMU

Create a persistent storage volume:

```bash
dd if=/dev/zero of=userdata.ext4 bs=1M count=256
mkfs.ext4 -F userdata.ext4
```

Launch the OS:

```bash
qemu-system-x86_64 \
    -M pc \
    -drive file=disk.img,if=virtio,format=raw \
    -drive file=userdata.ext4,if=virtio \
    -net nic,model=virtio \
    -net user
```

Boot time: <5 seconds • Memory usage: <100MB

## Project Structure

```
configs/          # Configuration files for kernel and buildroot
scripts/build.sh  # Main build script
```

Built with [Buildroot](https://buildroot.org/)

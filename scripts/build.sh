#!/bin/bash
set -e  # Exit on error
set -u  # Error on undefined variables
set -o pipefail  # Exit on pipe failures

# Get the absolute path to the project root (parent of scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "==> Starting Writer OS build"
echo "    Project root: ${PROJECT_ROOT}"

# Setup build directory
BUILD_DIR="${SCRIPT_DIR}/tmp"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# Clone buildroot if not already present
if [ ! -d "buildroot" ]; then
    echo "==> Cloning buildroot..."
    git clone https://github.com/buildroot/buildroot
else
    echo "==> Buildroot already cloned, skipping..."
fi

# Prepare buildroot configuration
echo "==> Preparing buildroot configuration..."
TEMP_DEFCONFIG="${BUILD_DIR}/buildroot-defconfig.tmp"

# Create temporary defconfig with absolute paths
sed "s|BR2_ROOTFS_OVERLAY=\"\"|BR2_ROOTFS_OVERLAY=\"${PROJECT_ROOT}/overlay\"|g" \
    "${PROJECT_ROOT}/configs/buildroot-defconfig" | \
sed "s|BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE=\"\"|BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE=\"${PROJECT_ROOT}/configs/linux-defconfig\"|g" \
    > "${TEMP_DEFCONFIG}"

# Copy configurations to buildroot
echo "==> Copying configurations to buildroot..."
cp "${TEMP_DEFCONFIG}" "${BUILD_DIR}/buildroot/configs/writer_os_defconfig"
cp "${PROJECT_ROOT}/configs/grub-bios.cfg" "${BUILD_DIR}/buildroot/board/pc/"

# Build
cd "${BUILD_DIR}/buildroot"
echo "==> Loading writer_os_defconfig..."
make writer_os_defconfig

echo "==> Building (this may take a while)..."
make -j8

# Copy output
echo "==> Copying disk image to project root..."
cp "output/images/disk.img" "${PROJECT_ROOT}/disk.img"

echo "==> Build complete! Output: ${PROJECT_ROOT}/disk.img"

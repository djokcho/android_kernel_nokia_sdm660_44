#!/bin/bash

set -e

# Set paths
KERNEL_ROOT=$(pwd)
SRC_IMG="$KERNEL_ROOT/arch/arm64/boot/Image.gz-dtb"
RENAMED_IMG="Image.gz-dtb-kernel"
B2N_DIR="$KERNEL_ROOT/B2Nproducer"
SPLIT_IMG_DIR="$B2N_DIR/split_img"
FINAL_IMG_NAME="latestboot.img"
FINAL_IMG_PATH="$B2N_DIR/$FINAL_IMG_NAME"

# Verify source image exists
if [ ! -f "$SRC_IMG" ]; then
    echo "Error: $SRC_IMG not found!"
    exit 1
fi

# Ensure destination directories exist
mkdir -p "$SPLIT_IMG_DIR"

# Forcefully copy and move image
cp -f "$SRC_IMG" "$KERNEL_ROOT/$RENAMED_IMG"
mv -f "$KERNEL_ROOT/$RENAMED_IMG" "$SPLIT_IMG_DIR/"

# Move to B2Nproducer and run repackimg
cd "$B2N_DIR"

if [ ! -x "./repackimg.sh" ]; then
    echo "Error: repackimg.sh not found or not executable!"
    exit 1
fi

./repackimg.sh

# Ensure latestboot.img was created
if [ ! -f "$FINAL_IMG_NAME" ]; then
    echo "Error: $FINAL_IMG_NAME was not created!"
    exit 1
fi

# Move final image to root of kernel source
mv -f "$FINAL_IMG_NAME" "$KERNEL_ROOT/"

echo "Done. $FINAL_IMG_NAME is now in $KERNEL_ROOT"

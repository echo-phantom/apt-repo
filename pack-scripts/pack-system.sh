#!/bin/bash

# This package contains the update scripts for EupneaOS/Depthboot
set -e

# create dirs
mkdir -p eupnea-system/DEBIAN
mkdir -p eupnea-system/usr/lib/eupnea-system-update/configs

# Clone system-update repo
git clone --depth=1 https://github.com/eupnea-linux/system-update.git

# Copy the update scripts and functions.py
install -Dm 755 system-update/system-update.py eupnea-system/usr/lib/eupnea-system-update
cp system-update/functions.py eupnea-system/usr/lib/eupnea-system-update
cp system-update/eupnea_os_updates.py eupnea-system/usr/lib/eupnea-system-update
cp system-update/depthboot_updates.py eupnea-system/usr/lib/eupnea-system-update

# Copy configs
cp -r system-update/configs/* eupnea-system/usr/lib/eupnea-system-update/configs

# copy debian control files into package
cp control-files/system-control eupnea-system/DEBIAN/control
# Add postinst script to package
install -Dm 755 postinst-scripts/system-postinst eupnea-system/DEBIAN/postinst

# create package
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz eupnea-system

#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://github.com/KytyPS5.png
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun /usr/lib/kytyps5/launcher /usr/lib/kytyps5/kyty_emulator

# The run script re-invokes the AppImage so it does not embed the mount path
echo 'KYTY_APP_LAUNCHER=${APPIMAGE}' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage

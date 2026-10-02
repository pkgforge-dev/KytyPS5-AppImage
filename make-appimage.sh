#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/KytyPS5/KytyPS5/a90be8dd7304640cf4176a975871d51443710292/src/launcher/icons/kyty.svg
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun /usr/lib/kytyps5/kyty_launcher /usr/lib/kytyps5/kyty_emulator

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage

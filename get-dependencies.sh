#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    clang             \
    cpuinfo           \
    fmt               \
    kvantum           \
    lld               \
    lxqt-qtplugin     \
    nlohmann-json     \
    qt6-imageformats  \
    qt6-wayland       \
    qt6-webengine     \
    qt6ct             \
    sdl3              \
    spdlog            \
    stb               \
    vulkan-headers    \
    vulkan-icd-loader \
    zydis

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Getting app..."
echo "---------------------------------------------------------------"
LINK=$(wget https://api.github.com/repos/KytyPS5/KytyPS5/releases/latest -O - \
      | sed 's/[()",{} ]/\n/g' | grep -o -m 1 "https.*Linux-x86_64.tar.gz")
echo "$LINK" | awk -F'/' '{v=$(NF-1); sub(/^v/, "", v); sub(/^KytyPS5-/, "", v); print v; exit}' > ~/version
if ! wget --retry-connrefused --tries=30 "$LINK" -O /tmp/app.tar.gz 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi

mkdir -p ./AppDir/bin
tar -xzf /tmp/app.tar.gz -C ./AppDir/bin ./launcher ./kyty_emulator

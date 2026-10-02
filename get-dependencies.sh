#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    alsa-lib          \
    clang             \
    cmake             \
    dbus              \
    glslang           \
    kvantum           \
    libpulse          \
    libx11            \
    libxcursor        \
    libxext           \
    libxfixes         \
    libxi             \
    libxkbcommon      \
    libxrandr         \
    libxss            \
    libxtst           \
    lld               \
    lxqt-qtplugin     \
    ninja             \
    pkgconf           \
    qt6ct             \
    qt6-imageformats  \
    qt6-wayland       \
    vulkan-headers    \
    vulkan-icd-loader \
    wayland           \
    wayland-protocols

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building KytyPS5 from source..."
echo "---------------------------------------------------------------"
git clone https://github.com/KytyPS5/KytyPS5.git ./kyty && (
	cd ./kyty

	# Build the latest stable tag, nightly builds are not used
	TAG=$(git tag --list 'KytyPS5-*' --sort=-v:refname | head -n 1)
	git checkout "$TAG"
	git submodule update --init --recursive
	echo "${TAG#KytyPS5-}" > ~/version

	git apply ../patches/*.patch

	cmake -B ./build . -GNinja -Wno-dev \
		-DCMAKE_BUILD_TYPE=Release                \
		-DCMAKE_C_COMPILER=clang                  \
		-DCMAKE_CXX_COMPILER=clang++              \
		-DCMAKE_INSTALL_PREFIX=/usr/lib/kytyps5   \
		-DKYTY_BUNDLE_QT_RUNTIME=OFF
	cmake --build ./build --target launcher --parallel "$(nproc)"
	cmake --install ./build
)

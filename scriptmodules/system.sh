#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

function setup_env() {

    __ERRMSGS=()
    __INFMSGS=()

    # if no apt-get we need to fail
    [[ -z "$(which apt-get)" ]] && fatalError "Unsupported OS - No apt-get command found"

    __memory_phys=$(free -m | awk '/^Mem:/{print $2}')
    __memory_total=$(free -m -t | awk '/^Total:/{print $2}')

    get_platform
    get_retropie_depends

    __gcc_version=$(gcc -dumpversion)

    # workaround for GCC ABI incompatibility with threaded armv7+ C++ apps built
    # on Raspbian's armv6 userland https://github.com/raspberrypi/firmware/issues/491
    if [[ "$__os_id" == "Raspbian" ]] && compareVersions $__gcc_version lt 5.0.0; then
        __default_cxxflags+=" -U__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2"
    fi

    # set location of binary downloads
    __binary_host="files.retropie.org.uk"
    [[ "$__has_binaries" -eq 1 ]] && __binary_url="http://$__binary_host/binaries/$__os_codename/$__platform"

    __archive_url="http://files.retropie.org.uk/archives"

    # -pipe is faster but will use more memory - so let's only add it if we have more thans 256M free ram.
    [[ $__memory_phys -ge 256 ]] && __default_cflags+=" -pipe"

    [[ -z "${CFLAGS}" ]] && export CFLAGS="${__default_cflags}"
    [[ -z "${CXXFLAGS}" ]] && export CXXFLAGS="${__default_cflags}"
    [[ -z "${ASFLAGS}" ]] && export ASFLAGS="${__default_asflags}"
    [[ -z "${MAKEFLAGS}" ]] && export MAKEFLAGS="${__default_makeflags}"

    # test if we are in a chroot
    if [[ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ]]; then
        [[ -z "$QEMU_CPU" && -n "$__qemu_cpu" ]] && export QEMU_CPU=$__qemu_cpu
        __chroot=1
    else
        __chroot=0
    fi

    if [[ -z "$__nodialog" ]]; then
        __nodialog=0
    fi
}

function get_default_gcc() {
    if [[ -z "$__default_gcc_version" ]]; then
        case "$__os_id" in
            Raspbian|Debian)
                case "$__os_codename" in
                    wheezy)
                        __default_gcc_version="4.8"
                        ;;
                    *)
                        __default_gcc_version="4.9"
                esac
                ;;
            *)
                ;;
        esac
    fi
}

# gcc version helper
function set_default() {
    if [[ -e "$1-$2" ]] ; then
        # echo $1-$2 is now the default
        ln -sf "$1-$2" "$1"
    else
        echo "$1-$2 is not installed"
    fi
}

# sets default gcc version
function set_default_gcc() {
    pushd /usr/bin > /dev/null
    for i in gcc cpp g++ gcov; do
        set_default $i $1
    done
    popd > /dev/null
}

function get_retropie_depends() {
    local depends=(git dialog wget gcc g++ build-essential unzip xmlstarlet python-pyudev ca-certificates)

    if ! getDepends "${depends[@]}"; then
        fatalError "Unable to install packages required by $0 - ${md_ret_errors[@]}"
    fi

    # make sure we don't have xserver-xorg-legacy installed as it breaks launching x11 apps from ES
    if ! isPlatform "x11" && hasPackage "xserver-xorg-legacy"; then
        aptRemove xserver-xorg-legacy
    fi
}

function get_rpi_video() {
    local pkgconfig="/opt/vc/lib/pkgconfig"

    # detect driver via inserted module / platform driver setup
    if [[ -d "/sys/module/vc4" ]]; then
        __platform_flags+=" mesa kms"
        [[ "$(ls -A /sys/bus/platform/drivers/vc4_firmware_kms/*.firmwarekms 2>/dev/null)" ]] && __platform_flags+=" dispmanx"
    else
        __platform_flags+=" videocore dispmanx"
    fi

    # use our supplied fallback pkgconfig if necessary
    [[ ! -d "$pkgconfig" ]] && pkgconfig="$scriptdir/pkgconfig"

    # set pkgconfig path for vendor libraries
    export PKG_CONFIG_PATH="$pkgconfig"
}

function get_platform() {
    local architecture="$(uname --machine)"
    if [[ -z "$__platform" ]]; then
        case "$(sed -n "/^Hardware/{ s/^.*: \(.*\)/\1/p;q }" < /proc/cpuinfo)" in
            BCM2708)
                __platform="rpi1"
                ;;
            BCM2709)
                local revision="$(sed -n '/^Revision/s/^.*: \(.*\)/\1/p' < /proc/cpuinfo)"
                if [[ "$revision" == "a02082" || "$revision" == "a22082" ]]; then
                    if [[ "$architecture" == "aarch64" ]]; then
                        __platform="rpi3-64"
                    else
                        __platform="rpi3"
                    fi
                else
                    __platform="rpi2"
                fi
                ;;
            ODROIDC)
                __platform="odroid-c1"
                ;;
            ODROID-C2)
                __platform="odroid-c2"
                ;;
            "Allwinner sun8i Family")
                __platform="H3-mali"
                ;;
            "Freescale i.MX6 Quad/DualLite (Device Tree)")
                __platform="imx6"
                ;;
            ODROID-XU3)
                __platform="odroid-xu"
                ;;
            "Rockchip (Device Tree)")
                __platform="tinker"
                ;;
            Vero4K|Vero4KPlus)
                __platform="vero4k"
                ;;
            "Allwinner sun7i (A20) Family")
                __platform="A20-mali"
                ;;
            sun50iw1p1)
                __platform="H5-A64-mali"
                ;;
            *)
                case $architecture in
                    i686|x86_64|amd64)
                        __platform="x86"
                        ;;
                esac
                ;;
        esac
    fi

    if ! fnExists "platform_${__platform}"; then
        fatalError "Unknown platform - please manually set the __platform variable to one of the following: $(compgen -A function platform_ | cut -b10- | paste -s -d' ')"
    fi

    platform_${__platform}
}

function platform_rpi1() {
    # values to be used for configure/make
    __default_cflags="-O2 -mcpu=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard"
    __default_asflags=""
    __default_makeflags=""
    __platform_flags="arm armv6 rpi gles"
    # if building in a chroot, what cpu should be set by qemu
    # make chroot identify as arm6l
    __qemu_cpu=arm1176
    # do we have prebuild binaries for this platform
    __has_binaries=1
}

function platform_rpi2() {
    __default_cflags="-O2 -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations"
    __default_asflags=""
    __default_makeflags="-j2"
    __platform_flags="arm armv7 neon rpi gles"
    __qemu_cpu=cortex-a7
}
# note the rpi3 currently uses the rpi2 binaries - for ease of maintenance - rebuilding from source
# could improve performance with the compiler options below but needs further testing
function platform_rpi3() {
    __default_cflags="-O2 -march=armv8-a+crc -mtune=cortex-a53 -mfpu=neon-fp-armv8 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations"
    __default_asflags=""
    __default_makeflags="-j2"
}

function platform_rpi3-64() {
    platform_rpi3
    __has_binaries=0
    __platform_flags="arm armv8 neon rpi gles"
}

function platform_odroid-c1() {
    __default_cflags="-O2 -mcpu=cortex-a5 -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations"
    __default_asflags=""
    __default_makeflags="-j2"
    __platform_flags="arm armv7 neon mali gles"
    __qemu_cpu=cortex-a9
    __has_binaries=0
}

function platform_odroid-c2() {
    __default_cflags="-O2 -march=native -ftree-vectorize -funsafe-math-optimizations"
    __default_asflags=""
    __default_makeflags="-j4"
    __platform_flags="aarch64 armv8 mali"
    __qemu_cpu=cortex-a15
    __has_binaries=0
    if [[ "$(getconf LONG_BIT)" -eq 32 ]]; then
        __default_cflags="-O2 -march=armv8-a+crc -mtune=cortex-a53 -mfpu=neon-fp-armv8"
        __platform_flags="arm armv8 neon mali gles"
    else
        __default_cflags="-O2 -march=native"
        __platform_flags="aarch64 mali gles"
    fi
}

function platform_odroid-xu() {
    __default_cflags="-O2 -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations"
    # required for mali-fbdev headers to define GL functions
    __default_cflags+=" -DGL_GLEXT_PROTOTYPES"
    __default_asflags=""
    __default_makeflags="-j2"
    __platform_flags="arm armv7 neon mali gles"
}

function platform_tinker() {
    __default_cflags="-O2 -marm -march=armv7-a -mtune=cortex-a17 -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations"
    # required for mali headers to define GL functions
    __default_cflags+=" -DGL_GLEXT_PROTOTYPES"
    __default_asflags=""
    __default_makeflags="-j2"
    __platform_flags="arm armv7 neon kms gles"
}

function platform_x86() {
    __default_cflags="-O2 -march=native"
    __default_asflags=""
    __default_makeflags="-j$(nproc)"
    __has_binaries=0
    __platform_flags="x11 gl"
}

function platform_generic-x11() {
    __default_cflags="-O2"
    __default_asflags=""
    __default_makeflags="-j$(nproc)"
    __has_binaries=0
    __platform_flags="x11 gl"
}

function platform_armv7-mali() {
    __default_cflags="-O2 -march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations"
    __default_asflags=""
    __default_makeflags="-j$(nproc)"
    __platform_flags="arm armv7 neon mali"
    __has_binaries=0
}

function platform_H3-mali() {
    __default_cflags="-O2 -march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations"
    __default_asflags=""
    __default_makeflags="-j4"
    __has_binaries=0
    __platform_flags="arm armv7 neon kms gles"
}

function platform_H5-A64-mali() {
    __default_cflags="-O2 -march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations"
    __default_asflags=""
    __default_makeflags="-j4"
    __has_binaries=0
    __platform_flags="arm armv7 neon kms gles"
}

function platform_A20-mali() {
    __default_cflags="-O2 -march=armv7-a -mtune=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -ffast-math -Ofast"
    __default_asflags=""
    __default_makeflags="-j2"
    __has_binaries=0
    __platform_flags="arm armv7 neon kms gles"
}

function platform_imx6() {
    __default_cflags="-O2 -march=armv7-a -mfpu=neon -mtune=cortex-a9 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations"
    __default_asflags=""
    __default_makeflags="-j2"
    __platform_flags="arm armv7 neon"
    __has_binaries=0
}

function platform_vero4k() {
    __default_cflags="-I/opt/vero3/include -L/opt/vero3/lib -O2 -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations"
    __default_asflags=""
    __default_makeflags="-j4"
    __platform_flags="arm armv7 neon vero4k gles"
}


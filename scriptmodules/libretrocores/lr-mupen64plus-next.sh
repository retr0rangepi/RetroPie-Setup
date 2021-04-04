#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mupen64plus-next"
rp_module_desc="N64 emulator - Mupen64Plus + GLideN64 for libretro (next version)"
rp_module_help="ROM Extensions: .z64 .n64 .v64\n\nCopy your N64 roms to $romdir/n64"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mupen64plus-libretro-nx/master/LICENSE"
rp_module_repo="git https://github.com/libretro/mupen64plus-libretro-nx.git develop"
rp_module_section="opt kms=main"
rp_module_flags=""

function depends_lr-mupen64plus-next() {
    local depends=()
    isPlatform "x11" && depends+=(libglew-dev libglu1-mesa-dev)
    isPlatform "x86" && depends+=(nasm)
    isPlatform "videocore" && depends+=(libraspberrypi-dev)
    isPlatform "mesa" && depends+=(libgles2-mesa-dev)
    getDepends "${depends[@]}"
}

function sources_lr-mupen64plus-next() {
    gitPullOrClone
}

function build_lr-mupen64plus-next() {
    local params=()
    params+=(WITH_DYNAREC=arm)
    params+=(HAVE_NEON=1)
    params+=(FORCE_GLES=1)
    params+=(CORE_NAME=mupen64plus-next)
    make "${params[@]}" clean
    make -j4 "${params[@]}"
    md_ret_require="$md_build/mupen64plus_next_libretro.so"
}

function install_lr-mupen64plus-next() {
    md_ret_files=(
        'mupen64plus_next_libretro.so'
        'LICENSE'
        'README.md'
    )
}

function configure_lr-mupen64plus-next() {
    mkRomDir "n64"
    ensureSystemretroconfig "n64"

    if isPlatform "rpi"; then
        # Disable hybrid upscaling filter (needs better GPU)
        setRetroArchCoreOption "mupen64plus-next-HybridFilter" "False"
        # Disable overscan/VI emulation (slight performance drain)
        setRetroArchCoreOption "mupen64plus-next-EnableOverscan" "Disabled"
        # Enable Threaded GL calls
        setRetroArchCoreOption "mupen64plus-next-ThreadedRenderer" "True"
    fi
    setRetroArchCoreOption "mupen64plus-next-EnableNativeResFactor" "1"

    addEmulator 1 "$md_id" "n64" "$md_inst/mupen64plus_next_libretro.so"
    addSystem "n64"
}

#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-pocketcdg"
rp_module_desc="lr-pocketcdg - pocketcdg port for libretro - A MP3 karaoke music player."
rp_module_help="ROM Extension: .cdg\n\nCopy your .cdg and .mp3 files into $romdir/pocketcdg."
rp_module_licence="MIT https://raw.githubusercontent.com/libretro/libretro-pocketcdg/master/LICENSE"
rp_module_section="exp"

function sources_lr-pocketcdg() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-pocketcdg.git
}

function build_lr-pocketcdg() {
    rpSwap on 750
    make clean
    local params=()
    isPlatform "arm" && params+=("ARM=1")
    make ARCH="$CFLAGS" "${params[@]}"
    rpSwap off
    md_ret_require="$md_build/pocketcdg_libretro.so"
}

function install_lr-pocketcdg() {
    md_ret_files=(
        'pocketcdg_libretro.so'
        'README.md'
    )
}

function configure_lr-pocketcdg() {
    mkRomDir "$romdir/pocketcdg"

    addEmulator 0 "$md_id" "pocketcdg" "$md_inst/pocketcdg_libretro.so" 
    addSystem "pocketcdg" "PocketCDG" ".cdg"
}

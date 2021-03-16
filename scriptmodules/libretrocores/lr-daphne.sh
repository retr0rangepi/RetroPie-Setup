#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-daphne"
rp_module_desc="lr-daphne - Daphne port for libretro - laserdisk games"
rp_module_help="ROM Extension: .zip\n\nCopy your Daphne roms to $romdir/daphne. See readme file for directory structure."
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/daphne/master/docs/mame.txt"
rp_module_section="exp"

function sources_lr-daphne() {
    gitPullOrClone "$md_build" https://github.com/libretro/daphne.git
}

function build_lr-daphne() {
    rpSwap on 750
    make clean
    local params=()
    isPlatform "arm" && params+=("ARM=1")
    make ARCH="$CFLAGS" "${params[@]}"
    rpSwap off
    md_ret_require="$md_build/daphne_libretro.so"
}

function install_lr-daphne() {
    md_ret_files=(
        'daphne_libretro.so'
        'README.md'
    )
}

function configure_lr-daphne() {
    mkRomDir "$romdir/daphne"

    addEmulator 0 "$md_id" "daphne" "$md_inst/daphne_libretro.so" 
    addSystem "daphne" "Daphne" ".zip"
}

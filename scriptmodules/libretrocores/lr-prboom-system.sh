#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-prboom-system"
rp_module_desc="Doom/Doom II engine - PrBoom port for libretro"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/libretro-prboom/master/COPYING"
rp_module_section="opt"

function sources_lr-prboom-system() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-prboom.git
}

function build_lr-prboom-system() {
    make clean
    make
    md_ret_require="$md_build/prboom_libretro.so"
}

function install_lr-prboom-system() {
    md_ret_files=(
        'prboom_libretro.so'
        'prboom.wad'
    )
}

function game_data_lr-prboom-system() {
    if [[ ! -f "$romdir/doom/doom1.wad" ]]; then
        # download doom 1 shareware
        wget -nv -O "$romdir/doom/doom1.wad" "$__archive_url/doom1.wad"
    fi

    if ! echo "e9bf428b73a04423ea7a0e9f4408f71df85ab175 $romdir/doom/freedoom1.wad" | sha1sum -c &>/dev/null; then
        # download (or update) freedoom
        downloadAndExtract "https://github.com/freedoom/freedoom/releases/download/v0.12.1/freedoom-0.12.1.zip" "$romdir/doom/" -j -LL
    fi

    chown -R $user:$user "$romdir/doom"
}

function configure_lr-prboom-system() {
    mkRomDir "doom"
    ensureSystemretroconfig "doom"

    [[ "$md_mode" == "install" ]] && game_data_lr-prboom-system

    cp prboom.wad "$romdir/doom/"
    chown $user:$user "$romdir/doom/prboom.wad"

    addEmulator 0 "lr-prboom" "doom" "$md_inst/prboom_libretro.so %ROM%"
    addSystem "doom" "DOOM" ".pk3 .wad"

}

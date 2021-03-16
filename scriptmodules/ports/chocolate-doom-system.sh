#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="chocolate-doom-system"
rp_module_desc="Chocolate Doom - Enhanced port of the official DOOM source"
rp_module_licence="GPL2 https://raw.githubusercontent.com/chocolate-doom/chocolate-doom/sdl2-branch/COPYING"
rp_module_help="Please add your iWAD files to $romdir/ports/doom/ with filenames in lowercase. Run 'chocolate-doom-setup' to configure your controls and options."
rp_module_section="exp"
rp_module_flags="!mali !x86"

function depends_chocolate-doom-system() {
    getDepends libsdl2-dev libsdl2-net-dev libsdl2-mixer-dev libsamplerate0-dev libpng-dev python-pil automake autoconf unzip
}

function sources_chocolate-doom-system() {
    gitPullOrClone "$md_build" https://github.com/chocolate-doom/chocolate-doom.git
}

function build_chocolate-doom-system() {
    ./autogen.sh
    ./configure --prefix="$md_inst"
    make
    md_ret_require="$md_build/src/chocolate-doom"
    md_ret_require="$md_build/src/chocolate-hexen"
    md_ret_require="$md_build/src/chocolate-heretic"
    md_ret_require="$md_build/src/chocolate-strife"
}

function install_chocolate-doom-system() {
    md_ret_files=(
        'src/chocolate-doom'
        'src/chocolate-hexen'
        'src/chocolate-heretic'
        'src/chocolate-strife'
        'src/chocolate-doom-setup'
        'src/chocolate-hexen-setup'
        'src/chocolate-heretic-setup'
        'src/chocolate-strife-setup'
        'src/chocolate-setup'
        'src/chocolate-server'
    )
}

function configure_chocolate-doom-system() {
    mkRomDir "doom"

    mkUserDir "$home/.config"
    moveConfigDir "$home/.local/share/chocolate-doom" "$md_conf_root/chocolate-doom"

    # download doom 1 shareware
    if [[ ! -f "$romdir/doom/doom1.wad" ]]; then
        wget "$__archive_url/doom1.wad" -O "$romdir/doom/doom1.wad"
    fi

    if [[ ! -f "$romdir/doom/freedoom1.wad" ]]; then
        wget "https://github.com/freedoom/freedoom/releases/download/v0.12.1/freedoom-0.12.1.zip"
        unzip freedoom-0.12.1.zip
        mv freedoom-0.12.1/*.wad "$romdir/doom"
        rm -rf freedoom-0.12.1
        rm freedoom-0.12.1.zip
    fi

#    chown $user:$user "$romdir/doom/*"
    addEmulator 0 "chocolate-doom" "doom" "$md_inst/chocolate-doom -iwad $romdir/doom/doom.wad -file %ROM%"
    addEmulator 0 "chocolate-doom1" "doom" "$md_inst/chocolate-doom -iwad $romdir/doom/doom1.wad -file %ROM%"
    addEmulator 0 "chocolate-doom2" "doom" "$md_inst/chocolate-doom -iwad $romdir/doom/doom2.wad -file %ROM%"
    addEmulator 0 "chocolate-doomu" "doom" "$md_inst/chocolate-doom -iwad $romdir/doom/doomu.wad -file %ROM%"
    addEmulator 0 "chocolate-freedoom1" "doom" "$md_inst/chocolate-doom -iwad $romdir/doom/freedoom1.wad -file %ROM%"
    addEmulator 0 "chocolate-freedoom2" "doom" "$md_inst/chocolate-doom -iwad $romdir/doom/freedoom2.wad -file %ROM%"
    addSystem "doom" "DOOM" ".pk3 .wad"

}

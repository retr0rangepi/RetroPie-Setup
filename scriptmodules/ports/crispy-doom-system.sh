#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="crispy-doom-system"
rp_module_desc="Crispy Doom - Enhanced port of the official DOOM source"
rp_module_licence="GPL2 https://raw.githubusercontent.com/fabiangreffrath/crispy-doom/master/COPYING"
rp_module_help="Please add your iWAD files to $romdir/ports/doom/ and reinstall $md_id to create entries for each game to EmulationStation. Run 'crispy-setup' to configure your controls and options."
rp_module_section="exp"
rp_module_flags="!mali !x86"

function depends_crispy-doom-system() {
    getDepends libsdl2-dev libsdl2-mixer-dev libsdl2-net-dev python-pil automake autoconf unzip
}

function sources_crispy-doom-system() {
    gitPullOrClone "$md_build" https://github.com/fabiangreffrath/crispy-doom.git
}

function build_crispy-doom-system() {
    ./autogen.sh
    ./configure --prefix="$md_inst"
    make
    md_ret_require="$md_build/src/crispy-doom"
}

function install_crispy-doom-system() {
    md_ret_files=(
        'src/crispy-doom'
        'src/crispy-doom-setup'
        'src/crispy-setup'
        'src/crispy-server'
    )
}

function configure_crispy-doom-system() {
    mkRomDir "doom"

    mkUserDir "$home/.config"
    moveConfigDir "$home/.local/share/crispy-doom" "$md_conf_root/crispy-doom"

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
    addEmulator 0 "crispy-doom" "doom" "$md_inst/crispy-doom -iwad $romdir/doom/doom.wad -file %ROM%"
    addEmulator 0 "crispy-doom1" "doom" "$md_inst/crispy-doom -iwad $romdir/doom/doom1.wad -file %ROM%"
    addEmulator 0 "crispy-doom2" "doom" "$md_inst/crispy-doom -iwad $romdir/doom/doom2.wad -file %ROM%"
    addEmulator 0 "crispy-doomu" "doom" "$md_inst/crispy-doom -iwad $romdir/doom/doomu.wad -file %ROM%"
    addEmulator 0 "crispy-freedoom1" "doom" "$md_inst/crispy-doom -iwad $romdir/doom/freedoom1.wad -file %ROM%"
    addEmulator 0 "crispy-freedoom2" "doom" "$md_inst/crispy-doom -iwad $romdir/doom/freedoom2.wad -file %ROM%"
    addSystem "doom" "DOOM" ".pk3 .wad"

}


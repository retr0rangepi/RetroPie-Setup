#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="openjazz"
rp_module_desc="OpenJazz - An enhanced Jazz Jackrabbit source port"
rp_module_licence="GPL2 https://raw.githubusercontent.com/AlisterT/openjazz/master/COPYING"
rp_module_help="For playing the registered version, replace the shareware files by adding your full version game files to $romdir/ports/openjazz/."
rp_module_section="exp"

function depends_openjazz() {
    getDepends cmake libsdl1.2-dev libsdl-net1.2-dev libsdl-sound1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev timidity freepats unzip libxmp-dev
}

function sources_openjazz() {
    gitPullOrClone "$md_build" https://github.com/AlisterT/openjazz.git
}

function build_openjazz() {
    cd "$md_build"
    make
    md_ret_require="$md_build/"
}

function install_openjazz() {
    md_ret_files=(
       'OpenJazz'
       'openjazz.000'
    )
}

function configure_openjazz() {
    mkRomDir "ports/openjazz"

    moveConfigDir "$home/.openjazz" "$md_conf_root/openjazz"
    moveConfigFile "$home/openjazz.cfg" "$md_conf_root/openjazz/openjazz.cfg"

    if [[ ! -f "$romdir/ports/jazz/JAZZ.EXE" ]]; then
        downloadAndExtract "https://image.dosgamesarchive.com/games/jazz.zip" "$romdir/ports/openjazz"
        chown -R $user:$user "$romdir/ports/openjazz"
    fi

    addPort "$md_id" "openjazz" "OpenJazz - An enhanced Jazz Jackrabbit source port" "$md_inst/OpenJazz HOMEDIR $romdir/ports/openjazz"
}

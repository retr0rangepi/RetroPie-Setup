#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="goonies"
rp_module_desc="Goonies - MSX Remake"
rp_module_section="exp"
rp_module_flags="!x86"

function depends_goonies() {
    getDepends libsdl1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev libsdl-net1.2-dev libsdl-ttf2.0-dev
}

function sources_goonies() {
    wget -O- -q http://braingames.jorito.net/goonies/downloads/goonies.src_1.4.1528.tgz | tar -xv
    applyPatch "$md_data/01-update_flags.patch"
    sed -i '97s/return false/return 0/' "$md_build/goonies-1.4.1528/src/auxiliar.cpp" 
}

function build_goonies() {
    cd "$md_build/goonies-1.4.1528"
    make -j4
    md_ret_require="$md_build/goonies-1.4.1528/goonies"
}

function install_goonies() {
    md_ret_files=(
       'goonies-1.4.1528/goonies'
       'goonies-1.4.1528/sound'
       'goonies-1.4.1528/maps'
       'goonies-1.4.1528/graphics'
    )
}

function configure_goonies() {
    mkRomDir "ports"
    moveConfigDir "$home/.goonies" "$md_conf_root/$md_id"
    addPort "$md_id" "goonies" "Goonies - MSX Remake" "pushd $md_inst; ./goonies; popd" 
}



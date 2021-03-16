#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="sorr"
rp_module_desc="Streets of Rage Remake"
rp_module_help="Please copy your SorR.dat file along with the mod and palettes folders into $romdir/ports/$md_id."
rp_module_section="exp"
rp_module_flags="!x86 !x11 !mali"

function depends_sorr() {
    getDepends libsdl-mixer1.2 libpng12-0
}

function sources_sorr() {
    gitPullOrClone "$md_build" https://github.com/zerojay/bennugd.git
}

function install_sorr() {
    md_ret_files=(
    'bgdi-333'
    )
}

function configure_sorr() {
    mkRomDir "ports/$md_id"
    chmod 755 "$md_inst/bgdi-333"
    ln -s "$romdir/ports/$md_id/SorR.dat" "$md_inst/SorR.dat"
    ln -s "$romdir/ports/$md_id/mod" "$md_inst/mod"
    ln -s "$romdir/ports/$md_id/palettes" "$md_inst/palettes"
    ln -s "$romdir/ports/$md_id/SorMaker.dat" "$md_inst/SorMaker.dat"
    moveConfigFile "$md_inst/savegame" "$md_conf_root/$md_id/"
    addPort "$md_id" "sorr" "Streets of Rage Remake" "pushd $md_inst; ./bgdi-333 ./SorR.dat; popd"
}

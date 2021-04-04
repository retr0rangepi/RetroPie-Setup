#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="f1spirit"
rp_module_desc="F-1 Spirit - MSX Remake"
rp_module_section="exp"
rp_module_flags="!x86"
rp_module_repo="git https://github.com/ptitSeb/f1spirit"

function depends_f1spirit() {
    getDepends libsdl1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev libsdl-net1.2-dev libsdl-ttf2.0-dev
}

function sources_f1spirit() {
    gitPullOrClone
    applyPatch "$md_data/0001-adding-ROPI-target.patch"
}

function build_f1spirit() {
    cd "$md_build"
    make -j4 ROPI=1
    md_ret_require="$md_build/f1spirit"
}

function install_f1spirit() {
    md_ret_files=(
       'demos'
       'f1spirit'
       'graphics'
       'sound'
       'tracks'
       'readme.txt'
    )
}

function configure_f1spirit() {
    mkRomDir "ports"
    moveConfigDir "$home/.f1spirit" "$md_conf_root/$md_id"
    addPort "$md_id" "f1spirit" "F-1 Spirit - MSX Remake" "pushd $md_inst; ./f1spirit; popd" 
}



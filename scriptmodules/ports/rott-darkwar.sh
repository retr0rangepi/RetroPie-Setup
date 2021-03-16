#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="rott-darkwar"
rp_module_desc="rott-darkwar - Rise of the Triad - Dark War"
rp_module_licence="GPL2 https://raw.githubusercontent.com/zerojay/RoTT/master/COPYING"
rp_module_help="Please add your full version ROTT files to $romdir/ports/$md_id/ to play."
rp_module_section="exp"
rp_module_flags="!mali !x86"

function depends_rott-darkwar() {
    getDepends libsdl1.2-dev libsdl-mixer1.2-dev automake
}

function sources_rott-darkwar() {
    gitPullOrClone "$md_build" https://github.com/zerojay/RoTT
}

function build_rott-darkwar() {
    sed -i 's/SUPERROTT   ?= 1/SUPERROTT   ?= 0/g' "$md_build/rott/Makefile"
    make clean
    make rott-darkwar
    make rott-darkwar
    make rott-darkwar
    md_ret_require=(
        "$md_build/rott-darkwar"
    )
}

function install_rott-darkwar() {
   md_ret_files=(
          'rott-darkwar'
    )
}

function configure_rott-darkwar() {
    mkRomDir "ports"
    mkRomDir "ports/$md_id"
    moveConfigDir "$home/.rott" "$md_conf_root/rott"

    addPort "$md_id" "rott-darkwar" "rott - Rise of the Triad Dark War" "pushd $romdir/ports/rott-darkwar; $md_inst/rott-darkwar; popd"
}

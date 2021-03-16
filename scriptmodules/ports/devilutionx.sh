#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="devilutionx"
rp_module_desc="devilutionx - Diablo Engine"
rp_module_licence="https://raw.githubusercontent.com/diasurgical/devilutionX/master/LICENSE"
rp_module_help="Copy your original diabdat.mpq file from Diablo to $romdir/ports/devilutionx."
rp_module_section="exp"
rp_module_flags="!x86 !mali"

function depends_devilutionx() {
    getDepends cmake g++ libsdl2-mixer-dev libsdl2-ttf-dev libsodium-dev
}

function sources_devilutionx() {
    gitPullOrClone "$md_build" https://github.com/diasurgical/devilutionX
}

function build_devilutionx() {
    cd build
    cmake -DBINARY_RELEASE=ON CMAKE_INSTALL_PREFIX="$md_inst" ..
    make -j3
}

function install_devilutionx() {
    md_ret_files=(
          'build/devilutionx'
          'build/CharisSILB.ttf'
    )
    cp "$md_build/CharisSILB.ttf" "/usr/share/fonts/truetype/CharisSILB.ttf"

}

function configure_devilutionx() {
    mkRomDir "ports"
    mkRomDir "ports/devilutionx"

    addPort "$md_id" "devilutionx" "devilutionx - Diablo Engine" "$md_inst/devilutionx --data-dir $romdir/ports/devilutionx --save-dir $md_conf_root/devilutionx"
}

#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="kaiten-patissier"
rp_module_desc="Kaiten Patissier - RotateGear"
rp_module_section="exp"
rp_module_flags="!x11 !mali"

function depends_kaiten-patissier() {
    getDepends libsdl1.2-dev libsdl-gfx1.2-dev libsdl-mixer1.2-dev unzip
}

function sources_kaiten-patissier() {
    wget -q http://www.geocities.jp/dij4121/alpha/data/rg_105.zip
    unzip rg_105.zip
}

function build_kaiten-patissier() {
    cd "$md_build/rg_105/src"
    make clean
    make -f Makefile.linux
    md_ret_require="$md_build/rg_105/src/RotateGear"
}

function install_kaiten-patissier() {
    md_ret_files=(
       'rg_105/src/RotateGear'
       'rg_105/data'
       'rg_105/image'
       'rg_105/replay'
       'rg_105/save'
       'rg_105/sound'
    )
}

function configure_kaiten-patissier() {
    mkRomDir "ports"
    moveConfigDir "$md_inst/save" "$md_conf_root/$md_id"
    chown -R $user:$user "$md_inst/save"

    addPort "$md_id" "kaiten-patissier" "Kaiten Patissier - RotateGear" "pushd $md_inst; $md_inst/RotateGear; popd"
}

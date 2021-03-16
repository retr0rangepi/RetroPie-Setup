#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="ganbare"
rp_module_desc="Ganbare! Natsuke-San - 2D Platformer"
rp_module_section="exp"
rp_module_flags="!x11 !mali"

function depends_ganbare() {
    getDepends libsdl1.2-dev libsdl-gfx1.2-dev libsdl-mixer1.2-dev unzip
}

function sources_ganbare() {
    wget -q http://www.geocities.jp/dij4121/alpha/data/gnp_104.zip
    unzip gnp_104.zip
}

function build_ganbare() {
    cd "$md_build/gnp_104"
    make clean
    make -f Makefile.linux
    md_ret_require="$md_build/gnp_104/gnp"
}

function install_ganbare() {
    md_ret_files=(
       'gnp_104/gnp'
       'gnp_104/data'
       'gnp_104/image'
       'gnp_104/replay'
       'gnp_104/save'
       'gnp_104/sound'
    )
}

function configure_ganbare() {
    mkRomDir "ports"
    moveConfigDir "$md_inst/save" "$md_conf_root/$md_id"
    chown -R $user:$user "$md_inst/save"

    addPort "$md_id" "ganbare" "Ganbare! Natsuke-San - 2D Platformer" "pushd $md_inst; $md_inst/gnp; popd"
}

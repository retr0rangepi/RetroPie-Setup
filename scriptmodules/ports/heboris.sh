#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="heboris"
rp_module_desc="HeborisC7EX - Tetris The Grand Master Clone"
rp_module_help="To get mp3 audio working, you will need to change the music type from MIDI to MP3 in the Heboris options menu."
rp_module_section="exp"
rp_module_flags="!mali"

function depends_heboris() {
    getDepends libsdl1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev libgl1-mesa-dev
}

function sources_heboris() {
    gitPullOrClone "$md_build" https://github.com/zerojay/HeborisC7EX.git
}

function build_heboris() {
    make
    md_ret_require="$md_build/heboris"
}

function install_heboris() {
    md_ret_files=(
          'heboris'
          'res'
          'replay'
          'config'
          'heboris.ini'
          'heboris.txt'
    )
}

function configure_heboris() {
    chown pi:pi "$md_inst/heboris"
    moveConfigDir "$md_inst/config" "$md_conf_root/$md_id/config"
    moveConfigDir "$md_inst/replay" "$md_conf_root/$md_id/replay"
    moveConfigFile "$md_inst/heboris.ini" "$md_conf_root/$md_id/heboris.ini"
    addPort "$md_id" "heboris" "HeborisC7EX - Tetris The Grand Master Clone" "pushd $md_inst; ./heboris; popd"
}

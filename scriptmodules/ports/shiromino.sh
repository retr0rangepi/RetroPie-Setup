#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="shiromino"
rp_module_desc="shiromino - Tetris The Grand Master Clone"
rp_module_help="Requires a keyboard to exit or restart the game."
rp_module_section="exp"
rp_module_flags="!mali"

function depends_shiromino() {
    getDepends cmake libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libvorbis-dev libsqlite3-dev
}

function sources_shiromino() {
    gitPullOrClone "$md_build" https://github.com/FelicityVi/shiromino
}

function build_shiromino() {
    make
    md_ret_require="$md_build/bin/game"
}

function install_shiromino() {
    md_ret_files=(
          'bin/game'
          'game.cfg'
          'audio'
          'docs'
          'gfx'
    )
}

function configure_shiromino() {
    chown pi:pi "$md_inst"
    mv "$md_inst/game" "$md_inst/shiromino"
    touch "$md_inst/scores.db"
    moveConfigFile "$md_inst/scores.db" "$md_conf_root/shiromino/scores.db"
    moveConfigFile "$md_inst/game.cfg" "$md_conf_root/shiromino/game.cfg"

    addPort "$md_id" "shiromino" "shiromino - Tetris The Grand Master Clone" "pushd $md_inst; ./shiromino; popd"
}

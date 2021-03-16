#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="ulmos-adventure"
rp_module_desc="Ulmo's Adventure - Simple Adventure Game"
rp_module_section="exp"
rp_module_flags="!mali"

function depends_ulmos-adventure() {
    getDepends python-pygame python-cwiid
}

function sources_ulmos-adventure() {
    gitPullOrClone "$md_build" https://github.com/rm-hull/ulmos-adventure.git
}

function install_ulmos-adventure() {
    cp -Rv "$md_build/game/src" "$md_inst"
}

function configure_ulmos-adventure() {
    chown -R $user:$user "$md_inst"
    addPort "$md_id" "ulmos-adventure" "Ulmo's Adventure - Simple Adventure Game" "pushd $md_inst/src/; python play.py; popd"
}

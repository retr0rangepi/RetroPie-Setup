#!/usr/bin/env bash
 
# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#
 
rp_module_id="wizznic"
rp_module_desc="Wizznic - Puzznic clone"
rp_module_section="exp"
rp_module_flags="!x86 !mali"

function depends_wizznic() {
    aptInstall wizznic
}
 
function configure_wizznic() {
    moveConfigDir "$home/.wizznic" "$md_conf_root/$md_id"
    addPort "$md_id" "wizznic" "Wizznic - Puzznic clone" "/usr/games/wizznic -z 2 -sw"
}

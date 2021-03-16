#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="netsurf"
rp_module_desc="netsurf - Lightweight web browser"
rp_module_licence="GPL2 https://www.gnu.org/licenses/gpl-2.0.txt"
rp_module_section="exp"
rp_module_flags="!mali !x86"

function install_bin_netsurf() {
    aptInstall netsurf xdg-utils matchbox
}

function configure_netsurf() {
    mkRomDir "ports"

    moveConfigDir "$home/.netsurf" "$md_conf_root/$md_id"

    cat >"$md_inst/netsurf.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no &
/usr/bin/netsurf
_EOF_
    chmod +x "$md_inst/netsurf.sh"
    addPort "$md_id" "netsurf" "netsurf - Lightweight web browser" "xinit $md_inst/netsurf.sh"
}

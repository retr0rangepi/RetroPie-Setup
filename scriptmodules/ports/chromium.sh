#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="chromium"
rp_module_desc="chromium - Open Source Web Browser"
rp_module_licence="MIT https://raw.githubusercontent.com/chromium/chromium/trunk/LICENSE"
rp_module_section="exp"
rp_module_flags="!mali !x86"

function depends_chromium() {
        getDepends git omxplayer libgnome-keyring-common libgnome-keyring0 libnspr4 libnss3 xdg-utils matchbox xorg gconf-service libgconf-2-4 rpi-chromium-mods
}

function sources_chromium() {
    apt-get install chromium-browser
}

function configure_chromium() {
    mkRomDir "ports"
    mkdir -p "$md_inst"
    moveConfigDir "$home/.config/$md_id" "$md_conf_root/$md_id"
    cat >"$md_inst/chromium.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no &
/usr/bin/chromium-browser
_EOF_
    chmod +x "$md_inst/chromium.sh"

    addPort "$md_id" "chromium" "Chromium - Open Source Web Browser" "xinit $md_inst/chromium.sh"
}

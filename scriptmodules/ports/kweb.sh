#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="kweb"
rp_module_desc="kweb - Minimal Kiosk Web Browser"
rp_module_licence="GPL3 https://raw.githubusercontent.com/ekapujiw2002/kweb/master/COPYING"
rp_module_section="exp"
rp_module_flags="!mali !x86"

function depends_kweb() {
    getDepends evince vlc tint2 lxterminal uget git xterm xserver-xorg-legacy
}

function sources_kweb() {
    wget -O- -q http://steinerdatenbank.de/software/kweb-1.7.9.8.tar.gz | tar -zxv
    wget -O- -q http://steinerdatenbank.de/software/kweb_upgrade_buster_20190823.tar.gz | tar -zxv
}

function install_kweb() {
    cd kweb-1.7.9.8
    ./debinstall
    cd ..
    cd kweb_upgrade_buster_20190823
    ./install
}

function configure_kweb() {
    mkRomDir "ports"
    addPort "$md_id" "kweb" "kweb - Minimal Kiosk Web Browser" "xinit kweb"
}

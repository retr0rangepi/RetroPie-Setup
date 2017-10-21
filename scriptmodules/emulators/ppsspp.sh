#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="ppsspp"
rp_module_desc="PlayStation Portable emulator PPSSPP"
rp_module_help="ROM Extensions: .iso .pbp .cso\n\nCopy your PlayStation Portable roms to $romdir/psp"
rp_module_licence="GPL2 https://raw.githubusercontent.com/hrydgard/ppsspp/master/LICENSE.TXT"
rp_module_section="opt"
rp_module_flags="newbrcmlibs"

function sources_ppsspp() {
    #Let's add Odroid repository for best compatibility with RetrOrangePi
    rm -rf /etc/apt/sources.list.d/meveric-jessie-main.list
    cd /etc/apt/sources.list.d/
    wget https://oph.mdrjr.net/meveric/sources.lists/meveric-jessie-main.list
    wget -O- http://oph.mdrjr.net/meveric/meveric.asc | apt-key add -
    aptUpdate
}

function install_bin_ppsspp() {
    aptInstall ppsspp-odroid
    #Cleaning the repositories
    rm -rf /etc/apt/sources.list.d/meveric-jessie-main.list
}

function remove_ppsspp() {
    aptRemove ppsspp-odroid
}

function configure_ppsspp() {
    mkRomDir "psp"

    mkUserDir "$home/.config"
    moveConfigDir "$home/.config/ppsspp" "$md_conf_root/psp"
    mkUserDir "$md_conf_root/psp/PSP"
    ln -snf "$romdir/psp" "$md_conf_root/psp/PSP/GAME"

    addEmulator 0 "$md_id" "psp" "/usr/local/share/ppsspp/PPSSPPSDL %ROM%"
    addSystem "psp"
}

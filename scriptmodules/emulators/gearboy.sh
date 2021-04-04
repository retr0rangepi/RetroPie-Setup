#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="gearboy"
rp_module_desc="Gearboy - Gameboy & Gameboy Color Emulator"
rp_module_licence="GPL3 https://raw.githubusercontent.com/drhelius/Gearboy/master/LICENSE"
rp_module_section="exp"
rp_module_flags="!x86 !mali"

function depends_gearboy() {
    getDepends build-essential libfreeimage-dev libopenal-dev libpango1.0-dev libsndfile1-dev libudev-dev libasound2-dev libjpeg-dev libtiff5-dev libwebp-dev automake libconfig++-dev
    #if [[ "$__raspbian_ver" -lt "8" ]]; then
    #    getDepends libjpeg8-dev
    #else
    #    getDepends libjpeg-dev
    #fi
}

function sources_gearboy() {
    gitPullOrClone "$md_build" https://github.com/DrHelius/GearBoy.git
}

function build_gearboy() {
    cd "$md_build/platforms/linux"

    make clean
    make -j4
    strip "gearboy"
    md_ret_require="$md_build/platforms/linux/gearboy"
}

function install_gearboy() {
    cp "$md_build/platforms/linux/gearboy" "$md_inst/gearboy"
}

function configure_gearboy() {
    mkRomDir "gbc"
    mkRomDir "gb"
    ensureSystemretroconfig "gb"
    ensureSystemretroconfig "gbc"
    moveConfigFile "$home/gearboy.cfg" "$md_conf_root/gearboy/gearboy.cfg"
    addEmulator 0 "$md_id" "gb" "$md_inst/gearboy %ROM%"
    addEmulator 0 "$md_id" "gbc" "$md_inst/gearboy %ROM%"
    addSystem "gb"
    addSystem "gbc"
}

#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="rott-huntbgin"
rp_module_desc="rott - Rise of the Triad - The Hunt Begins (Shareware)"
rp_module_licence="GPL2 https://raw.githubusercontent.com/zerojay/RoTT/master/COPYING"
rp_module_help="Please add your shareware version ROTT files to $romdir/ports/$md_id/huntbgin to play."
rp_module_section="exp"
rp_module_flags="!mali !x86"

function depends_rott-huntbgin() {
    getDepends libsdl1.2-dev libsdl-mixer1.2-dev automake autoconf unzip
}

function sources_rott-huntbgin() {
    gitPullOrClone "$md_build" https://github.com/zerojay/RoTT
}

function build_rott-huntbgin() {
    sed -i 's/SHAREWARE   ?= 0/SHAREWARE   ?= 1/g' "$md_build/rott/Makefile"
    sed -i 's/SUPERROTT   ?= 1/SUPERROTT   ?= 0/g' "$md_build/rott/Makefile"
    make clean
    make rott-huntbgin
    make rott-huntbgin
    make rott-huntbgin
    md_ret_require=(
        "$md_build/rott-huntbgin"
    )
}

function install_rott-huntbgin() {
   md_ret_files=(
          'rott-huntbgin'
    )
}

function configure_rott-huntbgin() {
    mkRomDir "ports"
    mkRomDir "ports/$md_id"
    
    wget "http://icculus.org/rott/share/1rott13.zip" -O 1rott13.zip
    unzip -L -o 1rott13.zip rottsw13.shr
    unzip -L -o rottsw13.shr -d "$romdir/ports/$md_id" huntbgin.wad huntbgin.rtc huntbgin.rtl remote1.rts
    rm "$md_inst/1rott13.zip"
    mv  "$romdir/ports/$md_id/remote1.rts" "$romdir/ports/$md_id/REMOTE1.RTS"
    mv  "$romdir/ports/$md_id/huntbgin.wad" "$romdir/ports/$md_id/HUNTBGIN.WAD"
    mv  "$romdir/ports/$md_id/huntbgin.rtc" "$romdir/ports/$md_id/HUNTBGIN.RTC"
    mv  "$romdir/ports/$md_id/huntbgin.rtl" "$romdir/ports/$md_id/HUNTBGIN.RTL"
    moveConfigDir "$home/.rott" "$md_conf_root/rott"

    addPort "$md_id" "rott-huntbgin" "rott - Rise of the Triad port Hunt Begins (Shareware)" "pushd $romdir/ports/rott-huntbgin/; $md_inst/rott-huntbgin; popd"
}

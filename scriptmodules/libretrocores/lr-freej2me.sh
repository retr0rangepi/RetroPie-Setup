#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-freej2me"
rp_module_desc="lr-freej2me - J2ME Game Player"
rp_module_help="ROM Extension: .jar\n\nCopy your J2ME games to $romdir/j2me"
rp_module_licence="GPL3 https://raw.githubusercontent.com/hex007/freej2me/master/LICENSE"
rp_module_section="exp"

function depends_lr-freej2me() {
    getDepends ant
    sudo update-alternatives --config java
}

function sources_lr-freej2me() {
    gitPullOrClone "$md_build" https://github.com/hex007/freej2me.git
}

function build_lr-freej2me() {
    ant
    cd "$md_build/src/libretro"
    make
    md_ret_require=("$md_build/src/libretro/freej2me_libretro.so")
}

function install_lr-freej2me() {
    cp "$md_build/build/freej2me-lr.jar" "$home/RetroPie/BIOS/"
    md_ret_files=(
        'src/libretro/freej2me_libretro.so'
        'LICENSE'
        'README.md'
    )
}

function configure_lr-freej2me() {
    mkRomDir "j2me"
    ensureSystemretroconfig "j2me"

    addEmulator 1 "$md_id" "j2me" "$md_inst/freej2me_libretro.so" ".jar .JAR"
    addSystem "j2me"
}

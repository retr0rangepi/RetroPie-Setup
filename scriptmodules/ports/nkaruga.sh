#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="nkaruga"
rp_module_desc="nKaruga - Ikaruga demake"
rp_module_licence="MIT https://github.com/gameblabla/nKaruga/blob/master/COPYING"
rp_module_section="exp"
rp_module_flags="!mali !kms"

function depends_nkaruga() {
    getDepends libsdl2-dev libsdl2-mixer-dev
}

function sources_nkaruga() {
    gitPullOrClone "$md_build" https://github.com/gameblabla/nKaruga.git
}

function build_nkaruga() {
    make -f Makefile.linux
    md_ret_require="$md_build/nKaruga.elf"
}

function install_nkaruga() {
    md_ret_files=(
        'nKaruga.elf'
        'sfx'
    )

}

function configure_nkaruga() {
    addPort "$md_id" "nkaruga" "nKaruga - Ikaruga demake" "$md_inst/nKaruga.elf"
}

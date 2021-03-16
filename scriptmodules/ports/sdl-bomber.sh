#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="sdl-bomber"
rp_module_desc="sdl-bomber - Atomic Bomberman Clone"
rp_module_licence="GPL2 https://raw.githubusercontent.com/HerbFargus/SDL-Bomber/master/COPYING"
rp_module_section="exp"
rp_module_flags="!mali"

function depends_sdl-bomber() {
    getDepends libsdl1.2-dev
}

function sources_sdl-bomber() {
    gitPullOrClone "$md_build" https://github.com/HerbFargus/SDL-Bomber.git
}

function build_sdl-bomber() {
  make
  md_ret_require="$md_build"
}

function install_sdl-bomber() {
    md_ret_files=(
	'data'
	'bomber'
	'matcher'
    )
}

function configure_sdl-bomber() {
    setConfigRoot "ports"

    addPort "$md_id" "sdl-bomber" "SDL-Bomber" "pushd $md_inst; ./bomber; popd"
}

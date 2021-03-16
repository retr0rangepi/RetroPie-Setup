#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="xash3d-fwgs"
rp_module_desc="xash3d-fwgs - Half-Life Engine Port"
rp_module_help="Please add your full version Half-Life data files (everything from the /valve folder) to $romdir/ports/$md_id/valve/ to play."
rp_module_section="exp"
rp_module_flags="!mali !x86"

function depends_xash3d-fwgs() {
    getDepends libsdl2-dev libfontconfig1-dev libfreetype6-dev
}

function sources_xash3d-fwgs() {
    # Until our pull request is accepted.
    gitPullOrClone "$md_build/$md_id" https://github.com/FWGS/xash3d-fwgs.git
    gitPullOrClone "$md_build/hlsdk" https://github.com/FWGS/hlsdk-xash3d.git
}

function build_xash3d-fwgs() {
    cd "$md_build/$md_id"
    ./waf configure -T release
    ./waf build
    cd "$md_build/hlsdk"
    ./waf configure -T release
    ./waf build
    md_ret_require=(
        "$md_build/$md_id/build/game_launch/xash3d"
        "$md_build/$md_id/build/engine/libxash.so"
        "$md_build/$md_id/build/mainui/libmenu.so"
        "$md_build/$md_id/build/ref_soft/libref_soft.so"
        "$md_build/$md_id/build/ref_gl/libref_gl.so"
    )
}

function install_xash3d-fwgs() {
    md_ret_files=(
        "$md_id/build/game_launch/xash3d"
        "$md_id/build/engine/libxash.so"
        "$md_id/build/mainui/libmenu.so"
        "$md_id/build/ref_soft/libref_soft.so"
        "$md_id/build/ref_gl/libref_gl.so"
        "hlsdk/build/cl_dll/client_armv8_32hf.so"
        "hlsdk/build/dlls/hl_armv8_32hf.so"
    )

}

function configure_xash3d-fwgs() {
    mkRomDir "ports/$md_id/valve"
    ln -s "$romdir/ports/$md_id/valve" "$md_inst/valve"
    mkdir "$romdir/ports/$md_id/valve/cl_dlls"
    mkdir "$romdir/ports/$md_id/valve/dlls"
    cp "$md_build/hlsdk/build/cl_dll/client_armv8_32hf.so" "$romdir/ports/$md_id/valve/cl_dlls/"
    cp "$md_build/hlsdk/build/dlls/hl_armv8_32hf.so" "$romdir/ports/$md_id/valve/dlls/"
    chown -R $user:$user "$romdir/ports/$md_id/valve/"

    addPort "$md_id" "xash3d-fwgs" "xash3d-fwgs - Half-Life Engine" "pushd $romdir/ports/$md_id/; LD_LIBRARY_PATH=$md_inst $md_inst/xash3d -width 1280 -height 720 -fullscreen -console; popd" 
}

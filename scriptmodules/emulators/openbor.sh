#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="openbor"
rp_module_desc="OpenBOR - Beat 'em Up Game Engine v6510-dev (official!)"
rp_module_help="Place your .pak files in $romdir/openbor."
rp_module_licence="BSD https://raw.githubusercontent.com/crcerror/OpenBOR-Raspberry/master/LICENSE"
rp_module_section="exp"
rp_module_flags="!mali !x11"

function depends_openbor() {
    getDepends libsdl2-gfx-dev libvorbisidec-dev libvpx-dev libogg-dev libsdl2-gfx-1.0-0 libvorbisidec1
}

function sources_openbor() {
    gitPullOrClone "$md_build" https://github.com/crcerror/OpenBOR-Raspberry.git
}

function build_openbor() {
    local params=()
    ! isPlatform "x11" && params+=(BUILD_PANDORA=1)
    make clean-all BUILD_PANDORA=1
    patch -p0 -i ./patch/latest_build.diff
    make "${params[@]}"
    md_ret_require="$md_build/OpenBOR"
    if isPlatform "rpi3"; then
	echo "Fetching libGL.so.1 for Raspberry Pi 3..."
	wget -q --show-progress "http://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/libGL-binary/libGL-for-RPi-3/libGL.so.1"
    elif isPlatform "rpi4"; then
	echo "Fetching libGL.so.1 for Raspberry Pi 4..."
	wget -q --show-progress "http://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/libGL-binary/libGL-for-RPi-4/libGL.so.1"
    elif isPlatform "rpi1"; then
	echo "Fetching libGL.so.1 for Raspberry Pi..."
	wget -q --show-progress "http://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/libGL-binary/libGL-for-RPi-zero/libGL.so.1"
    elif isPlatform "rpi"; then
        echo "Fetching libGL.so.1 for Raspberry Pi..."
        wget -q --show-progress "http://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/libGL-binary/libGL-for-RPi-zero/libGL.so.1"
    else
	error="This script is intended for Raspberry Pis only and will not work on other hardware."
    fi
}

function install_openbor() {
    md_ret_files=(
       'OpenBOR'
       'libGL.so.1'
    )
}

function configure_openbor() {
    mkRomDir "ports/$md_id"

    local dir
    for dir in ScreenShots Saves; do
        mkUserDir "$md_conf_root/$md_id/$dir"
        ln -snf "$md_conf_root/$md_id/$dir" "$md_inst/$dir"
    done

    ln -snf "$romdir/ports/$md_id" "$md_inst/Paks"
    ln -snf "/dev/shm" "$md_inst/Logs"
    addEmulator 0 "$md_id" "openbor" "$md_inst/OpenBOR %ROM%"
    addSystem "openbor"
}

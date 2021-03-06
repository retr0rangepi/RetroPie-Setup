#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="jzintv"
rp_module_desc="Intellivision emulator"
rp_module_help="ROM Extensions: .int .bin\n\nCopy your Intellivision roms to $romdir/intellivision\n\nCopy the required BIOS files exec.bin and grom.bin to $biosdir"
rp_module_licence="GPL2 http://spatula-city.org/%7Eim14u2c/intv/"
rp_module_section="opt"
rp_module_flags=""

function depends_jzintv() {
    getDepends libsdl1.2-dev
}

function sources_jzintv() {
    downloadAndExtract "$__archive_url/jzintv-20181225.zip" "$md_build"
    cd jzintv/src
    # aarch64 doesn't include sys/io.h - we can just remove it in this case
    isPlatform "aarch64" && grep -rl "include.*sys/io.h" | xargs sed -i "/include.*sys\/io.h/d"
}

function build_jzintv() {
    mkdir -p jzintv/bin
    cd jzintv/src
    make clean
    make CC="gcc" CXX="g++" WARN="" WARNXX="" OPT_FLAGS="$CFLAGS"
    md_ret_require="$md_build/jzintv/bin/jzintv"
}

function install_jzintv() {
    md_ret_files=(
        'jzintv/bin'
        'jzintv/src/COPYING.txt'
        'jzintv/src/COPYRIGHT.txt'
    )
}

function configure_jzintv() {
    mkRomDir "intellivision"

    if ! isPlatform "x11"; then
        setDispmanx "$md_id" 1
    fi

    # copy basic QJOYPAD layout - enable gamepad support
    cp -p $md_data/intellivision.lyt /home/pi/.qjoypad3/

    # copy run script with needed parameters + Qjoypad support
    cp -p $md_data/intellivision.sh $md_conf_root/intellivision/

    addEmulator 1 "$md_id" "intellivision" "LD_LIBRARY_PATH=/usr/lib/GLSHIM:/usr/lib startx /opt/retropie/configs/intellivision/intellivision.sh %ROM%"
    addSystem "intellivision"
}

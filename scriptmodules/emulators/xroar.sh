#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="xroar"
rp_module_desc="Dragon / CoCo emulator XRoar"
rp_module_help="ROM Extensions: .cas .wav .bas .asc .dmk .jvc .os9 .dsk .vdk .rom .ccc .sna\n\nCopy your Dragon roms to $romdir/dragon32\n\nCopy your CoCo games to $romdir/coco\n\nCopy the required BIOS files d32.rom (Dragon 32) and bas13.rom (CoCo) to $biosdir"
rp_module_licence="GPL2 http://www.6809.org.uk/xroar/"
rp_module_section="opt"
rp_module_flags=""

function depends_xroar() {
    getDepends libsdl1.2-dev automake texinfo
}

function sources_xroar() {
    gitPullOrClone "$md_build" http://www.6809.org.uk/git/xroar.git 0.35.4
}

function build_xroar() {
    local params=(--without-gtk2 --without-gtkgl)
    if ! isPlatform "x11"; then
        params+=(--without-pulse)
    fi
    ./autogen.sh
    ./configure --prefix="$md_inst" "${params[@]}"
    make clean
    make
    md_ret_require="$md_build/src/xroar"
}

function install_xroar() {
    make install
}

function configure_xroar() {
    mkRomDir "dragon32"
    mkRomDir "coco"

    mkdir -p "$md_inst/share/xroar"
    ln -snf "$biosdir" "$md_inst/share/xroar/roms"

    # copy basic QJOYPAD layout - enable gamepad support
    cp -p $md_data/dragon_coco.lyt /home/pi/.qjoypad3/

    # copy run script with needed parameters + Qjoypad support
    cp -p $md_data/dragon32.sh $md_conf_root/dragon32/
    cp -p $md_data/{coco.sh,cocous.sh} $md_conf_root/coco/

    local params=(-fs)
    ! isPlatform "x11" && params+=(-vo sdlgl -ao sdl --ccr simple)
    addEmulator 1 "$md_id-dragon32" "dragon32" "LD_LIBRARY_PATH=/usr/lib/GLSHIM:/usr/lib startx $md_conf_root/dragon32/dragon32.sh %ROM%"
    addEmulator 1 "$md_id-cocous" "coco" "LD_LIBRARY_PATH=/usr/lib/GLSHIM:/usr/lib startx $md_conf_root/coco/cocous.sh %ROM%"
    addEmulator 0 "$md_id-coco" "coco" "LD_LIBRARY_PATH=/usr/lib/GLSHIM:/usr/lib startx $md_conf_root/coco/coco.sh %ROM%"
    addSystem "dragon32"
    addSystem "coco"
}

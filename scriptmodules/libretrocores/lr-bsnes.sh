#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-bsnes"
rp_module_desc="Super Nintendo Emulator - bsnes port for libretro with added SGB support (v115)"
rp_module_help="ROM Extensions: .7z .bml .gb .gbc .sgb .smc .sfc .zip\n\nCopy your SNES roms to $romdir/snes\nCopy your SGB roms to $romdir/sgb\n\nPlace SGB BIOS named Super Game Boy (World\) (Rev 2).sfc into your BIOS directory."
rp_module_licence="GPL3 https://raw.githubusercontent.com/libretro/bsnes/master/LICENSE.txt"
rp_module_section="opt"
rp_module_flags="!armv6"

function depends_lr-bsnes() {
    if compareVersions $__gcc_version lt 7; then
        md_ret_errors+=("You need an OS with gcc 7 or newer to compile $md_id")
        return 1
    fi
}

function sources_lr-bsnes() {
    gitPullOrClone "$md_build" https://github.com/libretro/bsnes.git
}

function build_lr-bsnes() {
    local params=(target="libretro" build="release" binary="library")
    make -C bsnes clean "${params[@]}"
    make -C bsnes "${params[@]}"
    md_ret_require="$md_build/bsnes/out/bsnes_libretro.so"
}

function install_lr-bsnes() {
    md_ret_files=(
        'bsnes/out/bsnes_libretro.so'
        'LICENSE.txt'
        'GPLv3.txt'
        'CREDITS.md'
        'README.md'
    )
}

function configure_lr-bsnes() {
    mkRomDir "snes"
    ensureSystemretroconfig "snes"

    addEmulator 1 "$md_id" "snes" "$md_inst/bsnes_libretro.so"
    addSystem "snes"

    mkRomDir "sgb"
    ensureSystemretroconfig "sgb"
    addEmulator 1 "$md_id" "sgb" "$md_inst/bsnes_libretro.so %ROM% --subsystem sgb /home/pi/RetroPie/BIOS/Super\ Game\ Boy\ \(World\)\ \(Rev\ 2\).sfc"

    # We have to correct the addEmulator line specifically for SGB roms as the order of ROM and BIOS file is switched in this core for some reason...
    sed -i.bak '/^lr-bsnes =/ s/ %ROM%//2' /opt/retropie/configs/sgb/emulators.cfg
    addSystem "sgb" "Super Game Boy" ".gb .gbc .sgb .zip .7z"
}

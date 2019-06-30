#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="amiberry"
rp_module_desc="Amiga emulator with JIT support (forked from uae4arm)"
rp_module_help="ROM Extension: .adf\n\nCopy your Amiga games to $romdir/amiga\n\nCopy the required BIOS files\nkick13.rom\nkick20.rom\nkick31.rom\nto $biosdir"
rp_module_licence="GPL3 https://raw.githubusercontent.com/midwan/amiberry/master/COPYING"
rp_module_section="main"
rp_module_flags="!x86"

function depends_amiberry() {
    local depends=(libpng12-dev libmpeg2-4-dev zlib1g-dev)
    if ! isPlatform "rpi" || isPlatform "kms" || isPlatform "vero4k"; then
        depends+=(libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev)
    fi

    if isPlatform "vero4k"; then
        depends+=(vero3-userland-dev-osmc libmpg123-dev libxml2-dev libflac-dev)
        getDepends "${depends[@]}"
    else
        depends_uae4arm "${depends[@]}"
    fi
}

function sources_amiberry() {
    gitPullOrClone "$md_build" https://github.com/midwan/amiberry/
    applyPatch "$md_data/01_remove_cflags.diff"
}

function build_amiberry() {
    local amiberry_bin="$__platform-sdl2"
    local amiberry_platform="$__platform-sdl2"
    if isPlatform "rpi" && ! isPlatform "kms"; then
        amiberry_bin="$__platform-sdl1"
        amiberry_platform="$__platform"
    elif isPlatform "odroid-xu"; then
        amiberry_bin="xu4"
        amiberry_platform="xu4"
    elif isPlatform "tinker"; then
        amiberry_bin="tinker"
        amiberry_platform="tinker"
    elif isPlatform "vero4k"; then
        amiberry_bin="vero4k"
        amiberry_platform="vero4k"
    elif isPlatform "H3-mali"; then
        amiberry_bin="orangepi-pc"
        amiberry_platform="orangepi-pc"
    fi
    
    make clean
    CXXFLAGS="" make -j4 PLATFORM="$amiberry_platform"
    ln -sf "amiberry-$amiberry_bin" "amiberry"
    md_ret_require="$md_build/amiberry-$amiberry_bin"
}

function install_amiberry() {
    local amiberry_bin="$__platform-sdl2"
    if isPlatform "rpi" && ! isPlatform "kms"; then
        amiberry_bin="$__platform-sdl1"
    elif isPlatform "odroid-xu"; then
        amiberry_bin="xu4"
    elif isPlatform "tinker"; then
        amiberry_bin="tinker"
    elif isPlatform "vero4k"; then
        amiberry_bin="vero4k"
    elif isPlatform "H3-mali"; then
        amiberry_bin="orangepi-pc"
        
    fi

    md_ret_files=(
        'amiberry'
        "amiberry-$amiberry_bin"
        'data'
    )

    cp -R "$md_build/whdboot" "$md_inst/whdboot-dist"

}

function configure_amiberry() {

    mkRomDir "amiga"
    # moving previous emulator configs
    mv "$md_conf_root/amiga/emulators.cfg" /home/pi/temp
    mkUserDir "$md_conf_root/amiga"
    mkUserDir "$md_conf_root/amiga/$md_id"

    # move config / save folders to $md_conf_root/amiga/$md_id
    local dir
    for dir in conf savestates screenshots; do
        moveConfigDir "$md_inst/$dir" "$md_conf_root/amiga/$md_id/$dir"
    done

    # and kickstart dir (removing old symlinks first)
    if [[ ! -h "$md_inst/kickstarts" ]]; then
        rm -f "$md_inst/kickstarts/"{kick12.rom,kick13.rom,kick20.rom,kick31.rom}
    fi
    moveConfigDir "$md_inst/kickstarts" "$biosdir"

    local conf="$(mktemp)"
    iniConfig "=" "" "$conf"
    iniSet "config_description" "RetroPie A500, 68000, OCS, 512KB Chip + 512KB Slow Fast"
    iniSet "chipmem_size" "1"
    iniSet "bogomem_size" "2"
    iniSet "chipset" "ocs"
    iniSet "cachesize" "0"
    iniSet "kickstart_rom_file" "\$(FILE_PATH)/kick13.rom"
    copyDefaultConfig "$conf" "$md_conf_root/amiga/$md_id/conf/rp-a500.uae"
    rm "$conf"

    conf="$(mktemp)"
    iniConfig "=" "" "$conf"
    iniSet "config_description" "RetroPie A1200, 68EC020, AGA, 2MB Chip"
    iniSet "chipmem_size" "4"
    iniSet "finegrain_cpu_speed" "1024"
    iniSet "cpu_type" "68ec020"
    iniSet "cpu_model" "68020"
    iniSet "chipset" "aga"
    iniSet "cachesize" "0"
    iniSet "kickstart_rom_file" "\$(FILE_PATH)/kick31.rom"
    copyDefaultConfig "$conf" "$md_conf_root/amiga/$md_id/conf/rp-a1200.uae"
    rm "$conf"

    # copy launch script (used for uae4arm and amiberry)
    sed "s/EMULATOR/$md_id/" "$scriptdir/scriptmodules/$md_type/uae4arm/uae4arm.sh" >"$md_inst/$md_id.sh"
    chmod a+x "$md_inst/$md_id.sh"

    local script="+Start UAE4Arm.sh"
    [[ "$md_id" == "amiberry" ]] && script="+Start Amiberry.sh"
    rm -f "$romdir/amiga/$script"
    if [[ "$md_mode" == "install" ]]; then
        cat > "$romdir/amiga/$script" << _EOF_
#!/bin/bash
$md_inst/$md_id.sh
_EOF_
        chmod a+x "$romdir/amiga/$script"
        chown $user:$user "$romdir/amiga/$script"
    fi

    # symlink the retroarch config / autoconfigs for amiberry to use
    ln -sf "$configdir/all/retroarch/autoconfig" "$md_inst/controllers"
    ln -sf "$configdir/all/retroarch.cfg" "$md_inst/conf/retroarch.cfg"

    local config_dir="$md_conf_root/amiga/$md_id"

    # create whdboot config area
    moveConfigDir "$md_inst/whdboot" "$config_dir/whdboot"

    # move hostprefs.conf from previous location
    if [[ -f "$config_dir/conf/hostprefs.conf" ]]; then
        mv "$config_dir/conf/hostprefs.conf" "$config_dir/whdboot/hostprefs.conf"
    fi

    # whdload auto-booter user config - copy default configuration
    copyDefaultConfig "$md_inst/whdboot-dist/hostprefs.conf" "$config_dir/whdboot/hostprefs.conf"

    # copy game-data, save-data folders, boot-data.zip and WHDLoad
    cp -R "$md_inst/whdboot-dist/"{game-data,save-data,boot-data.zip,WHDLoad} "$config_dir/whdboot/"

    chown -R $user:$user "$config_dir/whdboot"

    addEmulator 1 "$md_id" "amiga" "$md_inst/$md_id.sh auto %ROM%"
    addEmulator 1 "$md_id-a500" "amiga" "$md_inst/$md_id.sh rp-a500.uae %ROM%"
    addEmulator 1 "$md_id-a1200" "amiga" "$md_inst/$md_id.sh rp-a1200.uae %ROM%"
    addSystem "amiga"

}

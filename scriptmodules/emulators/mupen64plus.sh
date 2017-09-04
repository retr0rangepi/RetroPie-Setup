#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="mupen64plus"
rp_module_desc="N64 emulator MUPEN64Plus"
rp_module_help="ROM Extensions: .z64 .n64 .v64\n\nCopy your N64 roms to $romdir/n64"
rp_module_licence="GPL2 https://raw.githubusercontent.com/mupen64plus/mupen64plus-core/master/LICENSES"
rp_module_section="main"

function sources_mupen64plus() {
    #Let's add Odroid repository for best compatibility with RetrOrangePi
    rm -rf /etc/apt/sources.list.d/meveric-jessie-main.list
    cd /etc/apt/sources.list.d/
    wget https://oph.mdrjr.net/meveric/sources.lists/meveric-jessie-main.list
    wget -O- http://oph.mdrjr.net/meveric/meveric.asc | apt-key add -
    aptUpdate
}

function install_bin_mupen64plus() {
    aptInstall mupen64plus-odroid
    #Cleaning the repositories
    rm -rf /etc/apt/sources.list.d/meveric-jessie-main.list
}

function remove_mupen64plus() {
    aptRemove mupen64plus-odroid
}

function configure_mupen64plus() {
    addEmulator 1 "${md_id}-gles2rice$name" "n64" "/usr/local/bin/mupen64plus.sh mupen64plus-video-rice %ROM%"
    addEmulator 0 "${md_id}-glide64mk2" "n64" "/usr/local/bin/mupen64plus.sh mupen64plus-video-glide64mk2 %ROM%"
    addSystem "n64"
    mkRomDir "n64"

    [[ "$md_mode" == "remove" ]] && return

    # copy hotkey remapping start script
    cp "$md_data/mupen64plus.sh" "/usr/local/bin/"
    chmod +x "/usr/local/bin/mupen64plus.sh"

    mkUserDir "$md_conf_root/n64/"

    # Copy config files
    cp -v "/usr/local/share/mupen64plus/"{*.ini,font.ttf} "$md_conf_root/n64/"

    local config="$md_conf_root/n64/mupen64plus.cfg"
    local cmd="/usr/local/bin/mupen64plus --configdir $md_conf_root/n64 --datadir $md_conf_root/n64"

    # if the user has an existing mupen64plus config we back it up, generate a new configuration
    # copy that to rp-dist and put the original config back again. We then make any ini changes
    # on the rp-dist file. This preserves any user configs from modification and allows us to have
    # a default config for reference
    if [[ -f "$config" ]]; then
        mv "$config" "$config.user"
        su "$user" -c "$cmd"
        mv "$config" "$config.rp-dist"
        mv "$config.user" "$config"
        config+=".rp-dist"
    else
        su "$user" -c "$cmd"
    fi

    addAutoConf mupen64plus_hotkeys 1
    addAutoConf mupen64plus_texture_packs 1

    chown -R $user:$user "$md_conf_root/n64"
}

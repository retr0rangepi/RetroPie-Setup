#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="dosbox-sdl2"
rp_module_desc="DOS emulator (enhanced DOSBox fork)"
rp_module_help="ROM Extensions: .bat .com .exe .sh .conf\n\nCopy your DOS games to $romdir/pc"
rp_module_licence="GPL2 https://sourceforge.net/p/dosbox/code-0/HEAD/tree/dosbox/trunk/COPYING"
rp_module_section="exp"

function depends_dosbox-sdl2() {
    local depends=(libsdl2-net-dev libfluidsynth-dev fluid-soundfont-gm libglew-dev)
    depends_dosbox "${depends[@]}"
}

function sources_dosbox-sdl2() {
    gitPullOrClone "$md_build" "https://github.com/duganchen/dosbox.git"
    # use custom config filename & path to allow coexistence with regular dosbox
    sed -i "src/misc/cross.cpp" -e 's/~\/.dosbox/~\/.'$md_id'/g' \
       -e 's/DEFAULT_CONFIG_FILE "dosbox-"/DEFAULT_CONFIG_FILE "'$md_id'-"/g'
}

function build_dosbox-sdl2() {
    ./autogen.sh
    ./configure --prefix="$md_inst"
    rpSwap on 1024
    sed -i -e 's|/usr/local/include/SDL2|/usr/include/SDL2|g' src/gui/Makefile
    make clean
    make -j2
    md_ret_require="$md_build/src/dosbox"
    rpSwap off
}

function install_dosbox-sdl2() {
    make install
    md_ret_require="/opt/retropie/emulators/dosbox-sdl2/bin/dosbox"
}

function configure_dosbox-sdl2() {
    if [[ "$md_id" == "dosbox-sdl2" ]]; then
        local def="0"
        local launcher_name="+Start DOSBox-SDL2.sh"
        local needs_synth="0"
    else
        local def="1"
        local launcher_name="+Start DOSBox.sh"
        # needs software synth for midi; limit to Pi for now
        if isPlatform "rpi"; then
            local needs_synth="1"
        fi
    fi

    mkRomDir "pc"
    rm -f "$romdir/pc/$launcher_name"
    if [[ "$md_mode" == "install" ]]; then
        cat > "$romdir/pc/$launcher_name" << _EOF_
#!/bin/bash
[[ ! -n "\$(aconnect -o | grep -e TiMidity -e FluidSynth)" ]] && needs_synth="$needs_synth"
function midi_synth() {
    [[ "\$needs_synth" != "1" ]] && return
    case "\$1" in
        "start")
            timidity -Os -iAD &
            until [[ -n "\$(aconnect -o | grep TiMidity)" ]]; do
                sleep 1
            done
            ;;
        "stop")
            killall timidity
            ;;
        *)
            ;;
    esac
}
params=("\$@")
if [[ -z "\${params[0]}" ]]; then
    params=(-c "@MOUNT C $romdir/pc" -c "@C:")
elif [[ "\${params[0]}" == *.sh ]]; then
    midi_synth start
    bash "\${params[@]}"
    midi_synth stop
    exit
elif [[ "\${params[0]}" == *.conf ]]; then
    params=(-userconf -conf "\${params[@]}")
else
    params+=(-exit)
fi
midi_synth start
"$md_inst/bin/dosbox" "\${params[@]}"
midi_synth stop
_EOF_
    chmod +x "$romdir/pc/+Start DOSBox-SDL2.sh"
    chown $user:$user "$romdir/pc/+Start DOSBox-SDL2.sh"

    if [[ "$md_mode" == "install" ]]; then
        local config_path=$(su "$user" -c "\"$md_inst/bin/dosbox\" -printconf")
        if [[ -f "$config_path" ]]; then
            iniConfig "=" "" "$config_path"
            iniSet "fluid.driver" "alsa"
            iniSet "fluid.soundfont" "/usr/share/sounds/sf2/FluidR3_GM.sf2"
            iniSet "fullresolution" "desktop"
            iniSet "fullscreen" "true"
            iniSet "mididevice" "fluidsynth"
            iniSet "output" "texture"
            iniDel "usescancodes"
            isPlatform "kms" && iniSet "vsync" "true"
        fi
    fi
fi
    moveConfigDir "$home/.$md_id" "$md_conf_root/pc"

    addEmulator "$def" "$md_id" "pc" "$romdir/pc/${launcher_name// /\\ } %ROM%"
    addSystem "pc"
}

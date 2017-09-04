#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="scummvm"
rp_module_desc="ScummVM"
rp_module_help="Copy your ScummVM games to $romdir/scummvm"
rp_module_licence="GPL2 https://raw.githubusercontent.com/scummvm/scummvm/master/COPYING"
rp_module_section="opt"
rp_module_flags=""

function _update_hook_scummvm() {
    # to show as installed in retropie-setup 4.x
    hasPackage scummvm && mkdir -p "$md_inst" && mkdir -p "$md_inst/bin"
}

function install_bin_scummvm() {
    aptInstall scummvm
    mkdir -p "$md_inst" && mkdir -p "$md_inst/bin" && mkdir -p "$md_inst/extra"
    ln -snf /usr/games/scummvm "$md_inst/bin/scummvm"
}

function remove_scummvm() {
    aptRemove scummvm
}
function configure_scummvm() {
    mkRomDir "scummvm"

    local dir
    mkUserDir "$home/.local"
    for dir in .config .local/share .cache; do
        mkUserDir "$home/$dir"
        moveConfigDir "$home/$dir/scummvm" "$md_conf_root/scummvm"
    done

    # Create startup script
    rm -f "$romdir/scummvm/+Launch GUI.sh"
    local name="ScummVM"
    [[ "$md_id" == "scummvm-sdl1" ]] && name="ScummVM-SDL1"
    cat > "$romdir/scummvm/+Start_$name.sh" << _EOF_
#!/bin/bash
game="\$1"
pushd "$romdir/scummvm" >/dev/null
$md_inst/bin/scummvm --fullscreen --joystick=0 --extrapath="$md_inst/extra" \$game
while read line; do
    id=(\$line);
    touch "$romdir/scummvm/\$id.svm"
done < <($md_inst/bin/scummvm --list-targets | tail -n +3)
popd >/dev/null
_EOF_
    chown $user:$user "$romdir/scummvm/+Start_$name.sh"
    chmod u+x "$romdir/scummvm/+Start_$name.sh"

    addEmulator 1 "$md_id" "scummvm" "LD_LIBRARY_PATH=/home/pi/GL:/usr/lib startx $romdir/scummvm/+Start_$name.sh %BASENAME%"
    addSystem "scummvm"
}

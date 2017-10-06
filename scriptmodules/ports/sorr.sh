#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="sorr"
rp_module_desc="Streets of Rage Remake"
rp_module_help="Please copy your Streets of Rage Remake installation files into $md_inst."
rp_module_section="exp"
rp_module_flags="!x86 !x11"

function sources_sorr() {
        # get BennuGD Engine - original download site: http://forum.bennugd.org/index.php?action=dlattach;topic=4281.0;attach=3564
        # copy BennuGD-rpi-v333.zip to /home/pi
        unzip -j -o ~/BennuGD-rpi-v333.zip 
    getDepends libsdl-mixer1.2
}

function install_sorr() {
    md_ret_files=(
    'bgdi-333'
    )
}

function configure_sorr() {
    mkRomDir "ports"
    chmod 755 "$md_inst/bgdi-333"
    moveConfigFile "$md_inst/savegame" "$md_conf_root/$md_id/"
    addPort "$md_id" "sorr" "Streets of Rage Remake" "pushd $md_inst; LD_LIBRARY_PATH=/usr/lib startx ./bgdi-333 ./SorR.dat; popd"
}

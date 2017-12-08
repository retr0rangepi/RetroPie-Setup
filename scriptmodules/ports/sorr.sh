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
rp_module_help="Subscribe to BennuGD forum, download BennuGD-rpi-v333.zip to $romdir/ports before running this script. Please copy SorR.dat and mod/palettes files into $romdir/ports/sorr/ after installation."
rp_module_section="exp"
rp_module_flags="!x86 !x11"

function sources_sorr() {
        # get BennuGD Engine - original download site: http://forum.bennugd.org/index.php?action=dlattach;topic=4281.0;attach=3564
        # copy BennuGD-rpi-v333.zip to /home/pi/RetroPie/roms/ports
        unzip -j -o /home/pi/RetroPie/roms/ports/BennuGD-rpi-v333.zip
        getDepends libsdl-mixer1.2
}

function install_sorr() {
    md_ret_files=(
    'bgdi-333'
    )
}

function configure_sorr() {
    mkRomDir "ports/sorr"
    chmod 755 "$md_inst/bgdi-333"
    moveConfigFile "$md_inst/savegame" "$md_conf_root/$md_id/"
    addPort "$md_id" "sorr" "Streets of Rage Remake" "pushd $romdir/ports/$md_id/; LD_LIBRARY_PATH=/usr/lib/GLSHIM:/usr/lib startx $md_inst/bgdi-333 ./SorR.dat; popd"
}

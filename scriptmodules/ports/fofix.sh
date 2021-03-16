#!/usr/bin/env bash
 
# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#
 
rp_module_id="fofix"
rp_module_desc="FoFix - Guitar Hero and Rock Band clone"
rp_module_licence="GPL2 https://raw.githubusercontent.com/fofix/fofix/master/COPYING"
rp_module_section="exp"
rp_module_flags="!mali !x86"
 
function depends_fofix() {
    getDepends cmake xorg
}

function sources_fofix() {
    if [ ! -f "/opt/retropie/supplementary/glshim/libGL.so.1" ]; then
        gitPullOrClone "$md_build/glshim" https://github.com/ptitseb/glshim.git
    fi
}
 
function build_fofix() {
    if [ ! -f "/opt/retropie/supplementary/glshim/libGL.so.1" ]; then
        cd "$md_build/glshim"
        cmake . -DBCMHOST=1
        make GL
    fi
}

function install_bin_fofix() {
    aptInstall fofix
    if [ ! -f "/opt/retropie/supplementary/glshim/libGL.so.1" ]; then
       mkdir -p /opt/retropie/supplementary/glshim/
       cp "$md_build/glshim/lib/libGL.so.1" /opt/retropie/supplementary/glshim/
    fi
}
 
function configure_fofix() {
    mkdir "ports"
    moveConfigDir "$home/.fofix" "$md_conf_root/$md_id"
    addPort "$md_id" "fofix" "FoFix - Guitar Hero and Rock Band clone" "LD_LIBRARY_PATH=/opt/retropie/supplementary/glshim LIBGL_FB=1 xinit fofix"
}

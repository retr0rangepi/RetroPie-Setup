#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="mpv"
rp_module_desc="mpv - Video Player"
rp_module_help="This will set up TV Shows and Movies as systems on your wheel. You can throw your tv shows into $romdir/tvshows and your movies into $romdir/movies or even mount your network drives to play remotely.\n\nROM Extensions: .avi .m4v .mkv .mov .mp4 .mpg .wmv"
rp_module_licence="GPL2 https://raw.githubusercontent.com/mpv-player/mpv/master/Copyright"
rp_module_section="exp"
rp_module_flags="!mali !x86"

function install_bin_mpv() {
    aptInstall mpv
}

function configure_mpv() {
    mkRomDir "movies"
    mkRomDir "tvshows"

    addEmulator 0 "$md_id" "movies" "$md_inst/mpv %ROM%" ".avi .m4v .mkv .mov .mp4 .mpg .wmv .AVI .M4V .MKV .MOV .MP4 .MPG .WMV"
    addEmulator 0 "$md_id" "tvshows" "$md_inst/mpv %ROM%" ".avi .m4v .mkv .mov .mp4 .mpg .wmv .AVI .M4V .MKV .MOV .MP4 .MPG .WMV"
    addSystem "movies"
    addSystem "tvshows"
}

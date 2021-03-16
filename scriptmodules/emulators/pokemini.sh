
#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="pokemini"
rp_module_desc="Pokemini - Pokemon Mini emulator"
rp_module_help="ROM Extensions: .min .MIN\n\nYou will need to add the ROM extensions above to your /etc/emulationstation/es_systems.cfg file manually."
rp_module_licence="GPL https://sourceforge.net/p/pokemini/code/ci/master/tree/LICENSE"
rp_module_section="exp"
rp_module_flags="!mali !kms"

function depends_pokemini() {
    getDepends zlib1g zlib1g-dev libsdl2-dev
}

function sources_pokemini() {
    gitPullOrClone "$md_build"  https://git.code.sf.net/p/pokemini/code
}

function build_pokemini() {
    cd platform/sdl2
    make
    md_ret_require="$md_build/platform/sdl2/PokeMini"
}

function install_pokemini() {
    md_ret_files=(
        'platform/sdl2/PokeMini'
    )

}

function configure_pokemini() {
    mkRomDir "pokemini"

    addEmulator 1 "pokemini" "pokemini" "$md_inst/PokeMini -fullscreen %ROM%"
    addSystem "pokemini"
}

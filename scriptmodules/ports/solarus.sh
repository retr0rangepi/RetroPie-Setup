#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="solarus"
rp_module_desc="solarus - A lightweight, free and open-source game engine for Action-RPGs"
rp_module_help="Copy your Solarus quests (games) to $romdir/solarus"
rp_module_licence="GPL3 https://gitlab.com/solarus-games/solarus/raw/dev/license.txt"
rp_module_repo="git https://gitlab.com/solarus-games/solarus.git master"
rp_module_section="opt"
rp_module_flags="!aarch64"

function _options_cfg_file_solarus() {
    echo "$md_conf_root/solarus/options.cfg"
}

function depends_solarus() {
    # ref: https://gitlab.com/solarus-games/solarus/blob/dev/compilation.md
    local depends=(
        cmake pkg-config
	libsdl2-image-dev libsdl2-ttf-dev
        libopenal-dev libvorbis-dev libogg-dev
        libmodplug-dev libphysfs-dev libglm-dev
        libluajit-5.1-dev
    )
    isPlatform "videocore" && depends+=(libraspberrypi-dev)
    getDepends "${depends[@]}"
}

function sources_solarus() {
    gitPullOrClone
}

function build_solarus() {
    local params=(
        -DSOLARUS_GUI=OFF -DSOLARUS_TESTS=OFF -DSOLARUS_FILE_LOGGING=OFF
        -DSOLARUS_LIBRARY_INSTALL_DESTINATION="$md_inst/lib"
        -DCMAKE_INSTALL_PREFIX="$md_inst"
        -DCMAKE_INSTALL_RPATH="$md_inst/lib"
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
    )
    isPlatform "gles" && params+=(-DSOLARUS_GL_ES=ON)
    rm -rf build
    mkdir build
    cd build
    cmake "${params[@]}" ..
    make -j4
    md_ret_require=(
        "$md_build/build/solarus-run"
    )
}

function install_solarus() {
    cd build
    make install/strip
}

function configure_solarus() {
    addEmulator 1 "$md_id" "solarus" "$md_inst/solarus.sh %ROM%"
    addSystem "solarus"
    moveConfigDir "$home/.solarus" "$configdir/solarus"
    [[ "$md_mode" == "remove" ]] && return

    # ensure rom dir exists
    mkRomDir "solarus"

    # create launcher for Solarus that:
    # * starts in fullscreen mode
    # * disables mouse cursor, the JACK driver in OpenAL and the Lua console
    # * configures the joypad deadzone and quit combo options
    # * preloads the legacy videocore GLES2 driver (if necessary)
    cat > "$md_inst/solarus.sh" << _EOF_
#!/usr/bin/env bash
export ALSOFT_DRIVERS="-jack,"
ARGS=("-fullscreen=yes" "-cursor-visible=no" "-lua-console=no")
[[ -f "$(_options_cfg_file_solarus)" ]] && source "$(_options_cfg_file_solarus)"
[[ -n "\$JOYPAD_DEADZONE" ]] && ARGS+=("-joypad-deadzone=\$JOYPAD_DEADZONE")
[[ -n "\$QUIT_COMBO" ]] && ARGS+=("-quit-combo=\$QUIT_COMBO")
if $(isPlatform "videocore" && echo true || echo false); then
  if [[ -f /opt/vc/lib/libbrcmGLESv2.so ]]; then
    export LD_PRELOAD="/opt/vc/lib/libbrcmGLESv2.so"
  fi
fi
exec "$md_inst"/bin/solarus-run "\${ARGS[@]}" "\$@"
_EOF_
    chmod +x "$md_inst/solarus.sh"
}

function install_esthemes_solarus() {
    local -r esthemes_url="https://gitlab.com/solarus-games/solarus-design/-/archive/master/solarus-design-master.tar.gz"
    local -r esthemes_dir="/etc/emulationstation/themes"
    local theme

    # download and extract solarus-design files and copy EmulationStation theme assets for installed themes
    downloadAndExtract "$esthemes_url" "$__tmpdir/solarus-esthemes" --strip-components 1
    for theme in "$__tmpdir/solarus-esthemes/emulationstation_art"/*; do
        if [[ -d "$esthemes_dir/${theme##*/}" ]]; then
            cp -rv "$theme/theme" "$esthemes_dir/${theme##*/}/solarus"
        fi
    done
    rm -rf "$__tmpdir/solarus-esthemes"
}

function uninstall_esthemes_solarus() {
    local -r esthemes_dir="/etc/emulationstation/themes"
    local theme
    for theme in "$esthemes_dir"/*; do
        if [[ -d "$theme/solarus" ]]; then
            rm -rf "$theme/solarus"
        fi
    done
}

function gui_solarus() {
    local options=()
    local default
    local cmd
    local choice
    local joypad_deadzone
    local quit_combo

    # initialise options config file
    iniConfig "=" "\"" "$(_options_cfg_file_solarus)"

    # start the menu gui
    default="D"
    while true; do
        # read current options
        iniGet "JOYPAD_DEADZONE" && joypad_deadzone="$ini_value"
        iniGet "QUIT_COMBO" && quit_combo="$ini_value"

        # create menu options
        options=(
            D "Set joypad axis deadzone (${joypad_deadzone:-default})"
            Q "Set joypad quit buttons combo (${quit_combo:-unset})"
            I "Install theme assets for EmulationStation"
            U "Uninstall theme assets for EmulationStation"
        )

        # show main menu
        cmd=(dialog --backtitle "$__backtitle" --default-item "$default" --menu "Choose an option" 16 60 16)
        choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        case "$choice" in
            D)
                cmd=(dialog --backtitle "$__backtitle" --inputbox "Please enter a joypad axis deadzone value between 0-32767, higher is less sensitive (leave BLANK to use engine default)" 10 65)
                choice=$("${cmd[@]}" 2>&1 >/dev/tty)
                if [[ $? -eq 0 ]]; then
                    if [[ -n "$choice" ]]; then
                        iniSet "JOYPAD_DEADZONE" "$choice"
                    else
                        iniDel "JOYPAD_DEADZONE"
                    fi
                    chown $user:$user "$(_options_cfg_file_solarus)"
                fi
                ;;
            Q)
                cmd=(dialog --backtitle "$__backtitle" --inputbox "Please enter joypad button numbers to use for quitting separated by '+' signs (leave BLANK to unset)\n\nTip: use 'jstest' to find button numbers for your joypad" 12 65)
                choice=$("${cmd[@]}" 2>&1 >/dev/tty)
                if [[ $? -eq 0 ]]; then
                    if [[ -n "$choice" ]]; then
                        iniSet "QUIT_COMBO" "$choice"
                    else
                        iniDel "QUIT_COMBO"
                    fi
                    chown $user:$user "$(_options_cfg_file_solarus)"
                fi
                ;;
            I)
                if dialog --yesno "Are you sure you want to download and install the theme assets?" 8 40 2>&1 >/dev/tty; then
                    install_esthemes_solarus
                fi
                ;;
            U)
                if dialog --defaultno --yesno "Are you sure you want to uninstall the theme assets?" 8 40 2>&1 >/dev/tty; then
                    uninstall_esthemes_solarus
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

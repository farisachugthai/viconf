#!/usr/bin/env bash
# Maintainer: Faris Chugthai

set -euo pipefail

log() {
    local yellow="\e[0;33m"
    local magenta="\e[0;35m"
    local red="\e[0;31m"
    local reset="\e[0;0m"
    printf "$magenta>$red>$yellow>$reset %s\n" "$*" 1>&2
}

setup_plug() {
    log "Installing vim-plug"
    if [[ -z "$HOME/.local/share/nvim/site/autoload/plug.vim" ]]; then
        curl -fLo "$HOME/.local/share/nvim/autoload/plug.vim" --create-dirs \
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    else
        nvim -c"PlugInstall!" -c"PlugUpgrade!" -c "UpdateRemotePlugins" -c"qa"
    fi
}

setup_nvim() {
    local dist
    if [[ -n $ANDROID_ROOT ]]; then
        dist="apt install"
    else
        dist="sudo apt update && sudo apt install"
    fi
    log "Installing neovim"
    $dist neovim;
    # assume they have pip and use user for easier permissions
    # ahhh but --user fails in virtualenvs goddamnit
    # pip3 install -U --user pynvim
}

setup_pynvim() {
    if [[ -n $VIRTUAL_ENV ]]; then
        pip3 install -U pynvim
    else
        pip3 install -U --user pynvim
    fi
    log "Done installing pynvim!"
    log "We're all set up!"
}

setup_nvim

setup_plug

setup_pynvim

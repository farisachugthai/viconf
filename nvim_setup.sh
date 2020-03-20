#!/usr/bin/env bash
# Maintainer: Faris Chugthai

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
    fi
    nvim -c"PlugInstall!" -c"PlugUpgrade!" -c "UpdateRemotePlugins" -c"qa" &
}

update_pkgs() {
    local update
    if [[ -n $ANDROID_ROOT ]]; then
        update="apt update"
    else
        update="sudo apt update"
    fi
    log "Updating packages"
    $update;
}

install_nvim() {
    local install
    if [[ -n $ANDROID_ROOT ]]; then
        install="apt install neovim"
    else
        install="sudo apt install neovim nvim-qt"
    fi
    log "Installing neovim"
    $install;
}

setup_pynvim() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        python3 -m pip install -U pynvim
    else
        python3 -m pip install -U --user pynvim
    fi
    log "Done installing pynvim!"
    log "We're all set up!"
}

notify() {
    if [[ -z "$(command -v termux-notification)" ]]; then
        return
    fi

    if [[ -n "$1" ]]; then
        echo "$1" | termux-notification
    fi
}

update_pkgs

install_nvim

setup_plug

setup_pynvim

$notify "Pynvim done updating."

#!/usr/bin/env bash
# Vim: set ff=unix: 

# Set up vim
if ! [[ -d "$HOME/.vim/autoload" ]]; then
    mkdir -pv "$HOME/.vim/autoload"
fi

if ! [[ -f "$HOME/.vim/autoload/plug.vim" ]]; then
    curl -sSLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if ! [[ "$(command -v pip)" ]]; then
    if ! [[ "$EUID" == 0 ]]; then
        echo -e 'You must install pip in the python3-pip package but you are
        \ not a root user.'
        exit 1
    else
        apt install python3-pip
    fi
fi

if [[ "$(command -v conda)" ]]; then
    # TODO: Use condashlvl to determine if they activated the env yet
    # Use condaprefix to see if its in an env named neovim.
    # If not offer to create one.
    conda install neovim
else
    # I believe something in sys.exec_prefix can let us figure out if we're in a venv
    pip install -U neovim
fi

# Set up neovim

if ! [[ -d "$HOME/.local/share/nvim/site/autoload" ]]; then
    mkdir -pv "$HOME/.local/share/nvim/site/autoload"
fi

ln -s "$HOME/.vim/autoload/plug.vim" "$HOME/.local/share/nvim/site/autoload"

nvim +'PlugInstall +UpdateRemotePlugins +qall'

exit 0

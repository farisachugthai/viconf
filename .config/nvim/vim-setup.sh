#!/usr/bin/env bash
# Works well enough after having tested it on Ubuntu on WSL. Ran into some errors but that's likely a product of the fact that we can't interactively work with the user

# Set up vim-plug
if ! [[ -d "$HOME/.vim/autoload" ]]; then
    mkdir -pv "$HOME/.vim/autoload"
fi

# It won't make undofiles otherwise!
if ! [[ -d "$HOME/.vim/undodir" ]]; then
    mkdir -pv "$HOME/.vim/undodir"
fi

# Download vim plug
if ! [[ -f "$HOME/.vim/autoload/plug.vim" ]]; then
    curl -sSLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# TODO: Check what os and arch we have.

# if ! [[ "$(command -v add-apt-repository)" ]]; then
#     sudo apt-get update && sudo apt-get install -y add-apt-repository
# fi

# TODO: Check if they have installed software-properties-common as that's a
# dependency for adding PPAs

# Amazingly add-apt-repository autoruns apt-get update for us!
# sudo add-apt-repository ppa:neovim-ppa/unstable
# sudo apt-get install neovim

# Refer back to script from newbuntu.

# Get the python remote hosts
# But if we run as root none of this dir specific stuff affects the user...
if ! [[ "$(command -v pip)" ]]; then
    sudo apt install python3-pip
    pip3 install -U pip
fi

if [[ "$(command -v conda)" ]]; then
    # TODO: Use condashlvl to determine if they activated the env yet
    # Use condaprefix to see if its in an env named neovim.
    # If not offer to create one.
    # TODO: Do a version check for conda. I'm on an arm7 and conda is too old to install neovim.
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

# Run installation:
vim -c'+PlugInstall +qall'

# Now neovim:
nvim +'PlugInstall +UpdateRemotePlugins +qall'

exit 0

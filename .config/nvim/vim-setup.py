#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Rewrite the basic Vim set up script using Python.

Example:
    Any explanation of why you find this necessary is good.:: sh

        $ python exampleofrst.py

Attributes:

    module_level_variables (type): Explanation and give an inline docstring
    immediately afterwards if possible

TODO:
    - Continue bringing this up to numpy style docstring conventions.
    - Explore ``sphinx.ext.todo`` extension.
    - IPython extension will be necessary.
    - Napoleon is used for testing numpy style docstrings.
    - Either import or append a dirlinker.
        - Newbuntu has restore_dotfiles and 00*.ipy. Forget what its called.
    - Show usage instructions
    - Make a package manager class. It's init may involve all platform specific
    tests. I think that's a good way to handle things?
"""
import os
import subprocess
import sys


def usage():
    """Show how to use command."""
    print("TODO")
    sys.exit()


def get_home():
    """Get a user's home directory."""
    try:
        home = os.path.expanduser("~")
    except OSError:
        home = os.environ.get("%userprofile%")
    return home


def check_plug_dir(plugd):
    """Check if the directory vim-plug is downloaded to exists.

    If not, create it.

    TODO:
        Figure out if TODO or params should go first haha.
        Then determine if this docstring is correct. Run through pydocstyle.

    :param: plugd
    :type: str

    :returns: None
    """
    if not os.path.isdir(plugd):
        os.makedirs(plugd, mode=0o755, exist_ok=True)


def requests_download():
    """Download vim-plug using requests."""
    res = requests.get(
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
    res.raise_for_status()
    with open("~/.local/share/nvim/site/autoload/plug.vim", "xt") as f:
        f.write(res.text)


def urllib_dl():
    """Command to download vim-plug. Fall back for requests."""
    from urllib.request import Request, urlopen
    from urllib.error import URLError
    req = Request(
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
    try:
        response = urlopen(req)
    except URLError as e:
        if hasattr(e, 'reason'):
            print('We failed to reach a server.')
            print('Reason: ', e.reason)
        elif hasattr(e, 'code'):
            print('The server couldn\'t fulfill the request.')
            print('Error code: ', e.code)

    # TODO: Make this function take an argument and have that argument be the
    # path to the desired dest for the file. Same with requests.
    with open("~/.local/share/nvim/site/autoload/plug.vim", "wb") as f:
        f.write(response.read())


def termux_packages():
    """Prepare all necessary packages for termux.

    I regularly install a lot of stuff into the global environment even though
    that's reasonably frowned upon.

    TODO:
        Do everything in a created virtualenv. Which means checking for a
        virtualenv dir (and as a result rewriting check_plug_dir() to be
        just check_dir()), ensuring virtualenv is in your path, checking that
        there isn't already a neovim env, running venv, activating the neovim
        env, and then pip installing. ughh. Positive note is you write that
        once and you get to use it forever.
    """
    subprocess.run(["pkg", "install", "vim-python", "python-dev"],
                   capture_output=True)


def pip_install():
    """Run platform-independent pip install.

    Welllll. That's probably too forgiving. You could add a sys.version_info
    check (or platform.python_version_tuple) to see if they're using 3.7
    so you can add check=True to the arguments.

    TODO:
        Give this function a :param: pkgs.
        Make it an argument to the script maybe? If you wanna get fancy with
        argparse, allow a file to be specified and install the packages listed.
    """
    cmd = [
            "pip", "install", "-U", "pip", "neovim",
            "python-language-server[all]", "flake8", "rstchecker", "ipython"
        ],
    if sys.version_info > (3, 7):
        subprocess.run(cmd, capture_output=True, check=True)
    else:
        subprocess.run(cmd, capture_output=True)


if __name__ == "__main__":
    if sys.argv[1] == '--help' or '-h':
        usage()

    home = get_home()

    uname = os.uname()
    if uname[0] == 'Linux':
        plugd = os.path.join(home, ".local", "share", "nvim", "site",
                             "autoload")
        LINUX = 1
        check_plug_dir(plugd)
    else:
        sys.exit("Unfortunately your platform isn't supported yet. Sorry!")
        # TODO: Should be as simple as function call with proper windows
        # directory. In the future add an elif os[0] == 'nt' like explicitly
        # mention by name so we still catch everything else in this else stmnt

    try:
        import requests
    except ImportError:
        NOREQUESTS = 1

    if NOREQUESTS:
        urllib_dl()
    else:
        requests_download()

    # could also have done platform.machine. *shrugs*
    if uname.machine == 'aarch64':
        termux_packages()

    # TODO: Unfortunately even something as simple as a bare pip install needs
    # a todo. Check if we aren't using conda. By checking env vars? Or
    # is it best to do::
    # conda_check = subprocess.run(["command", "-v", "conda"])
    # conda_check.check_returncode()
    pip_install()

#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Rewrite the basic Vim set up script using Python.

Attributes:

    module_level_variables (type): Explanation and give an inline docstring
    immediately afterwards if possible

(Usually examples go after the attributes)

Example:
    Any example of how to use this module goes here:: sh

        $ python exampleofrst.py

TODO:
    - Continue bringing this up to numpy style docstring conventions.
    - Explore ``sphinx.ext.todo`` extension
    - IPython extension will be necessary
    - Napoleon is used for testing numpy style docstrings
    - Show usage instructions in :func: and in :mod: docstring.
    - Make a package manager class. It's init may involve all platform specific tests.
        - Or better stated as a question: What information needs to initialize
          the state of the p.m. and where should platform specific info go?
"""
import os
import subprocess
import sys


def usage():
    """Show how to use command."""
    print("TODO")
    sys.exit()


def get_home():
    """Get a user's home directory.

    .. note::
        sysconfig._getuserbase() does a similar thing; however, the end
        directory is different in every OS case so we can't just import it and
        walk away.
    """
    try:
        home = os.path.expanduser("~")
    except OSError:
        home = os.environ.get("%userprofile%")
    return home


def check_plug_dir(plugd):
    """Check if the directory vim-plug is downloaded to exists.

    If not, create it.

    plugd : str
        The directory to put vim-plug in.

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
    """
    if sys.version_info > (3, 7):
        subprocess.run([
            "pip", "install", "-U", "pip", "neovim",
            "python-language-server[all]"
        ],
                       capture_output=True,
                       check=True)
    else:
        subprocess.run([
            "pip", "install", "-U", "pip", "neovim",
            "python-language-server[all]"
        ],
                       capture_output=True)


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

    # Alright so now this module downloads vim-plug on a Linux machine.
    # TODO: Need to import subprocess and start running platform dependant code
    # should use result from os.uname() again. After evaluation do something
    # like LINUX=1 and if LINUX && platform.archeticture == "amd64": # to
    # prevent false positives from termux,
    # sudo apt-get install vim-gtk3. Is neovim in the ubuntu 18.04 repos?
    # Ugh this is getting so specific.

    if uname.machine == 'aarch64':
        termux_packages()
    # TODO: Every other machine you own haha.

    pip_install()

#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Setup Neovim on Linux or on Termux.

.. todo::

    - Show usage instructions in :func: and in :mod: docstring.
    - Make a package manager class. It's init may involve all platform specific tests.
        - Or better stated as a question: What information needs to initialize
          the state of the p.m. and where should platform specific info go?
    - Install neovim's python packages in a venv.
    - Expand to windows compatability
    - Add conda compatability
    - Finish argument parser
"""
import argparse
import os
import subprocess
import sys


def _parse_arguments():
    """Parsers the command line arguments given to the installer.

    None should be required for a complete setup; however, if any particular
    modifications need to be made, they would be interpreted here.

    **WHAT DOES IT RETURN AGAIN**
    :return: :class:`Response <Response>` object

    .. todo::
        - Add arguments for where they want the virtualenv to install this into
        - Argument for what additional packages they'd like
        - Give an option to specify a file with a listing of packages?
    """
    parser = argparse.ArgumentParser(
            description='Installs and sets up neovim.'
            )

    parser.add_argument('--plug-dir', dest=plugd, help='The directory that vim-plug is downloaded to.')

    args = parser.parse_args()

    return args


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

    :param plugd: The directory to put vim-plug in.
    :returns: None
    """
    if not os.path.isdir(plugd):
        os.makedirs(plugd, mode=0o755, exist_ok=True)


def requests_download(plug):
    """Download vim-plug using requests.

    :param plug: File to download vim-plug to.
    :returns: None
    """
    res = requests.get(
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
    res.raise_for_status()

    with open(plug, "xt") as f:
        f.write(res.text)


def urllib_dl(plug):
    """Command to download vim-plug. Fall back for requests.

    :param plug: File to download vim-plug to.
    :returns: None
    """
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

    with open(plug, "wb") as f:
        f.write(response.read())


def termux_packages():
    """Prepare all necessary packages for termux.

    .. todo::

        - Rewrite for a virtualenv
        - Ensure we have write access to the virtualenv
        - If the user doesn't give us a place to do this, where do we go?
            - May end up a required arg although that should be avoided.
    """
    subprocess.run(["pkg", "install", "vim-python", "python-dev"],
                   capture_output=True)


def pip_install():
    """Run platform-independent pip install. Install both pynvim and neovim."""
    if sys.version_info > (3, 7):
        subprocess.run([
            "pip", "install", "-U", "pip", "neovim",
            "python-language-server[all]", "pynvim"
        ],
                       capture_output=True,
                       check=True)
    else:
        subprocess.run([
            "pip", "install", "-U", "pip", "neovim",
            "python-language-server[all]", "pynvim"
        ],
                       capture_output=True)


if __name__ == "__main__":
    # Before anything check that we're on a supported system.
    home = get_home()
    uname = os.uname()  # store in a var for when we branch to other systems
    if uname[0] == 'Linux':
        pass
    else:
        sys.exit("Unfortunately your platform isn't supported yet. Sorry!")
        # TODO: Should be as simple as function call with proper windows
        # directory. In the future add an elif os[0] == 'nt' like explicitly
        # mention by name so we still catch everything else in this else stmnt

    # now that we know we're on a supported OS parse the args
    args = _parse_arguments()

    # check that the dir we need to download vim-plug to exists.
    if args.plugd:
        plugd = args.plugd
    else:
        plugd = os.path.join(home, ".local", "share", "nvim", "site", "autoload")

    check_plug_dir(plugd)

    plug = os.path.join(plugd, '', 'plug.vim')
    # download vim-plug
    try:
        import requests
    except ImportError:
        NOREQUESTS = 1

    if NOREQUESTS:
        urllib_dl(plug)
    else:
        requests_download(plug)

    # could also have done platform.machine. *shrugs*
    # TODO: Download packages in a venv
    if uname.machine == 'aarch64':
        termux_packages()
    # TODO: Every other machine you own haha.

    # TODO: Unfortunately even something as simple as a bare pip install needs
    # a todo. Check if we aren't using conda. By checking env vars? Or
    # is it best to do::
    # conda_check = subprocess.run(["command", "-v", "conda"])
    # conda_check.check_returncode()
    pip_install()

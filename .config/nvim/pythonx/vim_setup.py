#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Setup Neovim on Linux or on Termux.

Apr 19, 2019:

    Just executed it and no errors.
    Also no output so don't know if anything executed.
    Logging needs to be set up mpre thoroughly and a plan needs to get formulated
    for how to design the classes and overall structure of the mod.

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
import logging
import os
import subprocess
import sys

try:
    import requests
except ImportError:
    NOREQUESTS = 1
else:
    NOREQUESTS = None

logger = logging.getLogger(name=__name__)


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
        description='Installs and sets up neovim.')

    parser.add_argument('-d',
                        '--plug-dir',
                        dest='plugd',
                        metavar="Directory for vim-plug",
                        help='The directory that vim-plug is downloaded to.')
    parser.add_argument("-p",
                        "--packages",
                        dest="packages",
                        metavar="packages",
                        required=False,
                        default=None,
                        help="Packages for pip to install.")
    args = parser.parse_args()

    return args


class Machine:
    """Create a class with attributes representing varying platforms.

    Probably gonna want to move those functions `get_home` and stuff into this class.
    """

    def __init__(self, home, uname):
        """Initialize a machine."""
        self.home = home
        self.uname = uname
        self.pip_version = pip_version


def get_home():
    """Get a user's home directory.

    .. note::
        :func:`sysconfig._getuserbase()` does a similar thing; however, the end
        directory is different in every OS case so we can't just import it and
        walk away.
    """
    try:
        home = os.path.expanduser("~")
    except OSError:
        home = os.environ.get("%userprofile%")
    return home


def check_dir(dir_d):
    """Check if a dir exists and if not, create it.

    :param dir_d: The directory to put vim-plug in.
    :returns: None
    """
    if not os.path.isdir(dir_d):
        os.makedirs(dir_d, mode=0o755, exist_ok=True)


def requests_download(plug):
    """Download vim-plug using requests. Overwrites file if it exists.

    :param plug: File to download vim-plug to.
    :returns: None
    """
    res = requests.get(
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
    res.raise_for_status()

    with open(plug, "wt") as f:
        f.write(res.text)

    return res.status_code


def urllib_dl(plug):
    """Command to download vim-plug. Fall back for requests.

    :param plug: File to download vim-plug to.
    :returns: None
    """
    from urllib.request import Request, urlopen
    from urllib.error import URLError, HTTPError
    req = Request(
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
    try:
        response = urlopen(req)
    except URLError as e:
        if hasattr(e, 'reason'):
            print('We failed to reach a server.')
            print('Reason: ', e.reason)
        elif hasattr(e, 'code'):
            print("The server couldn't fulfill the request.")
            print('Error code: ', e.code)
    except HTTPError as e:
        logging.error(e)
        logging.error(req.full_url)

    with open(plug, "wb") as f:
        f.write(response.read())


def termux_packages():
    """Prepare all necessary packages for termux.

    .. todo::

        - Rewrite for a virtualenv
        - Ensure we have write access to the virtualenv
        - If the user doesn't give us a place to do this, where do we go?
            - May end up a required arg although that should be avoided.
        - Do we need to decode the output? Also since we're capturing it, it
          should be assigned to something and returned right?

    """
    subprocess.run(["pkg", "install", "vim-python", "python-dev"],
                   capture_output=True)


def pip_version():
    if sys.version_info > (3, 7):
        PIP37 = True
        return PIP37
    else:
        return None


def pip_install(PIP37=None):
    """Run platform-independent pip install. Install both pynvim and neovim."""
    if PIP37:
        subprocess.run([
            "pip", "install", "-U", "pip", "python-language-server[all]",
            "pynvim"
        ],
                       capture_output=True,
                       check=True)
    else:
        subprocess.run([
            "pip", "install", "-U", "pip", "python-language-server[all]",
            "pynvim"
        ],
                       capture_output=True)


def main():
    # Before anything check that we're on a supported system.
    home = get_home()
    uname = os.uname()  # store in a var for when we branch to other systems
    if uname[0] == 'Linux':
        pass
    else:
        sys.exit("Unfortunately your platform isn't supported yet. Sorry!")

    # now that we know we're on a supported OS parse the args
    args = _parse_arguments()

    # check that the dir we need to download vim-plug to exists.
    if args.plugd:
        plugd = args.plugd
    else:
        plugd = os.path.join(home, ".local", "share", "nvim", "site",
                             "autoload")

    check_dir(plugd)

    plug = os.path.join(plugd, '', 'plug.vim')
    # download vim-plug
    if NOREQUESTS:
        status = urllib_dl(plug)
    else:
        status = requests_download(plug)
        if not status == 200:
            logging.warning("Vim plug download status code: ")
            logging.warning(status)

    # could also have done platform.machine. *shrugs*
    # TODO: Download packages in a venv. Interestingly enough the PEP that
    # introduced virtual environments might be your best bet here.
    if uname.machine == 'aarch64':
        termux_packages()
    # TODO: Every other machine you own haha.

    # conda_check = subprocess.run(["command", "-v", "conda"])
    # conda_check.check_returncode()
    pip_install(pip_version())


if __name__ == "__main__":
    logging.basicConfig(level=logging.WARNING)
    sys.exit(main())

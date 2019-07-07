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
import contextlib
import logging
import os
from pathlib import Path
import shutil
import subprocess
import sys
import threading

try:
    import requests
except ImportError:
    NOREQUESTS = 1
else:
    NOREQUESTS = None

LOGGER = logging.getLogger(name=__name__)


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
            prog='Neovim automated installer.',
            description='Installs and sets up neovim.')

    parser.add_argument(
        '-d',
        '--plug-dir',
        nargs='?',
        metavar="Directory for vim-plug",
        help='The directory that vim-plug is downloaded to.')
    parser.add_argument(
        "-p",
        "--packages",
        default='pip, pynvim',
        action='append',
        nargs='*',
        help="Comma separated list of packages for pip to install.")

    args = parser.parse_args()

    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit()

    return args


class Machine:
    """Create a class with attributes representing varying platforms.

    Probably gonna want to move those functions `get_home` and stuff into this class.
    """

    def __init__(self, path=None):
        """Initialize a machine."""
        self.conda = shutil.which('conda')
        if not path:
            self.path = Path('.')
        else:
            self.path = Path
        self._py_version = sys.version_info

    def _is_py37(self):
        return self._py_version > (3, 7)

    def get_home(self):
        """Get a user's home directory."""
        try:
            return self.path.home()
        except Exception as e:
            logging.error(e, exc_info=True)

    def check_dir(self, dir_d=None):
        """Check if a dir exists and if not, create it.

        :param dir_d: The directory to put vim-plug in.
        :returns: None
        """
        if not os.path.isdir(dir_d):
            os.makedirs(dir_d, mode=0o755, exist_ok=True)


def requests_download(url=None, plug=None):
    """Download any file."""
    res = requests.get(url)
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
    output = subprocess.run(["pkg", "install", "vim-python", "python-dev"],
                            capture_output=True)
    return output


def pip_install():
    """Run platform-independent pip install. Install both pynvim and neovim."""
    output = subprocess.run([
            "pip", "install", "-U", "pip", "python-language-server[all]",
            "pynvim", "neovim"], capture_output=True, check=True)
    return output


@contextlib.contextmanager
def use_virtualenv(virtualenv, python_version):
    """Use specific virtualenv."""
    context = threading.local()
    try:
        if virtualenv:
            # check if given directory is a virtualenv
            if not os.path.join(virtualenv, "bin/activate"):
                raise Exception("Given directory {0} is not a virtualenv.".format(virtualenv))

            context.virtualenv_path = virtualenv
            yield True
        else:
            proc = subprocess.Popen("virtualenv env -p {0} >> {1}".format(python_version, context.logfile),
                         shell=True, cwd=context.tempdir_path)
            context.virtualenv_path = os.path.join(context.tempdir_path, "env")
            yield proc.wait() == 0
    finally:
        context.virtualenv_path = None


def main():
    user_machine = Machine()
    home = user_machine.get_home()
    args = _parse_arguments()

    # check that the dir we need to download vim-plug to exists.
    try:
        plugd = args.plugd
    except AttributeError:
        plugd = os.path.join(home, ".local", "share", "nvim", "site",
                             "autoload")

    user_machine.check_dir(plugd)

    plug = os.path.join(plugd, '', 'plug.vim')
    # download vim-plug
    if NOREQUESTS:
        status = urllib_dl(plug)
    else:
        url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        status = requests_download(url=url, plug=plug)
        if not status == 200:
            logging.warning("Vim plug download status code: ")
            logging.warning(status, exc_info=1)

    if os.environ.get('ANDROID_ROOT'):
        termux_packages()

    # conda_check = subprocess.run(["command", "-v", "conda"])
    # conda_check.check_returncode()
    pip_install(pip_version())


if __name__ == "__main__":
    logging.basicConfig(level=logging.WARNING)
    sys.exit(main())

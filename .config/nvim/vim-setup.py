#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Rewrite the basic Vim set up script using Python.

Example:
    Any explanation of why you find this necessary is good.
    In addition you can end a section with double colons::

        $ python exampleofrst.py

Attributes:

    module_level_variables (type): Explanation and give an inline docstring
    immediately afterwards if possible

TODO:
    - Continue bringing this up to google style docstring conventions.
    - Explore ``sphinx.ext.todo`` extension
"""
import os
import sys


def usage():
    """Show how to use command."""
    print("TODO")
    sys.exit()


def check_plug_dir():
    """Check if the directory vim-plug is downloaded to exists."""
    pass


def requests_download():
    """Download vim-plug using requests.

    Quickly thrown together.

    TODO:
        Add a getter/setter style thing for a dir and os check.
    """
    res = requests.get("https://github.com/junegunn/vim-plug")
    res.raise_for_status()
    with open("~/.local/share/nvim/site/autoload/plug.vim", "xt") as f:
        f.write(res.text)

def curl_download():
    """Command to download vim-plug. Fall back for requests."""
    pass


if __name__ == "__main__":
    if sys.argv[1] == '--help' or '-h' or '':
        usage()

    home = os.path.expanduser("~")
    check_plug_dir()

    try:
        import requests
    except ImportError:
        NOREQUESTS = 1

    if NOREQUESTS:
        curl_download()
    else:
        requests_download()

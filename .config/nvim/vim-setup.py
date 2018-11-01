#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Rewrite the basic Vim set up script using Python.

:examples:
    code

:param1 something:
:param1 type:

Raises:
    whatever it raises

Returns:
    Ya know.

"""
import os
import sys


def check_plug_dir():
    """Check if the directory vim-plug is downloaded to exists."""
    pass


def requests_download():
    """Download vim-plug using requests."""
    res = requests.get("github.com/urlyouneedtogetTODO")


def curl_download():
    """Command to download vim-plug. Fall back for requests."""
    pass


if __name__ == "__main__":
    # argparse? lol I'm always going to suggest it.
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

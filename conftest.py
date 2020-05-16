#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""The pynvim official conftest."""
import codecs
import contextlib
# import importlib
import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

import pynvim

import pytest
from py._path.local import LocalPath


def get_git_root() -> Path:
    try:
        almost = codecs.decode(
            subprocess.check_output(["git", "rev-parse", "--show-toplevel"]), "utf-8"
        )
        return Path(almost.rstrip())
    except subprocess.CalledProcessError as e:
        print(e)
        return Path.cwd()


@contextlib.contextmanager
def as_cwd(new_dir, *args, **kwargs):
    old_cwd = Path.cwd()
    try:
        os.chdir(new_dir)
        yield
    finally:
        os.chdir(old_cwd)


@pytest.fixture(scope="session")
def env(listen_addr=None):
    # Context manager for env
    if not os.environ.get("NVIM_LISTEN_ADDRESS"):
        if listen_addr is None:
            try:
                listen_addr = tempfile.TemporaryDirectory()
            finally:
                listen_addr._cleanup(listen_addr.name, '')
        os.environ.putenv("NVIM_LISTEN_ADDRESS", listen_addr.name)


@pytest.fixture
def old_vim():
    # now that i'm rereading it this is such a weird way of settings things up.
    child_argv = os.environ.get("NVIM_CHILD_ARGV")
    # so if we're on windows should we have shelltemp set or not?
    listen_address = os.environ.get("NVIM_LISTEN_ADDRESS")
    if child_argv is None and listen_address is None:
        child_argv = '["nvim", "-u", "NONE", "--embed", "--headless"]'

    if child_argv is not None:
        editor = pynvim.attach("child", argv=json.loads(child_argv))
    else:
        # is an assert  necessary in the fixture?
        assert listen_address is None or listen_address != ""
        editor = pynvim.attach("socket", path=listen_address)

    return editor

@pytest.fixture(scope="session")
def vim():
    inside_nvim = os.environ.get("NVIM_LISTEN_ADDRESS")
    if inside_nvim is None:
        # If we aren't running inside a `:terminal`, just exec nvim.
        if sys.argv[:1] == "script_host.py":
            sys.argv.pop()
        # os.execvp('nvim', sys.argv)

    if inside_nvim:
        editor = pynvim.attach("socket", path=inside_nvim)
    else:
        editor = pynvim.attach("stdio", sys.argv)
    return editor


if __name__ == "__main__":
    with as_cwd(get_git_root()):
        local_path = LocalPath(os.path.abspath(".") + "/python3/pynvim.py")
        pynvim = local_path.pyimport()

    import selectors
    selectors._fileobj_to_fd(open("python3/pynvim.py"))

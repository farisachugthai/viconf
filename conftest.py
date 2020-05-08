#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""The pynvim official conftest."""
import json
import os
import sys
import tempfile

import pytest
from py._path.local import LocalPath
# from _pytest.config import ConftestImportFailure

here = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(here, 'python3'))
from pynvim import attach, start_host


@pytest.fixture(scope="session", autouse=True)
def env(listen_addr=None):
    # Context manager for env
    env = os.environ
    if not env.get("NVIM_LISTEN_ADDRESS"):
        if listen_addr is None:
            try:
                listen_addr = tempfile.TemporaryDirectory()
            finally:
                listen_addr._cleanup(listen_addr.name, '')
        os.putenv("NVIM_LISTEN_ADDRESS", listen_addr.name)


@pytest.fixture
def old_vim():
    # now that i'm rereading it this is such a weird way of settings things up.
    child_argv = os.environ.get("NVIM_CHILD_ARGV")
    # so if we're on windows should we have shelltemp set or not?
    listen_address = os.environ.get("NVIM_LISTEN_ADDRESS")
    if child_argv is None and listen_address is None:
        child_argv = '["nvim", "-u", "NONE", "--embed", "--headless"]'

    if child_argv is not None:
        editor = attach("child", argv=json.loads(child_argv))
    else:
        # is an assert  necessary in the fixture?
        assert listen_address is None or listen_address != ""
        editor = attach("socket", path=listen_address)

    return editor


local_path = LocalPath("python3/pynvim_.py")
pynvim  = local_path.pyimport()

@pytest.fixture(scope="session")
def vim():
    inside_nvim = os.environ.get('NVIM_LISTEN_ADDRESS')
    if inside_nvim:
        editor = attach("socket", path=inside_nvim)
        editor = attach("socket", path=listen_address)
        editor = pynvim.attach("socket", path=listen_address)
    else:
        editor = start_host("stdio", load_plugins=False)
    return editor

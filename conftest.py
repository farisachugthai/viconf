#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""The pynvim official conftest."""
import json
import os

import pytest

import pynvim

pynvim.setup_logging("test")

# @pytest.fixture(scope="session", autouse=True)
def env(listen_addr=None):
    # Context manager for env
    env = os.environ.copy()
    if not env.get("NVIM_LISTEN_ADDRESS"):
        if listen_addr is None:
            listen_addr = pytest.tmpdir.tempdir()
        env.putenv("NVIM_LISTEN_ADDRESS", listen_addr)

@pytest.fixture
def vim():
    child_argv = os.environ.get('NVIM_CHILD_ARGV')
    listen_address = os.environ.get('NVIM_LISTEN_ADDRESS')
    if child_argv is None and listen_address is None:
        child_argv = '["nvim", "-u", "NONE", "--embed", "--headless"]'

    if child_argv is not None:
        editor = pynvim.attach('child', argv=json.loads(child_argv))
    else:
        assert listen_address is None or listen_address != ''
        editor = pynvim.attach('socket', path=listen_address)

    return editor

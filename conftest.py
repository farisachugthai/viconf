#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""The pynvim official conftest."""
import json
import os
import sys
import tempfile

sys.path.insert(0, 'python3')

from pynvim_ import attach

import pytest
# from _pytest.config import ConftestImportFailure


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
        env.putenv("NVIM_LISTEN_ADDRESS", listen_addr.name)


@pytest.fixture
def vim():
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

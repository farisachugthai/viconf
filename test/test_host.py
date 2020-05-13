# -*- coding: utf-8 -*-
import sys
from pathlib import Path

sys.path.insert(0, Path("../python3").resolve().__fspath__())

from pynvim import Host, host_method_spec
from pynvim import ScriptHost

import pytest


def host(vim):
    return ScriptHost(vim)


def test_host_imports(vim):
    h = ScriptHost(vim)
    assert h.module.__dict__["vim"]
    assert h.module.__dict__["vim"] == h.legacy_vim
    assert h.module.__dict__["sys"]


def test_host_clientinfo(vim):
    h = Host(vim)
    assert h._request_handlers.keys() == host_method_spec.keys()
    assert "remote" == vim.api.get_chan_info(vim.channel_id)["client"]["type"]
    h._load([])
    assert "host" == vim.api.get_chan_info(vim.channel_id)["client"]["type"]


# Smoke test for Host._on_error_event(). #425
def test_host_async_error(vim):
    h = Host(vim)
    h._load([])
    # Invoke a bogus Ex command via notify (async).
    vim.command("lolwut", async_=True)
    event = vim.next_message()
    assert event[1] == "nvim_error_event"
    assert "rplugin-host: Async request caused an error:\nboom\n" in h._on_error_event(
        None, "boom"
    )


if __name__ == "__main__":
    pytest.main()

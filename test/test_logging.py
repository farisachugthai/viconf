import logging
import os
import sys
import time

from pynvim import setup_logging

import pytest

CONTENT = "test text"


@pytest.fixture
def logfile(tmp_path, path=None):
    def convert_to_logfile(path):
        return setup_logging(path)

    try:
        directory = tmp_path.mkdir(mode=0o777)
    except FileExistsError:
        return

    lf = directory.join(time.ctime() + ".log", exist_ok=True)
    lf.write("Test")
    yield convert_to_logfile(lf)

    # should probably clean this up
    del lf
    # return lf


@pytest.fixture
def logger(logfile):
    logging.basicConfig(
        level=logging.WARNING, format=logging.BASIC_FORMAT, filename=logfile
    )
    return logging.getLogger(name=__name__)


# @pytest.mark.usefixtures(tmp_path)
def test_create_file(tmp_path):
    d = tmp_path / "sub"
    d.mkdir()
    p = d / "hello.txt"
    p.write_text(CONTENT)
    assert p.read_text() == CONTENT
    assert len(list(tmp_path.iterdir())) == 1


def test_log_file_exists_readable(logfile):
    setup_logging("name2")
    assert os.path.exists(logfile)
    with open(logfile, "r") as f:
        assert f.read() == ""


def test_create_logfile_envvar(logfile, monkeypatch):
    monkeypatch.setenv("NVIM_PYTHON_LOG_LEVEL", logging.WARNING)
    setup_logging(name="foo", level=os.environ.get("NVIM_PYTHON_LOG_LEVEL"))
    assert os.path.exists(logfile)
    with open(logfile, "r") as f:
        assert f.read() == ""


def test_create_logfile_envvar(tmpdir, monkeypatch):
    prefix = tmpdir.join("testlog1")
    monkeypatch.setenv("NVIM_PYTHON_LOG_FILE", prefix.strpath)
    setup_logging(name=os.environ.get("NVIM_PYTHON_LOG_FILE"), level=30)
    assert os.path.exists(logfile)
    assert caplog.messages == []


def test_incorrect_log_level(tmpdir, caplog, logfile):
    # excuse my confusion over this but how the hell does anything pass
    setup_logging(name=tmpdir.strpath, level="30")
    assert caplog.record_tuples == [
        ("pynvim", 30, "Invalid NVIM_PYTHON_LOG_LEVEL: 'invalid', using INFO."),
    ]
    logfile = get_expected_logfile(prefix, "name2")
    assert os.path.exists(logfile)
    with open(logfile, "r") as f:
        lines = f.readlines()
        assert len(lines) == 1
        assert lines[0].endswith(
            "- Invalid NVIM_PYTHON_LOG_LEVEL: 'invalid', using INFO.\n"
        )


def test_invalid_envvar(monkeypatch):
    monkeypatch.setenv("NVIM_PYTHON_LOG_LEVEL", "invalid")

    with pytest.warns(pytest.PytestWarning):
        # C:\Users\fac\projects\viconf\test\test_logging.py:32: PytestWarning:
        # Value of environment variable NVIM_PYTHON_LOG_LEVEL type should be
        # str, but got 30 (type: int); converted to str implicitly
        monkeypatch.setenv("NVIM_PYTHON_LOG_LEVEL", 30)


if __name__ == "__main__":
    pytest.main()

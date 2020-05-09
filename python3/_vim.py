#!/usr/bin/env python3
# encoding: utf-8
"""Wrapper functionality around the functions we need from Vim.

Really useful seemingly universal functions for working with Vim though.

Dec 07, 2019: Double checked that this passes a cursory `:py3f %` test and it did.

"""
import json
import os
import sys
import xml.dom.minidom as md

from contextlib import contextmanager
from pathlib import Path
from pprint import pprint

try:
    import yaml
except (ImportError, ModuleNotFoundError):
    yaml = None

global vim


def get_verbosity():
    return int(vim.eval("&verbose"))


def debug(msg):
    if get_verbosity() >= 2:
        print(msg)


def error(msg):
    vim.command("echohl ErrorMsg")
    vim.command("echomsg '%s'" % msg.replace("'", "''"))
    vim.command("echohl None")


def vim_eval(text):
    """Wraps vim.eval."""
    return vim.eval(text)


def bindeval(text):
    """Wraps vim.bindeval."""
    return vim.bindeval(text)


def command(text, *args, **kwargs):
    return vim.command(text, *args, **kwargs)


def feedkeys(keys, mode="n"):
    """Wrapper around vim's feedkeys function.

    Mainly for convenience.
    """
    if eval("mode()") == "n":
        if keys == "a":
            cursor_pos = get_cursor_pos()
            cursor_pos[2] = int(cursor_pos[2]) + 1
            set_cursor_from_pos(cursor_pos)
        if keys in "ai":
            keys = "startinsert"

    if keys == "startinsert":
        command("startinsert")
    else:
        command(r'call feedkeys("%s", "%s")' % (keys, mode))


def _vim_dec(string):
    """Decode 'string' using &encoding. From UltiSnips.compatability."""
    # We don't have the luxury here of failing, everything
    # falls apart if we don't return a bytearray from the
    # passed in string
    return string.decode(vim.eval("&encoding"), "replace")


def _vim_enc(bytearray):
    """Encode 'string' using &encoding. From UltiSnips.compatability."""
    # We don't have the luxury here of failing, everything
    # falls apart if we don't return a string from the passed
    # in bytearray
    return bytearray.encode(vim.eval("&encoding"), "replace")


def col2byte(line, col):
    """Convert a valid column index into a byte index inside of vims buffer."""
    # We pad the line so that selecting the +1 st column still works.
    pre_chars = (vim.current.buffer[line - 1] + "  ")[:col]
    return len(_vim_enc(pre_chars))


class VimBuffer:
    """Wrapper around the current Vim buffer."""

    def __init__(self, vim=None):
        self.vim = vim
        self._window = vim.current.window
        self._tabpage = vim.current.tabpage
        self._range = vim.current.range
        self._line = vim.current.line

    @property
    def _buffer(self):
        self.vim.current.buffer

    # todo: setters
    @property
    def _buffer(self):
        self.vim.current.buffer


    def __getitem__(self, idx):
        if isinstance(idx, slice):  # Py3
            yield self.__getslice__(idx.start, idx.stop)
        rv = self._buffer[idx]
        yield rv

    def __getslice__(self, i, j):  # pylint:disable=no-self-use
        rv = self._buffer[i:j]
        yield [l for l in rv]

    def __setitem__(self, idx, text):
        if isinstance(idx, slice):  # Py3
            return self.__setslice__(idx.start, idx.stop, text)
        self._buffer[idx] = text

    def __setslice__(self, i, j, text):  # pylint:disable=no-self-use
        self._buffer[i:j] = [l for l in text]

    def __len__(self):
        return len(self._buffer)

    def __repr__(self):
        return "{}    #{}    {}".format("Vim Buffer:", self.bufnr(), self.filetypes)

    def line_till_cursor(self):  # pylint:disable=no-self-use
        """Return the text before the cursor."""
        _, col = self.cursor
        return (vim.current.line)[:col]

    @property
    def bufnr(self):  # pylint:disable=no-self-use
        """Return the bufnr() of the current buffer."""
        return self._buffer.number

    @property
    def filetypes(self):
        """Return the filetypes available. Utilizes a list comprehension to generate.

        Returns
        --------
        filetypes : list

        """
        return [ft for ft in vim.eval("&filetype").split(".") if ft]

    @property
    def cursor(self):  # pylint:disable=no-self-use
        """Return the current windows cursor.

        Note that this is 0 based in col and 0 based in line which is
        different from Vim's cursor.

        """
        line, nbyte = self._window.cursor
        col = byte2col(line, nbyte)
        return Position(line - 1, col)

    @cursor.setter
    def cursor(self, pos):  # pylint:disable=no-self-use
        """See getter."""
        nbyte = col2byte(pos.line + 1, pos.col)
        self._window.cursor = pos.line + 1, nbyte

    def cur_window(self):
        return self._window

    def cur_buffer(self):
        return self._buffer

    def cur_tab(self):
        return self._tabpage

    def cur_range(self):
        return self._range

    def cur_line(self):
        return self._line

    def cur_session(self):
        return self._buffer._session

    def name(self):
        """Simple example of how to get the current buffer's filename."""
        return self._buffer.name

    def fname(self):
        return self.name




@contextmanager
def option_set_to(name, new_value):
    """Set a Vim option to a value."""
    old_value = vim.eval("&" + name)
    command("set {0}={1}".format(name, new_value))
    try:
        yield
    finally:
        command("set {0}={1}".format(name, old_value))


@contextmanager
def save_mark(name):
    old_pos = get_mark_pos(name)
    try:
        yield
    finally:
        if _is_pos_zero(old_pos):
            delete_mark(name)
        else:
            set_mark_from_pos(name, old_pos)


def virtual_position(line, col):
    """Runs the position through virtcol() and returns the result."""
    nbytes = col2byte(line, col)
    return line, int(eval("virtcol([%d, %d])" % (line, nbytes)))


def select(start, end):
    """Select the span in Select mode."""
    selection = eval("&selection")

    col = col2byte(start.line + 1, start.col)
    vim.current.window.cursor = start.line + 1, col

    mode = eval("mode()")

    move_cmd = ""
    if mode != "n":
        move_cmd += r"\<Esc>"

    if start == end:
        # Zero Length Tabstops, use 'i' or 'a'.
        if col == 0 or mode not in "i" and col < len(buf[start.line]):
            move_cmd += "i"
        else:
            move_cmd += "a"
    else:
        # Non zero length, use Visual selection.
        move_cmd += "v"
        if "inclusive" in selection:
            if end.col == 0:
                move_cmd += "%iG$" % end.line
            else:
                move_cmd += "%iG%i|" % virtual_position(end.line + 1, end.col)
        elif "old" in selection:
            move_cmd += "%iG%i|" % virtual_position(end.line + 1, end.col)
        else:
            move_cmd += "%iG%i|" % virtual_position(end.line + 1, end.col + 1)
        move_cmd += "o%iG%i|o\\<c-g>" % virtual_position(start.line + 1, start.col + 1)
    feedkeys(move_cmd)


def set_mark_from_pos(name, pos):
    return _set_pos("'" + name, pos)


def get_mark_pos(name):
    return _get_pos("'" + name)


def set_cursor_from_pos(pos):
    return _set_pos(".", pos)


def get_cursor_pos():
    return _get_pos(".")


def delete_mark(name):
    try:
        return command("delma " + name)
    except:
        return False


def _set_pos(name, pos):
    return eval('setpos("{0}", {1})'.format(name, pos))


def _get_pos(name):
    return eval('getpos("{0}")'.format(name))


def _is_pos_zero(pos):
    return ["0"] * 4 == pos or [0] == pos


# Unrelated formatting code


def pretty_xml(x):
    """Make xml string `x` nicely formatted."""
    # Hat tip to http://code.activestate.com/recipes/576750/
    new_xml = md.parseString(x.strip()).toprettyxml(indent=" " * 2)
    return "\n".join(line for line in new_xml.split("\n") if line.strip())


def pretty_json(j):
    """Make json string `j` nicely formatted."""
    return json.dumps(json.loads(j), sort_keys=True, indent=4)


def interpret_yaml(y):
    if yaml is not None:
        return json.dumps(yaml.safe_load(y), sort_keys=True, indent=4)


def pretty_it(datatype):
    r = vim.current.range
    content = "\n".join(r)
    content = prettiers[datatype](content)
    r[:] = str(content).split("\n")


def my_plugins():
    """This was way too hard to do in Vimscript and took me 10 seconds to write in python."""
    res = {idx: j for idx, j in enumerate(vim.eval("g:plugs").keys())}
    print(res)
    return res


def fname():
    """Simple example of how to get the current buffer's filename."""
    # or you should do b = VimBuffer().name
    return vim.current.buffer.name


def pd(args=None):
    """Simple helper because I do this so often."""
    pprint(dir(args))
    return dir(args)


class _Vim(object):
    def __getattr__(self, attr):
        return getattr(vim, attr)


vim_obj = _Vim()


def _patch_nvim(vim):
    """Patches to make handling both Vim and Nvim easier."""

    class Bindeval:
        def __init__(self, data):
            self.data = data

        def __getitem__(self, key):
            return _bytes(self.data[key])

    def function(name):
        """Kinda surpried this doesn't utilize functools.wraps."""

        def inner(*args, **kwargs):
            ret = vim.call(name, *args, **kwargs)
            return _bytes(ret)

        return inner

    def bindeval(value):
        data = vim.eval(value)
        return Bindeval(data)

    vim_vars = vim.vars

    class vars_wrapper:
        def get(self, *args, **kwargs):
            item = vim_vars.get(*args, **kwargs)
            return _bytes(item)

    vim.Function = function
    vim.bindeval = bindeval
    vim.List = list
    vim.Dictionary = dict
    vim.vars = vars_wrapper()


if __name__ == "__main__":
    try:
        import vim  # noqa pylint:disable=import-error
    except ImportError:
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
        from pynvim import LegacyVim
        vim = LegacyVim()

    try:
        import UltiSnips
    except ImportError:
        UltiSnips = None

    data = vim_eval('stdpath("data")')
    if Path(data).exists():
        sys.path.append(data)

    buf = VimBuffer(vim)  # pylint:disable=invalid-name

    prettiers = {
        "xml": pretty_xml,
        "json": pretty_json,
        "yaml": interpret_yaml,
    }

    if hasattr(vim, "from_nvim"):
        _patch_nvim(vim_obj)

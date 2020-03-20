#!/usr/bin/env python3
# encoding: utf-8
"""Wrapper functionality around the functions we need from Vim.

Really useful seemingly universal functions for working with Vim though.

Dec 07, 2019: Double checked that this passes a cursory `:py3f %` test and it did.

"""
from contextlib import contextmanager
import xml.dom.minidom as md
from pprint import pprint
import json

try:
    import vim  # pylint:disable=import-error
except ImportError:
    vim = None

try:
    import yaml
except (ImportError, ModuleNotFoundError):
    yaml = None


class VimBuffer:
    """Wrapper around the current Vim buffer."""

    def __init__(self):
        self.vim = vim
        self._buffer = vim.current.buffer
        self._window = vim.current.window
        self._tabpage = vim.current.tabpage
        self._range = vim.current.range
        self._line = vim.current.line

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


buf = VimBuffer()  # pylint:disable=invalid-name


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


def escape(inp):
    """Creates a vim-friendly string from a group of
    dicts, lists and strings."""

    def conv(obj):
        """Convert obj."""
        if isinstance(obj, list):
            rv = "[" + ",".join(conv(o) for o in obj) + "]"
        elif isinstance(obj, dict):
            rv = (
                "{" + ",".join([
                    "%s:%s" % (conv(key), conv(value)) for key, value in obj.iteritems()
                ]) + "}"
            )
        else:
            rv = ('"%s"') % (obj).replace('"', '\\"')
        return rv

    return conv(inp)


def eval(text):
    """Wraps vim.eval."""
    rv = vim.eval(text)
    if not isinstance(rv, (dict, list)):
        return rv
    return rv


def bindeval(text):
    """Wraps vim.bindeval."""
    rv = vim.bindeval(text)
    if not isinstance(rv, (dict, list)):
        return rv
    return rv


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


def virtual_position(line, col):
    """Runs the position through virtcol() and returns the result."""
    nbytes = col2byte(line, col)
    return line, int(eval("virtcol([%d, %d])" % (line, nbytes)))


def select(start, end):
    """Select the span in Select mode."""
    _unmap_select_mode_mapping()

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


def _unmap_select_mode_mapping():
    """This function unmaps select mode mappings if so wished by the user.

    Removes select mode mappings that can actually be typed by the user
    (ie, ignores things like <Plug>).

    """
    if int(eval("g:UltiSnipsRemoveSelectModeMappings")):
        ignores = eval("g:UltiSnipsMappingsToIgnore") + ["UltiSnips"]

        for option in ("<buffer>", ""):
            # Put all smaps into a var, and then read the var
            command(r"redir => _tmp_smaps | silent smap %s " % option + "| redir END")

            # Check if any mappings where found
            if hasattr(vim, "bindeval"):
                # Safer to use bindeval, if it exists, because it can deal with
                # non-UTF-8 characters in mappings; see GH #690.
                all_maps = bindeval(r"_tmp_smaps")
            else:
                all_maps = eval(r"_tmp_smaps")
            all_maps = list(filter(len, all_maps.splitlines()))
            if len(all_maps) == 1 and all_maps[0][0] not in " sv":
                # "No maps found". String could be localized. Hopefully
                # it doesn't start with any of these letters in any
                # language
                continue

            # Only keep mappings that should not be ignored
            maps = [
                m for m in all_maps
                if not any(i in m for i in ignores) and len(m.strip())
            ]

            for map in maps:
                # The first three chars are the modes, that might be listed.
                # We are not interested in them here.
                trig = map[3:].split()[0] if len(map[3:].split()) != 0 else None

                if trig is None:
                    continue

                # The bar separates commands
                if trig[-1] == "|":
                    trig = trig[:-1] + "<Bar>"

                # Special ones
                if trig[0] == "<":
                    add = False
                    # Only allow these
                    for valid in ["Tab", "NL", "CR", "C-Tab", "BS"]:
                        if trig == "<%s>" % valid:
                            add = True
                    if not add:
                        continue

                # UltiSnips remaps <BS>. Keep this around.
                if trig == "<BS>":
                    continue

                # Actually unmap it
                try:
                    command("silent! sunmap %s %s" % (option, trig))
                except:  # pylint:disable=bare-except
                    # Bug 908139: ignore unmaps that fail because of
                    # unprintable characters. This is not ideal because we
                    # will not be able to unmap lhs with any unprintable
                    # character. If the lhs stats with a printable
                    # character this will leak to the user when he tries to
                    # type this character as a first in a selected tabstop.
                    # This case should be rare enough to not bother us
                    # though.
                    pass


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


prettiers = {
    "xml": pretty_xml,
    "json": pretty_json,
    "yaml": interpret_yaml,
}


def pretty_it(datatype):
    r = vim.current.range
    content = "\n".join(r)
    content = prettiers[datatype](content)
    r[:] = str(content).split("\n")


def my_plugins():
    """This was way too hard to do in Vimscript and took me 10 seconds to write in python."""
    res = {idx: j for idx, j in enumerate(vim.eval("plugs").keys())}
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


if hasattr(vim, 'from_nvim'):
    _patch_nvim(vim_obj)

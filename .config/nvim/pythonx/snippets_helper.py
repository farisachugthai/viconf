#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Move all python functions into a dedicated file and import them.

A useful combination with UltiSnips.

* Add docstrings to everything. Kinda forces your hand to learn how
everything works
    * Admittedly good start though!
    * May want to add which snippets depend on it. If not simple examples
      for the return value will be more than plenty.

"""
import os
import string

import vim


def complete(tab, opts):
    """Get options that start with tab.

    :param tab: query string
    :param opts: list that needs to be completed
    :return: a string that start with tab
    """
    msg = "({0})"
    if tab:
        opts = [m[len(tab):] for m in opts if m.startswith(tab)]
    if len(opts) == 1:
        return opts[0]

    if not len(opts):
        msg = "{0}"
    return msg.format("|".join(opts))


def _parse_comments(s):
    """Parses vim's comments option to extract comment format """
    i = iter(s.split(","))

    rv = []
    try:
        while True:
            # get the flags and text of a comment part
            flags, text = next(i).split(':', 1)

            if len(flags) == 0:
                rv.append(('OTHER', text, text, text, ""))
            # parse 3-part comment, but ignore those with O flag
            elif 's' in flags and 'O' not in flags:
                ctriple = ["TRIPLE"]
                indent = ""

                if flags[-1] in string.digits:
                    indent = " " * int(flags[-1])
                ctriple.append(text)

                flags, text = next(i).split(':', 1)
                assert flags[0] == 'm'
                ctriple.append(text)

                flags, text = next(i).split(':', 1)
                assert flags[0] == 'e'
                ctriple.append(text)
                ctriple.append(indent)

                rv.append(ctriple)
            elif 'b' in flags:
                if len(text) == 1:
                    rv.insert(0, ("SINGLE_CHAR", text, text, text, ""))
    except StopIteration:
        return rv


def get_comment_format():
    """Determine what format a parsed file utilizes.

    It first looks at `v:commentstring`, if that ends with `%s`, it uses that.
    Otherwise it parses `&comments` and prefers single character comment
    markers if there are any.

    :returns: (first_line, middle_lines, end_line, indent)
               representing the comment format for the current file.
    :rtype:    Returns a 4-element tuple
    """
    commentstring = vim.eval("&commentstring")
    if commentstring.endswith("%s"):
        c = commentstring[:-2]
        return (c, c, c, "")
    comments = _parse_comments(vim.eval("&comments"))
    for c in comments:
        if c[0] == "SINGLE_CHAR":
            return c[1:]
    return comments[0][1:]


def make_box(twidth, bwidth=None):
    """Make a box using the specific comment characters set for a filetype.

    Determined by `v:commentstring`.

    .. see also::

        :func:`get_comment_format`
    """
    b, m, e, i = (s.strip() for s in get_comment_format())
    bwidth_inner = bwidth - 3 - max(len(b),
                                    len(i + e)) if bwidth else twidth + 2
    sline = b + m + bwidth_inner * m[0] + 2 * m[0]
    nspaces = (bwidth_inner - twidth) // 2
    mlines = i + m + " " + " " * nspaces
    mlinee = " " + " " * (bwidth_inner - twidth - nspaces) + m
    eline = i + m + bwidth_inner * m[0] + 2 * m[0] + e
    return sline, mlines, mlinee, eline


def foldmarker():
    """Return a tuple of (open fold marker, close fold marker)."""
    return vim.eval("&foldmarker").split(",")


NORMAL = 0x1
DOXYGEN = 0x2
SPHINX = 0x3
GOOGLE = 0x4
NUMPY = 0x5
JEDI = 0x6

SINGLE_QUOTES = "'"
DOUBLE_QUOTES = '"'


class Arg(object):

    def __init__(self, arg):
        self.arg = arg
        self.name = arg.split('=')[0].strip()

    def __str__(self):
        return self.name

    def __unicode__(self):
        return self.name

    def is_kwarg(self):
        return '=' in self.arg


def get_args(arglist):
    args = [Arg(arg) for arg in arglist.split(',') if arg]
    args = [arg for arg in args if arg.name != 'self']

    return args


def get_quoting_style(snip):
    style = snip.opt("g:ultisnips_python_quoting_style", "double")
    if style == 'single':
        return SINGLE_QUOTES
    return DOUBLE_QUOTES


def triple_quotes(snip):
    style = snip.opt("g:ultisnips_python_triple_quoting_style")
    if not style:
        return get_quoting_style(snip) * 3
    return (SINGLE_QUOTES if style == 'single' else DOUBLE_QUOTES) * 3


def triple_quotes_handle_trailing(snip, quoting_style):
    """
    Generate triple quoted strings and handle any trailing quote char,
    which might be there from some autoclose/autopair plugin,
    i.e. when expanding ``"|"``.
    """
    if not snip.c:
        # Do this only once, otherwise the following error would happen:
        # RuntimeError: The snippets content did not converge: …
        _, col = vim.current.window.cursor
        line = vim.current.line

        # Handle already existing quote chars after the trigger.
        _ret = quoting_style * 3
        while True:
            try:
                nextc = line[col]
            except IndexError:
                break
            if nextc == quoting_style and len(_ret):
                _ret = _ret[1:]
                col = col + 1
            else:
                break
        snip.rv = _ret
    else:
        snip.rv = snip.c


def get_style(snip):
    """Determine what style of docstring the user has."""
    style = snip.opt("g:ultisnips_python_style", "normal")

    if style == "doxygen":
        return DOXYGEN
    elif style == "sphinx":
        return SPHINX
    elif style == "google":
        return GOOGLE
    elif style == "numpy":
        return NUMPY
    elif style == "jedi":
        return JEDI
    else:
        return NORMAL


def format_arg(arg, style):
    if style == DOXYGEN:
        return "@param %s TODO" % arg
    elif style == SPHINX:
        return ":param %s: TODO" % arg
    elif style == NORMAL:
        return ":%s: TODO" % arg
    elif style == GOOGLE:
        return "%s (TODO): TODO" % arg
    elif style == JEDI:
        return ":type %s: TODO" % arg
    elif style == NUMPY:
        return "%s : TODO" % arg


def format_return(style):
    if style == DOXYGEN:
        return "@return: TODO"
    elif style in (NORMAL, SPHINX, JEDI):
        return ":returns: TODO"
    elif style == GOOGLE:
        return "Returns: TODO"


def write_docstring_args(args, snip):
    if not args:
        snip.rv += ' {0}'.format(triple_quotes(snip))
        return

    snip.rv += '\n' + snip.mkline('', indent='')

    style = get_style(snip)

    if style == GOOGLE:
        write_google_docstring_args(args, snip)
    elif style == NUMPY:
        write_numpy_docstring_args(args, snip)
    else:
        for arg in args:
            snip += format_arg(arg, style)


def write_google_docstring_args(args, snip):
    kwargs = [arg for arg in args if arg.is_kwarg()]
    args = [arg for arg in args if not arg.is_kwarg()]

    if args:
        snip += "Args:"
        snip.shift()
        for arg in args:
            snip += format_arg(arg, GOOGLE)
        snip.unshift()
        snip.rv += '\n' + snip.mkline('', indent='')

    if kwargs:
        snip += "Kwargs:"
        snip.shift()
        for kwarg in kwargs:
            snip += format_arg(kwarg, GOOGLE)
        snip.unshift()
        snip.rv += '\n' + snip.mkline('', indent='')


def write_numpy_docstring_args(args, snip):
    if args:
        snip += "Parameters"
        snip += "----------"

    kwargs = [arg for arg in args if arg.is_kwarg()]
    args = [arg for arg in args if not arg.is_kwarg()]

    if args:
        for arg in args:
            snip += format_arg(arg, NUMPY)
    if kwargs:
        for kwarg in kwargs:
            snip += format_arg(kwarg, NUMPY) + ', optional'
    snip.rv += '\n' + snip.mkline('', indent='')


def write_init_body(args, parents, snip):
    parents = [p.strip() for p in parents.split(",")]
    parents = [p for p in parents if p != 'object']

    for p in parents:
        snip += p + ".__init__(self)"

    if parents:
        snip.rv += '\n' + snip.mkline('', indent='')

    for arg in args:
        snip += "self._%s = %s" % (arg, arg)


def write_slots_args(args, snip):
    quote = get_quoting_style(snip)
    arg_format = quote + '_%s' + quote
    args = [arg_format % arg for arg in args]
    snip += '__slots__ = (%s,)' % ', '.join(args)


def write_function_docstring(t, snip):
    """Writes a function docstring with the current style.

    :param t: The values of the placeholders
    :param snip: UltiSnips.TextObjects.SnippetUtil object instance
    """
    snip.rv = ""
    snip >> 1

    args = get_args(t[2])
    if args:
        write_docstring_args(args, snip)

    style = get_style(snip)

    if style == NUMPY:
        snip += 'Returns'
        snip += '-------'
        snip += 'TODO'
    else:
        snip += format_return(style)
    snip.rv += '\n' + snip.mkline('', indent='')
    snip += triple_quotes(snip)


def get_dir_and_file_name(snip):
    return os.getcwd().split(os.sep)[-1] + '.' + snip.basename


class TextTag(object):
    """Represents a base text tag"""

    def __init__(self, text):
        self._text = text

    def render(self):
        return self._text


class BoldWrapper(TextTag):
    """Wraps a tag in <b>"""

    def __init__(self, wrapped):
        self._wrapped = wrapped

    def render(self):
        return "<b>{}</b>".format(self._wrapped.render())


class ItalicWrapper(TextTag):
    """Wraps a tag in <i>"""

    def __init__(self, wrapped):
        self._wrapped = wrapped

    def render(self):
        """Wrap the text with HTML italic tags."""
        return "<i>{}</i>".format(self._wrapped.render())


def create_table(snip):
    """Create a table. For markdown snippets."""
    # retrieving single line from current string and treat it like tabstops count
    placeholders_string = snip.buffer[snip.line].strip()[2:].split("x", 1)
    rows_amount = int(placeholders_string[0])
    columns_amount = int(placeholders_string[1])

    # erase current line
    snip.buffer[snip.line] = ''

    # create anonymous snippet with expected content and number of tabstops
    anon_snippet_title = ' | '.join(['$' + str(col) for col in range(1,columns_amount+1)]) + "\n"
    anon_snippet_delimiter = ':-|' * (columns_amount-1) + ":-\n"
    anon_snippet_body = ""
    for row in range(1,rows_amount+1):
        anon_snippet_body += ' | '.join(['$' + str(row*columns_amount+col) for col in range(1,columns_amount+1)]) + "\n"
    anon_snippet_table = anon_snippet_title + anon_snippet_delimiter + anon_snippet_body

    # expand anonymous snippet
    snip.expand_anon(anon_snippet_table)

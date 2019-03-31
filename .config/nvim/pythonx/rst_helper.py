#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Helper with rst UltiSnips plugin.

Default file from vim-snippet's repo. Modified docstrings but still much more
work to do.

"""
import vim
from os import path as ospath
# I swear the snip option has a few of these ready to go
import re
from collections import Counter

# `<http://docutils.sourceforge.net/docs/ref/rst/roles.html>`

TEXT_ROLES = [
    'emphasis', 'literal', 'code', 'math', 'pep-reference', 'rfc-reference',
    'strong', 'subscript', 'superscript', 'title-reference', 'raw'
]
TEXT_ROLES_REGEX = r'\.\.\srole::?\s(w+)'

# `<http://docutils.sourceforge.net/docs/ref/rst/directives.html#specific-admonitions>`
SPECIFIC_ADMONITIONS = [
    "attention", "caution", "danger", "error", "hint", "important", "note",
    "tip", "warning"
]
# `<http://docutils.sourceforge.net/docs/ref/rst/directives.html>`
DIRECTIVES = [
    'topic', 'sidebar', 'math', 'epigraph', 'parsed-literal', 'code',
    'highlights', 'pull-quote', 'compound', 'container', 'table', 'csv-table',
    'list-table', 'class', 'sectnum', 'role', 'default-role', 'unicode', 'raw'
]

NONE_CONTENT_DIRECTIVES = [
    'rubric', 'contents', 'header', 'footer', 'date', 'include', 'title'
]

INCLUDABLE_DIRECTIVES = ['image', 'figure', 'include']
# CJK chars
# http://stackoverflow.com/questions/2718196/find-all-chinese-text-in-a-string-using-python-and-regex
CJK_RE = re.compile(u'[⺀-⺙⺛-⻳⼀-⿕々〇〡-〩〸-〺〻㐀-䶵一-鿃豈-鶴侮-頻並-龎]', re.UNICODE)

# http://www.pygal.org/en/stable/documentation/types/index.html
CHART_TYPES = [
    "Line", "StackedLine", "HorizontalLine", "Bar", "StackedBar",
    "HorizontalBar", "Histogram", "XY", "DateLine", "TimeLine",
    "TimeDeltaLine", "DateTimeLine", "Pie", "Radar", "Box", "Dot", "Funnel",
    "Gauge", "SolidGauge", "Pyramid", "Treemap"
]


def has_cjk(s):
    """Detect if s contains CJK characters."""
    return CJK_RE.search(s) is not None


def real_filename(filename):
    """Peel extension name off if possible.

    i.e. "foo.bar.png will return "foo.bar"
    """
    return ospath.splitext(filename)[0]


def check_file_exist(rst_path, relative_path):
    """For RST file, it can just include files as relative path.

    :param rst_path: absolute path to rst file
    :param relative_path: path related to rst file
    :return: relative file's absolute path if file exist
    """
    abs_path = ospath.join(ospath.dirname(rst_path), relative_path)
    if ospath.isfile(abs_path):
        return abs_path


try:
    rst_char_len = vim.strwidth  # Requires Vim 7.3+
except AttributeError:
    from unicodedata import east_asian_width

    def rst_char_len(s):
        """Return the required over-/underline length for s."""
        result = 0
        for c in s:
            result += 2 if east_asian_width(c) in ('W', 'F') else 1
        return result


def make_items(times, leading='+'):
    """Make lines with leading char multiple times.

    :param: times, how many times you need
    :param: leading, leading character
    """
    times = int(times)
    if leading == 1:
        msg = ""
        for x in range(1, times + 1):
            msg += "%s. Item\n" % x
        return msg
    else:
        return ("%s Item\n" % leading) * times


def look_up_directives(regex, fpath):
    """Find all directive args in given file

    :param: regex, the regex that needs to match
    :param: path, to path to rst file

    :return: list, empty list if nothing matches
    """
    try:
        with open(fpath) as source:
            match = re.findall(regex, source.read())
    except IOError:
        match = []
    return match


# so what the fuck? def doesn't take an arg, the docstring says path
# and its to determine embedded syntaxes in a file.
def get_popular_code_type():
    """Find most frequent filetype in the file

    :return: string, most popular code type in file
    """
    buf = "".join(vim.current.buffer)
    types = re.findall(r'[:|\.\.\s]code::?\s(\w+)', buf)
    try:
        popular_type = Counter(types).most_common()[0][0]
    except IndexError as e:
        print(e)
    return popular_type

#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Let's rewrite this now that were not using a remote host model.


['Doc', 'ErrorDuringImport', 'HTMLDoc', 'HTMLRepr', 'Helper', 'ModuleScanner', 
'Repr', 'TextDoc', 'TextRepr', '_PlainTextDoc', '__all__', '__author__', 
'__builtins__', '__cached__', '__credits__', '__date__', '__doc__', 
'__file__', '__loader__', '__name__', '__package__', '__spec__', 
'_adjust_cli_sys_path', '_escape_stdout', '_get_revised_path', 
'_is_bound_method', '_is_some_method', '_re_stripid', '_split_list', 
'_start_server', '_url_handler', 'allmethods', 'apropos', 'browse', 
'builtins', 'classify_class_attrs', 'classname', 'cli', 'cram', 'deque', 
'describe', 'doc', 'format_exception_only', 'getdoc', 'getpager', 'help', 
'html', 'importfile', 'importlib', 'inspect', 'io', 'isdata', 'ispackage', 
'ispath', 'locate', 'os', 'pager', 'pathdirs', 'pipepager', 'pkgutil', 
'plain', 'plainpager', 'plaintext', 'platform', 're', 'render_doc', 'replace', 
'resolve', 'safeimport', 'sort_attributes', 'source_synopsis', 'splitdoc', 
'stripid', 'synopsis', 'sys', 'tempfilepager', 'text', 'time', 'tokenize', 
'ttypager', 'urllib', 'visiblename', 'warnings', 'writedoc', 'writedocs']
"""
import os
import re
import sys

import vim


def cleaned_docstrings(mod):
    """Nvim can't have newlines in strings returned from python."""

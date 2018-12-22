#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""UltiSnips source for deoplete.

Modofy rank. Determine whether we can subclass or what we can do here.
File: ultisnips.py
Author: Faris Chugthai
Email: farischugthai@gmail.com
Github: https://github.com/farisachugthai

"""

from .base import Base


class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'ultisnips'
        self.mark = '[US]'
        self.rank = 1000

    def gather_candidates(self, context):
        suggestions = []
        snippets = self.vim.eval(
            'UltiSnips#SnippetsInCurrentScope()')
        for trigger in snippets:
            suggestions.append({
                'word': trigger,
                'menu': self.mark + ' ' + snippets.get(trigger, '')
            })
        return suggestions

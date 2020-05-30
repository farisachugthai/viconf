# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))

from pygments.lexers.markup import MarkdownLexer, RstLexer
from pygments.lexers.shell import BashLexer
from pygments.lexers.textedit import VimLexer
from pygments.lexers.python import (
    NumPyLexer,
    PythonConsoleLexer,
    PythonLexer,
    PythonTracebackLexer,
)


# -- Project information -----------------------------------------------------

project = 'viconf'
copyright = '2020, Faris A Chugthai'
author = 'Faris A Chugthai'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.autodoc.typehints",
    "sphinx.ext.autosummary",
    "sphinx.ext.coverage",
    "sphinx.ext.doctest",
    "sphinx.ext.duration",
    "sphinx.ext.extlinks",
    "sphinx.ext.githubpages",
    "sphinx.ext.intersphinx",
    "sphinx.ext.napoleon",
    "sphinx.ext.todo",
    "sphinx.ext.viewcode",
    "sphinx.domains.c",
    "sphinx.domains.cpp",
    "sphinx.domains.index",
    "sphinx.domains.javascript",
    "sphinx.domains.python",
    "sphinx.domains.rst",
    "sphinx.domains.std",
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []


# The suffix(es) of source filenames.
# You can specify multiple suffix as a list of string:
source_suffix = {
    ".rst": "restructuredtext",
    ".txt": "restructuredtext",
}

# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'alabaster'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

html_sidebars = {
    "**": [
        "about.html",
        "relations.html",
        "localtoc.html",
        "globaltoc.html",
        "searchbox.html",
        "sourcelink.html",
    ]
}

# If true, "Created using Sphinx" is shown in the HTML footer. Default is True.
html_show_sphinx = False

html_show_copyright = False

# If not '', a 'Last updated on:' timestamp is inserted at every page bottom,
# using the given strftime format.
html_last_updated_fmt = "%b %d, %Y"


def setup(app):  # {{{
    """Add custom css styling.

    .. admonition::
        Don't use :func:`os.path.abspath()` if you need to extend this.

    See Also
    --------
    /usr/lib/python3/site-packages/sphinx/config.py : mod
        Source code where this is implemented
    https://www.sphinx-doc.org/en/master/extdev/appapi.html : URL
        help docs

    """
    app.add_lexer("py3tb", PythonTracebackLexer)
    app.add_lexer("bash", BashLexer)
    app.add_lexer("python3", PythonLexer)
    app.add_lexer("python", PythonLexer)
    app.add_lexer("pycon", PythonConsoleLexer)
    app.add_lexer("markdown", MarkdownLexer)
    app.add_lexer("rst", RstLexer)
    app.add_lexer("vim", VimLexer)

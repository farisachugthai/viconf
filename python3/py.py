import importlib
import logging
import pydoc
import vim


logger = logging.getLogger(name=__name__)


def import_mod_under_cursor():
    temp_cword = vim.eval(expand('<cWORD>'))
    logger.debug(f"{temp_cword}")
    try:
        helped_mod = importlib.import_module(temp_cword)
    except:
        vim.command("echoerr 'Error during import of %s'" % temp_cword)
    else:
        pydoc.help(helped_mod)

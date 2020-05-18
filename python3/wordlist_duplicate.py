import logging
import os
from pathlib import Path
import sys

from _vim import VimBuffer

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(name=__name__)


class Target(VimBuffer):
    """Create a class for our target buffer.

    We can just allow other users to change the class attribute
    as necessary.
    """

    _target_file = Path("../spell/en.utf-8.add").resolve()

    def __init__(self, vim):
        super().__init__(vim)

    @property
    def target_file(self):
        return str(self._target_file)


def nvim_listen_address():
    return os.environ.get("NVIM_LISTEN_ADDRESS")


def vim_api():
    """Tepidly I'm going to use this now."""
    # it worked!
    vim.command("exec 'e ' . stdpath('config') . '/spell/en.utf-8.add'")


def fix_spellfile(wordlist):
    """Take the old file and append it piecemeal to a new list.

    This function checks that the old element exists, that the
    word and the next word don't match, and that the item doesn't
    start with an :kbd:`!`. These are words that are considered
    incorrect and can be safely ignored.

    Parameters
    ----------
    wordlist : list
        List of correct words.

    Returns
    -------
    new_wordlist : list
        Filtered list of words.

    """
    new_wordlist = []
    for i, j in enumerate(wordlist):
        try:
            if i > 0:
                if (
                    wordlist[i]
                    and wordlist[i] != wordlist[i + 1]
                    and not wordlist[i].startswith("!")
                ):
                    new_wordlist.append(j)
        except IndexError:  # Goes until its 1 too high idk how to stop that
            break

    return new_wordlist


def sortfile(spellfile):
    """Sort `spellfile` as the implemented fix only works if sorted.

    Parameters
    ----------
    spellfile : str (Path-like)
        File to fix.

    Returns
    -------
    sorted_spellfile : list
        Sorted list of words.

    """
    with open(spellfile, "rt") as f:
        spellobj = f.readlines()

    sorted_spellfile = sorted(spellobj)
    return sorted_spellfile


def vim_sort(spellfile=None):
    """If you want ann xmap or something."""
    if spellfile is None:
        spellfile = vim.current.buffer
    vim.eval(":keepmarks '<,'>!sort")


def main():
    """Execute the module.

    .. admonition::
        Don't use sys.argv[1:] when executing a file using py3file in neovim!
        Args 1 and 2 are already set to -c and 'script-host.py'

    """
    args = sys.argv[3:]
    try:
        import vim
    except ImportError:  # we're not in vim
        sys.path.insert(0, os.path.dirname(os.path.abspath(".")))

        from pynvim import LegacyVim, stdio_session
        session = stdio_session()
        vim = LegacyVim.from_session(session)

    if len(args) < 1:
        # don't use sys.exit. Kills the channel between you and the remote host that powers everything.
        # besides you have to manually assign to sys.argv anyway.
        args = [Target(vim).target_file]

    logging.debug(f"Args: {args}")
    for i in args[0:]:
        spell_list = sortfile(i)
        # vim_api()
        fixed = fix_spellfile(spell_list)
        with open(i, "wt") as f:
            f.writelines(fixed)


if __name__ == "__main__":
    main()

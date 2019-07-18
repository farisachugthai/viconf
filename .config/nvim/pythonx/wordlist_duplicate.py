
                        and not wordlist[i].startswith('!'):
                    new_wordlist.append(j)
                if wordlist[i] and wordlist[i] != wordlist[i + 1] \
            break
            f.writelines(fixed)
            if i > 0:
        File to fix.
        Filtered list of words.
        List of correct words.
        Sorted list of words.
        except IndexError:  # it will go until its 1 too high idk how to stop that
        fixed = fix_spellfile(spell_list)
        sorted_spellfile = sorted(spellobj)
        spell_list = sortfile(i)
        spellobj = f.readlines()
        sys.exit('Error. Please provide a path to the file(s) to edit')
        try:
        with open(i, 'wt') as f:
    """
    """Execute the module."""
    """Sort `spellfile` as the implemented fix only works if sorted.
    """Take the old file and append it piecemeal to a new list.
    -------
    ----------
    Parameters
    Returns
    This function checks that the old element exists, that the
    args = sys.argv[:]
    for i in args[0:]:
    for i, j in enumerate(wordlist):
    if len(args) < 1:
    incorrect and can be safely ignored.
    logging.basicConfig(level=logging.DEBUG)
    logging.debug('Args: ', args)
    main()
    new_wordlist : list
    new_wordlist = []
    python ../pythonx/wordlist_duplicate.py en.utf-8.add
    return new_wordlist
    return sorted_spellfile
    sorted_spellfile : list
    spellfile : str (Path-like)
    start with an :kbd:`!`. These are words that are considered
    with open(spellfile, 'rt') as f:
    word and the next word don't match, and that the item doesn't
    wordlist : list
"""
"""Fix duplicate entries in the spellfile.
# import vim
Damnit! Doesn't work. Just silently deleted the file...:/
If executed in the spell directory, one can run::
def fix_spellfile(wordlist):
def main():
def sortfile(spellfile):
if __name__ == '__main__':
import logging

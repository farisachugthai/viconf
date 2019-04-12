"""Fix duplicate entries in the spellfile.

If executed in the spell directory, one can run::

    python ../pythonx/wordlist_duplicate.py en.utf-8.add

Damnit! Doesn't work. Just silently deleted the file...:/

"""
import sys


def fix_spellfile(wordlist):
    """Git merges screw up the module but it's an easy fix."""
    new_wordlist = []
    for i, j in enumerate(wordlist, start=-1):
        if i < 0:
            pass
        else:
            if wordlist[i] == wordlist[i + 1]:
                pass
            else:
                new_wordlist.append(j)
    return new_wordlist


def sortfile(spellfile):
    """Sort `spellfile` as the fix above only works if sorted."""
    with open(spellfile) as f:
        spellobj = f.readlines()
        sorted_spellfile = sorted(spellobj)
    return sorted_spellfile


if __name__ == '__main__':
    args = sys.argv[:]
    if len(args) < 2:
        sys.exit('Error. Please provide a path to the file to edit')
    for i in args[1:]:
        spell_list = sortfile(i)
        fixed = fix_spellfile(spell_list)
        with open(i, 'wt') as f:
            f.writelines(fixed)

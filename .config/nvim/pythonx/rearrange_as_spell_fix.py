#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""2018-09-03
This shouldn't be so hard

Week 1 - Problem Set 1 - Problem 3:

.. todo::

    Probably need to check that this works.
    Then drop the prompt back in here.
"""
import string
import random


def rstr():
    """Produce a random string."""
    return ''.join(random.choice(string.ascii_lowercase) for i in range(10))


def main():
    """Outside of the return statement this'll be what I send in.

    Also only this, the rest is to make sure that it's a functional module
    even though that's unnecessary.
    """
    mapped = {}
    for idx, ltr in enumerate(s):
        mapped[idx] = ltr

    running = 0
    longest = []

    for i in range(len(mapped) - 1 ):
        if mapped[i] < mapped[i+1]:
            longest.append(mapped[i])
        elif mapped[i] > mapped[i+1]:
            longest.append(mapped[i])
            # lets record what our longest was
            if len(longest) > running:
                running = len(longest)
                run_str = longest
            longest = []

    return run_str


if __name__ == "__main__":
    s = rstr()
    print("There's your starting string.")
    print(s)
    run_str = main()
    print("Here's the longest continuous subsection of increasing letters.")
    print(run_str)

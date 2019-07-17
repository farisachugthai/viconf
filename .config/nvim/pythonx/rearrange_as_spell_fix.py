#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Sort a list of words and then remove the duplicate entries therein."""
import vim  # pylint:disable=import-error


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

    for i in range(len(mapped) - 1):
        if mapped[i] < mapped[i + 1]:
            longest.append(mapped[i])
        elif mapped[i] > mapped[i + 1]:
            longest.append(mapped[i])
            # lets record what our longest was
            if len(longest) > running:
                running = len(longest)
                run_str = longest
            longest = []

    return run_str


if __name__ == "__main__":
    run_str = main()

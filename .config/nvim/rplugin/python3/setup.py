#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""I don't know if this is actually necessary but here's hoping."""
from setuptools import setup, find_packages

setup(
    name='personal_rpc',
    version=0.1,
    content_type='text/restructuredtext',
    url='https://github.com/farisachugthai/viconf',
    packages=find_packages(exclude=('tests')),
    include_package_data=True,
    package_data={
        '': ['*.txt', '*.rst', '*.md'],
    },
    # entry_points=
    license='MIT',
)

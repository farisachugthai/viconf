# Viconf Makefile
# May 08, 2019

BUILD_VIRTUAL_ENV:=build/venv

$(dir $(BUILD_VIRTUAL_ENV)):
	mkdir -p $@

$(BUILD_VIRTUAL_ENV): | $(dir $(BUILD_VIRTUAL_ENV))
	python -m venv $@

$(BUILD_VIRTUAL_ENV)/bin/vint: | $(BUILD_VIRTUAL_ENV)
	$|/bin/python -m pip install vim-vint

$(BUILD_VIRTUAL_ENV)/bin/flake8: | $(BUILD_VIRTUAL_ENV)
	$|/bin/python -m pip install -q flake8==3.5.0

$(BUILD_VIRTUAL_ENV)/bin/pynvim: | $(BUILD_VIRTUAL_ENV)
	$|/bin/python -m pip install pynvim


vint: $(BUILD_VIRTUAL_ENV)/bin/vint
	$(BUILD_VIRTUAL_ENV)/bin/vint after autoload ftplugin plugin

flake8: $(BUILD_VIRTUAL_ENV)/bin/flake8
	$(BUILD_VIRTUAL_ENV)/bin/flake8 pythonx/jedi_*.py

run: $(BUILD_VIRTUAL_ENV)/bin/pynvim

check: vint flake8

clean:
	rm -rf build

.PHONY: install check clean vint flake8

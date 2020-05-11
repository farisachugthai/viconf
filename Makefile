# Viconf Makefile
# May 08, 2019

PYTHON ?= python3

BUILD_VIRTUAL_ENV:=.venv
source    := $(shell source)
activate=$(BUILD_VIRTUAL_ENV)/bin/activate

.PHONY: install check clean vint flake8

help:
	@echo "Please use one of the following targets.:"
	@echo "venv"
	@echo "vint"
	@echo "flake8"
	@echo "lint"
	@echo "clean"

venv:
	@echo "Making a venv\n"
	@$(PYTHON) -m venv --prompt nvim $(BUILD_VIRTUAL_ENV)
	@echo "Activating it\n"
	$(source) $(activate)
	$(PYTHON) -m pip install vim-vint 
	$|/bin/python -m pip install -q flake8>=3.5.0

vint: $(BUILD_VIRTUAL_ENV)/bin/vint
	$(BUILD_VIRTUAL_ENV)/bin/vint after autoload ftplugin plugin

flake8: $(BUILD_VIRTUAL_ENV)/bin/flake8
	$(BUILD_VIRTUAL_ENV)/bin/flake8 pythonx

run: $(BUILD_VIRTUAL_ENV)/bin/pynvim

lint:
	vint after autoload ftplugin plugin syntax

# clean:
# 	rm -rf build

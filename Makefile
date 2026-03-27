SHELL := bash

.PHONY: setup format

setup:
	./scripts/setup.sh

format:
	./scripts/format.sh

lint:
	./scripts/lint.sh

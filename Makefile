SHELL := bash

.PHONY: setup format test lint

setup:
	./scripts/setup.sh

format:
	./scripts/format.sh

test:
	./scripts/test.sh

lint:
	./scripts/lint.sh

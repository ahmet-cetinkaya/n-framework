# Implementation Plan: Phase 1 - Workspace and Core Foundations

## Overview

This plan orchestrates the implementation of Phase 1 to establish the foundational workspace model and CLI entry point.

## Module Split

This phase involves the `nfw` CLI module:

1. **src/nfw** - Rust CLI implementation
   - Command parsing and routing (CLI-only)
   - Interactive prompting and non-interactive command workflows
   - Template catalog management
   - Workspace and service generation orchestration
   - Architecture validation rules

## Validation Expectations

### Cross-Module Validation

- Generated services must follow the standard 4-layer structure
- Layer boundaries must be enforced across all generated code
- Integration tests must verify end-to-end workspace creation and service generation

### CI Validation

- Smoke tests for CLI commands (`templates`, `new`, `add service`, `check`)
- Architecture validation tests with valid and invalid fixtures
- Build and test workflows for generated samples ensuring Native AOT compatibility

## Downstream Spec Map

The `nfw` CLI repository requires its own specification:

1. **src/nfw/specs/** - CLI specification

See [tasks.md](./tasks.md) for detailed spec instruction text for each downstream specification.

## Integration Points

- Template metadata schema must be agreed upon before CLI implementation begins
- Namespace conventions must be locked before service scaffolding is implemented
- Architecture rule definitions must be stable before `nfw check` implementation begins
- Benchmark harness must be defined to validate SC-001 performance target (workspace creation in <1 second on 2 CPU cores, 4GB RAM)

## Risk Mitigation

- Freeze workspace conventions at phase boundary to avoid generator churn
- Add smoke tests early for interactive and non-interactive command paths
- Focus exclusively on CLI implementation to ensure a stable foundation before TUI or complex abstractions are added

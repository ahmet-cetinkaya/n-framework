# Implementation Plan: Phase 1 - Workspace and Core Foundations

## Overview

This plan orchestrates the implementation of Phase 1 across multiple module repositories. The meta-repo consumes changes from submodules and provides cross-cutting validation.

## Module Split

This phase involves the nfw CLI module and core framework packages created as needed:

1. **src/nfw** - Rust CLI/TUI implementation
   - Interactive and non-interactive command workflows
   - Template catalog management
   - Workspace and service generation orchestration
   - Architecture validation

2. **Core Framework Packages** (created as needed):
   - Domain abstractions: `Entity<TId>`, AggregateRoot, ValueObject, DomainEvent
   - Application abstractions: Result types, CQRS contracts, validation
   - Specific module structure to be determined based on framework requirements

## Validation Expectations

### Cross-Module Validation

- Generated services must reference only allowed NFramework packages
- Layer boundaries must be enforced across all generated code
- Domain and Application packages must remain free of infrastructure dependencies
- Integration tests must verify end-to-end workspace creation and service generation

### CI Validation

- Smoke tests for CLI commands (templates, new, add service, check)
- Architecture validation tests with valid and invalid fixtures
- AOT compatibility checks for generated samples
- Single-command build and test workflows

## Downstream Spec Map

Each module repository requires its own specification:

1. **src/nfw/specs/** - CLI/TUI specification
2. **Core framework packages** (specs to be created as needed based on package structure decisions)

See [tasks.md](./tasks.md) for detailed spec instruction text for each downstream specification.

## Integration Points

- Template metadata schema must be agreed upon before CLI and template repository implementation begins
- Namespace conventions must be locked before service scaffolding is implemented
- Architecture rule definitions must be stable before validation implementation begins
- Benchmark harness must be defined to validate SC-001 performance target (workspace creation in <1 second on 2 CPU cores, 4GB RAM)

## Risk Mitigation

- Freeze workspace conventions at phase boundary to avoid generator churn
- Add smoke tests early for interactive and non-interactive command paths
- Keep domain and application packages free from infrastructure references from first generated sample

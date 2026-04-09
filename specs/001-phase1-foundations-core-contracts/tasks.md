# Downstream Specification Tasks

This document identifies the project-level specifications that must be created in module repositories to implement the Phase 1 orchestrator specification.

Tasks are organized by feature. Each feature produces one spec in its most natural location. CLI command parsing concerns are folded into each command's feature spec rather than isolated separately.

## F1 — Template System

### F1-T001

- [x] Create spec topic in `src/nfw/specs/` with spec instruction: Define the template metadata schema, template repository format, git-based template discovery, template versioning rules, and the `nfw templates` command that lists available starter templates with identifiers, descriptions, and git repository URLs, supporting both local and remote template repositories.

_Status_: Completed as `src/nfw/specs/001-nfw-template-system/`.

_Maps to_: M1-T001, M2-T005

## F2 — Workspace Scaffolding

### F2-T001

- [x] Create spec topic in `src/nfw/specs/` with spec instruction: Define the workspace folder structure, namespace conventions, solution file organization, configuration file locations and formats; implement the CLI command parsing and routing system; implement the `nfw new` command that creates a new workspace with the documented folder structure, solution files, and baseline configuration, supporting interactive prompting and `--template <id>` and `--no-input` flags.

_Status_: Completed as `src/nfw/specs/002-workspace-structure-new-command/`.

_Maps to_: M1-T002, M2-T001, M2-T002

## F3 — Service Scaffolding

### F3-T001

- [x] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw add service <name> --template dotnet` command that generates a .NET service with Domain, Application, Infrastructure, and Api layers, enforcing layer dependency rules and including sample health endpoints.

_Status_: Completed as `src/nfw/specs/003-add-service-dotnet-template-based/`.

_Maps to_: M2-T003

## F4 — Architecture Validation

### F4-T001

- [x] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw check` command that scans a workspace for forbidden project references and forbidden namespace or package usage, exiting with non-zero status when violations are found and providing actionable error messages; include architecture validation test fixtures proving detection of valid and invalid cases.

_Status_: Completed as `src/nfw/specs/004-nfw-check-validation/`.

_Maps to_: M2-T004, M2-T007

## F5 — Build & Test Workflows

### F5-T001

- [x] Create spec topic in `specs/` (root) with spec instruction: Implement CLI smoke tests validating template selection, workspace generation, and service scaffolding workflows for both interactive and non-interactive modes; define and implement single-command build and single-command test workflows for generated samples ensuring they succeed on first run from workspace root; define benchmark harness to validate SC-001 performance target (workspace and service creation in <1 second on baseline hardware: 2 CPU cores, 4GB RAM).

_Status_: Completed as `src/nfw/specs/005-build-test-workflows/`.

_Maps to_: M2-T006, M2-T008, M2-T009

## Notes

- Each feature above should become a single specification in the target location
- Use the exact spec instruction text provided when creating each downstream specification
- Refer to the parent orchestrator spec (`spec.md`) for complete context on each requirement
- The feature numbering (F1–F5) reflects implementation priority: F1 (templates) is foundational, F2–F3 are P1 user stories, F4–F5 are P2/cross-cutting
- F6 (TUI) is postponed; Phase 1 focuses on CLI-only interface and workspace scaffolding
- Domain and Application package specs are deferred to later phases

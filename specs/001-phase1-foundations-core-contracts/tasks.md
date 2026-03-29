# Downstream Specification Tasks

This document identifies the project-level specifications that must be created in module repositories to implement the Phase 1 orchestrator specification.

## Task Organization

Tasks are organized by milestone (M1, M2, M3) as defined in the ROADMAP.

## Milestone 1: Workspace Structure and Template Metadata

### M1-T001

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Define the template metadata schema, template repository format, git-based template discovery, and template versioning rules for the nfw CLI template system.

### M1-T002

- [ ] Create spec topic in `specs/` (root) with spec instruction: Define the workspace folder structure, namespace conventions, solution file organization, and configuration file locations and formats for NFramework workspaces.

## Milestone 2: Rust CLI/TUI Implementation

### M2-T001

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the nfw CLI/TUI command parsing and routing system supporting `nfw templates`, `nfw new`, and `nfw add service --lang dotnet` commands with both interactive and non-interactive workflows.

### M2-T002

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw new` command that creates a new workspace with documented folder structure, solution files, and baseline configuration, supporting interactive prompting and `--template <id>` and `--no-input` flags.

### M2-T003

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw add service <name> --lang dotnet` command that generates a .NET service with Domain, Application, Infrastructure, and Api layers, enforcing layer dependency rules and including sample health endpoints.

### M2-T004

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw check` command that scans a workspace for forbidden project references and forbidden namespace or package usage, exiting with non-zero status when violations are found and providing actionable error messages.

### M2-T005

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw templates` command that lists available starter templates with identifiers, descriptions, and git repository URLs, supporting both local and remote template repositories.

### M2-T006

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement CLI smoke tests that validate template selection, workspace generation, and service scaffolding workflows for both interactive and non-interactive modes.

### M2-T007

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement architecture validation test fixtures that prove detection of valid and invalid architecture cases, covering forbidden project references and namespace/package violations.

### M2-T008

- [ ] Create spec topic in `src/nfw/specs/` or `specs/` (root) with spec instruction: Define and implement single-command build and single-command test workflows for generated samples, ensuring they succeed on first run from workspace root.

### M2-T009

- [ ] Create spec topic in `src/nfw/specs/` or `specs/` (root) with spec instruction: Define benchmark harness to validate SC-001 performance target (workspace and service creation in <3 seconds on baseline hardware: 2 CPU cores, 4GB RAM).

## Milestone 3: Core Framework Abstractions

### M3-T001

- [ ] Determine core framework package structure and naming conventions based on Phase 1 requirements

### M3-T002

- [ ] Create spec topics for core framework packages as needed (Domain abstractions, Application abstractions, etc.) with appropriate spec instruction text for each package's responsibilities

Note: Core framework packages will be created as needed during implementation. Specific package locations (e.g., `src/NFramework.Domain/specs/`) will be determined based on the chosen package structure.

## Notes

- Each task above should become a separate specification in the target module repository
- Use the exact spec instruction text provided when creating each downstream specification
- Refer to the parent orchestrator spec (`spec.md`) for complete context on each requirement
- The numbering (M1-T001, M2-T001, etc.) correlates to milestones in the ROADMAP

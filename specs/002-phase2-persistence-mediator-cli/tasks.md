# Downstream Specification Tasks

This document identifies the module-level specifications that must be created to implement the Phase 2 orchestrator specification for the compile-time application model.

## Approach: Package-by-Package

Each package is developed **end-to-end** before moving to the next:

- Abstractions (interfaces, base types)
- Implementations (technology-specific adapters)
- Source generators (Roslyn incremental generators)
- CLI templates (mustache templates in nfw-templates)
- Tests (unit and integration)

## Package Structure

```
src/core-persistence-dotnet/
├── NFramework.Persistence.Abstractions/
├── NFramework.Persistence.EFCore/
└── NFramework.Persistence.Generators/

src/core-mediator-dotnet/
├── NFramework.Mediator.Abstractions/
├── NFramework.Mediator.Mediator/
└── NFramework.Mediator.Generators/

src/nfw/  (already exists)
```

---

## P1 — Mediator Package

### P1-T001

- [ ] Create spec topic in `src/core-mediator-dotnet/specs/` with spec instruction: Define the `NFramework.Mediator.Abstractions` NuGet package providing CQRS abstractions including marker interfaces, handler interface, pipeline behavior interface, event interface, and mediator interface; ensure zero dependency on infrastructure packages; include unit tests proving compile-time handler discovery.

_Maps to_: US1, US4, FR-002, FR-019

### P1-T002

- [ ] Create spec topic in `src/core-mediator-dotnet/specs/` with spec instruction: Define the `NFramework.Mediator.Mediator` NuGet package providing adapter implementation for [martinothamar/Mediator](https://github.com/martinothamar/Mediator) with custom pipeline behaviors for validation, transactions, and logging; support behavior execution order and short-circuiting; ensure compatibility with MediatR v12+; include unit tests proving behavior execution.

_Maps to_: US4, FR-020, FR-021, FR-022

### P1-T003

- [ ] Create spec topic in `src/core-mediator-dotnet/specs/` with spec instruction: Define the `NFramework.Mediator.Generators` source generator package using incremental Roslyn API to discover handler implementations and emit DI registration code; emit diagnostics for unsupported patterns; ensure generated code is trimmable and AOT-compatible; include golden-file tests and AOT build validation.

_Maps to_: US2, FR-007, FR-009, FR-011

---

## P2 — Persistence Package

### P2-T001

- [ ] Create spec topic in `src/core-persistence-dotnet/specs/` with spec instruction: Define the `NFramework.Persistence.Abstractions` NuGet package providing repository abstractions, entity base classes, and pagination interfaces; support CRUD operations, transactions, dynamic querying, and bulk operations; ensure zero coupling to specific persistence implementations; include unit tests with in-memory fakes.

_Maps to_: US1, FR-004

### P2-T002

- [ ] Create spec topic in `src/core-persistence-dotnet/specs/` with spec instruction: Define the `NFramework.Persistence.EFCore` NuGet package providing Entity Framework Core implementation of repository abstractions with DbContext injection, unit of work, and configuration extensions; support ChangeTracker integration and eager loading; include integration tests with SQLite in-memory database.

_Maps to_: US1, FR-004

### P2-T003

- [ ] Create spec topic in `src/core-persistence-dotnet/specs/` with spec instruction: Define the `NFramework.Persistence.Generators` source generator package using incremental Roslyn API to discover repository interface declarations and emit DI registration code; emit diagnostics for configuration errors; ensure generated code is trimmable and AOT-compatible; include golden-file tests and AOT build validation.

_Maps to_: US2, FR-007, FR-009

---

## P3 — CLI Commands (nfw)

### P3-T001

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw gen command <NAME> <FEATURE>` command with interactive prompts for options; support `--no-input` flag and `--project` parameter; generate command record and handler class following documented conventions; validate generated code compiles; complete in <5 seconds; include integration tests.

_Maps to_: US3, FR-012, FR-016, FR-018

### P3-T002

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw gen query <NAME> <FEATURE>` command with interactive prompts; support `--no-input` and `--project` flags; generate query record and handler class; follow layer placement conventions; complete in <3 seconds; include integration tests.

_Maps to_: US3, FR-013

### P3-T003

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw gen crud <NAME> --props <DEFINITIONS>` command that generates complete CRUD scaffolding including entity class, repository interface, DTOs, commands, queries, handlers, and HTTP endpoints; support `--id-type` parameter; create feature folder structure automatically; complete in <10 seconds; include integration tests.

_Maps to_: US3, FR-014

### P3-T004

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw check` command that validates workspace architecture rules by scanning for forbidden dependencies, namespace violations, and banned packages; exit with non-zero status when violations found; provide actionable error messages; support `--ci` and `--verbose` flags; complete in <2 seconds; include integration tests.

_Maps to_: US5, FR-023, FR-024

### P3-T005

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Add mustache templates and configurations to `src/nfw-templates/` for scaffolding commands, queries, crud, and API endpoints according to NFramework conventions; ensure templates generate AOT-compatible code; configure template metadata to drive nfw generation flow without hardcoded logic; include integration tests.

_Maps to_: US3, FR-016, FR-018

---

## Package Dependencies

```
P1: core-mediator-dotnet (foundational CQRS)
  ↓
P2: core-persistence-dotnet (depends on Mediator abstractions)
  ↓
P3: nfw CLI (orchestrates both packages)
```

---

## Implementation Strategy

### MVP Scope

**Complete packages in order:**

1. P1 (Mediator)
2. P2-T001 to P2-T003 (Persistence)
3. P3-T001 to P3-T003 (nfw CLI)

**MVP validates:**

- Abstractions work
- Source generators emit trimmable code
- CLI generates compilable artifacts
- AOT publishing succeeds

### Incremental Delivery

Each package is independently testable and releasable:

- P1 releases first
- P2 releases after P1
- P3 releases incrementally

### Parallel Execution Opportunities

**Within P1:**

- P1-T001 must complete first
- P1-T002 and P1-T003 can run in parallel after P1-T001

**Within P2:**

- P2-T001 must complete first
- P2-T002 and P2-T003 can run in parallel after P2-T001

**Within P3:**

- P3-T005 must complete first
- P3-T001 to P3-T004 can run in parallel after P3-T005

---

## Success Criteria Tracking

Each specification must reference relevant success criteria:

- **SC-001**: Generated code is Native AOT compatible
- **SC-002**: No runtime reflection for handler discovery
- **SC-005**: Command generation <5s, query <3s, entity <10s
- **SC-006**: Architecture validation <2s
- **SC-010**: Zero coupling from domain to infrastructure
- **SC-011**: Support empty handler sets without errors

---

## Notes

- Each package creates a **single specification** with multiple tasks
- Use the exact spec instruction text when creating downstream specifications
- Refer to the parent orchestrator spec (`spec.md`) for complete context
- Templates live in `src/nfw-templates/` with mustache format and configuration files
- nfw reads template configurations to drive generation flow (no hardcoded logic)
- All source generators must use `IIncrementalGenerator` API
- Generated code placed in `.g.cs` files with `generated` attribute
- Package versions follow semantic versioning

---

## External Dependencies

**martinothamar/Mediator**: Used as the underlying MediatR implementation. Our adapter provides custom pipeline behaviors and integration with our abstractions.

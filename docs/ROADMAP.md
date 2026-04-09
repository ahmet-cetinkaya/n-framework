# NFramework Roadmap

This document translates the current product direction into a phased delivery roadmap.

It is intentionally narrower than the PRD:

- It focuses on delivery order, milestone boundaries, and release gates
- It keeps the first externally consumable beta scoped to the `.NET` service path
- It separates the beta release gate from lower-priority beta follow-on work when the PRD marks those items as important but not on the critical path
- It keeps distributed `.NET` features, polyglot support, and ecosystem tooling behind a stable standalone `.NET` path
- It assumes the CLI is Rust-based so it stays fast, portable, and easy to extend

For the full product definition, see [PRD.md](./PRD.md).

## Current Direction

NFramework is being developed as a compile-time-first framework and workspace standard for modern services.

The current execution strategy is:

- Initial delivery proves the standalone `.NET 11` reference path first
- The first public beta must validate CLI experience, architecture enforcement, compile-time generation, and Native AOT readiness before distributed features expand the surface area
- Distributed `.NET` microservice features follow only after the standalone `.NET` service path is stable
- Polyglot support follows only after the `.NET` conventions, contract model, and workspace standard are durable
- The CLI layer is planned as Rust tooling that drives the workspace and service workflows
- TUI is deferred until after the .NET framework path is fully proven (workspace, compile-time generation, core capabilities, beta, distributed features, and polyglot)
- MCP-compatible tooling remains part of the product direction, but it should not displace the beta-critical `.NET` workflow

## Planning Assumptions

This roadmap assumes:

- A core delivery team of `4` engineers through beta, expanding to `5` engineers for distributed `.NET` and polyglot phases
- Shared support from `0.5` QA automation throughout the roadmap and `0.5` technical writing support starting in beta hardening
- A Rust CLI engineer owns the CLI layer and keeps interactive and scripted entry points aligned
- Phase boundaries are driven by the priorities in PRD sections `3`, `6`, `11`, and `12`, not by calendar convenience alone
- When PRD sections disagree on sequencing detail, planning follows the more concrete implementation constraints in section `11`, and the dependency is called out explicitly in the relevant phase

## Beta Release Gate

The first public beta is the first point at which the standalone `.NET` service path can be evaluated against the PRD success metrics and core user workflows.

Included in the beta release gate:

- [ ] `nfw templates`, `nfw new`, and `nfw add service --lang dotnet`
- [ ] One-command build and one-command test workflows for generated samples
- [ ] `NFramework.Domain` and `NFramework.Application`
- [ ] Result-based application flow and workflow contracts
- [ ] Framework-native CQRS execution for commands, queries, events, stream requests, and behaviors
- [ ] Source-generated DI registration and Minimal API route generation
- [ ] Architecture validation through `nfw check`
- [ ] End-to-end feature generation for commands, queries, and CRUD workflows, with the final command contract resolved during the beta train
- [ ] Topic abstractions and first-party adapters required to prove the standalone `.NET` service path
- [ ] Quickstart, architecture guidance, and feature-complete `.NET` documentation
- [ ] Continuous validation for Native AOT, trimming, smoke tests, and benchmark KPIs

Beta follow-on items that remain in PRD scope but are not on the critical path for the first external beta cut:

- [ ] Localization and translation adapters
- [ ] Mailing adapters
- [ ] Search adapters

These follow-on items remain part of the broader beta train because PRD section `6` keeps them in initial beta scope, while PRD section `11` explicitly deprioritizes some of them to shortly after beta if the core path needs protection.

## Phase 1: Workspace and Core Foundations

Target window: April-May 2026

Goal:
Establish the Rust CLI, workspace shape, service scaffold, template system, architecture validation, and build/test workflows needed for every later generator and adapter investment.

Why this phase matters:
This phase creates the shortest path to the PRD promise of one-command workspace setup, enforceable Clean Architecture boundaries, and a usable `.NET` baseline that later compile-time tooling can rely on.

Milestones:

- [ ] M1: Lock workspace structure, namespace conventions, and template metadata model
- [ ] M2: Ship the Rust `nfw` CLI (CLI-only), including `nfw templates`, `nfw new`, and `nfw add service --lang dotnet`
- [ ] M3: Establish baseline architecture rules and `nfw check` validation

Planned deliverables:

- [ ] Rust CLI skeleton with deterministic command parsing for template selection and workspace setup
- [ ] Template catalog, template version rules, and remote catalog support (`nfw templates`)
- [ ] Workspace creation with documented build and test commands (`nfw new`)
- [ ] `.NET` service scaffold with `Domain`, `Application`, `Infrastructure`, and `Api` projects (`nfw add service --lang dotnet`)
- [ ] Sample health or readiness endpoint in generated services
- [ ] Initial layer rules, package boundaries, and forbidden dependency definitions
- [ ] Architecture validation via `nfw check` for forbidden references, namespaces, and packages
- [ ] CLI smoke tests for template selection, workspace generation, and service scaffolding (interactive and non-interactive modes)
- [ ] Single-command build and single-command test workflows for generated samples
- [ ] Benchmark harness validating workspace and service creation performance targets

Dependencies:

- [ ] Finalize generated folder, namespace, and solution conventions before source generator work begins
- [ ] Finalize the Rust CLI command model before generator work begins
- [ ] Define the sample workspace used by smoke tests, AOT checks, and future generator fixtures
- [ ] Keep build and test entry points stable so later phases do not break onboarding

Risk mitigation:

- [ ] Freeze workspace conventions at the phase boundary to avoid generator churn in later phases
- [ ] Add smoke tests early for interactive and non-interactive command paths
- [ ] Validate CLI usability with real developer workflows before phase exit

Exit criteria:

- [ ] A new `.NET` workspace and service can be created from the Rust CLI
- [ ] Generated projects compile without manual file edits
- [ ] Template selection works in interactive and non-interactive flows
- [ ] Architecture validation detects violations with actionable remediation hints
- [ ] The project exposes a documented single build command and single test command
- [ ] CLI smoke tests pass for all Phase 1 command scenarios

PRD traceability:

- [ ] Section `3`: goals for CLI workflow, coherent `.NET` service framework, architecture enforcement, and time-to-first-service
- [ ] Section `6`: initial beta scope for CLI, service creation, and documentation
- [ ] Section `7`: `US-001`, `US-002`
- [ ] Section `8`: `FR-1` to `FR-6`, `FR-11`, `FR-36`
- [ ] Section `11`: template determinism, one-command build/test workflows, and the CLI implementation choice reflected in this roadmap

## Phase 2: Compile-Time Application Model

Target window: June-August 2026

Goal:
Prove the compile-time-first application model by delivering the CQRS pipeline, command, query, and CRUD generation, generator-backed wiring for DI and Minimal APIs, and establishing the foundational .NET core packages (`NFramework.Core.*`) containing the base abstractions and contracts.

Why this phase matters:
This phase validates the core product claim that NFramework can replace runtime reflection and repetitive wiring with deterministic generation without sacrificing developer clarity or AOT compatibility.

Milestones:

- [ ] M4: Deliver foundational .NET core packages (`NFramework.Core.*`) containing base abstractions for Domain, Application, Persistence, Security, and Cross-Cutting Concerns
- [ ] M5: Deliver source-generated DI registration and Minimal API route generation
- [ ] M6: Deliver interactive wizard-like command, query, and CRUD generation with architecture validation, including feature folder auto-creation and all cross-cutting concern options

Planned deliverables:

- [ ] `NFramework.Core.Domain`, `NFramework.Core.Application`, `NFramework.Core.Persistence`, `NFramework.Core.Security`, `NFramework.Core.Mediator`, `NFramework.Core.Mapper`, and `NFramework.Core.CrossCuttingConcerns` (abstractions only)
- [ ] Domain abstractions for `Entity<TId>`, `AggregateRoot`, `ValueObject`, and `DomainEvent`
- [ ] Application contracts for commands, queries, events, stream requests, business rules, pageable requests, and pipeline behaviors
- [ ] `nfw add command`, `nfw add query`, and `nfw add entity` (CRUD) with interactive wizard-like prompts for all arguments and options
- [ ] Support for feature folder auto-creation if the target feature doesn't exist
- [ ] Optional workflow markers for `--caching`, `--logging`, `--transaction`, and `--secured` (SecuredOperation)
- [ ] Support for API exposure and HTTP method selection (`--api`, `--endpoint-method`)
- [ ] Support for targeting specific projects in the workspace (`--project`)
- [ ] First usable CQRS dispatch pipeline for generated services
- [ ] End-to-end CRUD scaffolding for generated services
- [ ] Source-generated DI registration with deterministic output and diagnostics
- [ ] Source-generated Minimal API route mapping with documented naming conventions
- [ ] `nfw check` for forbidden references, namespaces, and packages
- [ ] Build fixtures for empty and non-empty generator scenarios
- [ ] AOT and trimming checks integrated into CI for generated samples

Dependencies:

- [ ] Phase `1` workspace, service, and CLI conventions must remain stable
- [ ] Generators and analyzers must share one metadata and naming model
- [ ] The Rust CLI public command model must be frozen before documentation and release hardening begin
- [ ] Sample services must exist for benchmark and integration coverage

Risk mitigation:

- [ ] Use golden-file tests for generated registration and route output
- [ ] Treat runtime assembly scanning as a blocked design path
- [ ] Add CI gates for empty project sets, unsupported patterns, and analyzer diagnostics
- [ ] Freeze public command syntax at the end of the phase to protect downstream documentation work

Exit criteria:

- [ ] Generated services can execute command and query flows through NFramework abstractions
- [ ] DI registration and route mapping require no runtime reflection
- [ ] Architecture violations fail in CI with actionable remediation hints
- [ ] Generated samples remain trimmable and AOT-friendly

PRD traceability:

- [ ] Section `3`: goals for compile-time generation, architecture enforcement, and low-boilerplate workflows
- [ ] Section `5`: principles for compile-time behavior and exception-free business flow
- [ ] Section `7`: `US-003`, `US-004`, `US-007`, `US-008`, `US-009`, `US-019`, `US-020`
- [ ] Section `8`: `FR-8` to `FR-10`, `FR-16` to `FR-20`, `FR-35`, `FR-37`
- [ ] Section `11`: generators plus analyzers, continuous Native AOT validation, opt-in workflow behaviors, and Rust CLI implementation details

## Phase 3: Core Service Capabilities and Adapters

Target window: September-December 2026

Goal:
Turn the compile-time foundation into a credible `.NET` service platform by delivering the cross-cutting adapters and infrastructure implementations required by most real services.

Why this phase matters:
This phase is where NFramework stops being a scaffold generator and starts behaving like an opinionated application platform that still preserves clean boundaries and replaceable infrastructure.

Milestones:

- [ ] M7: Ship persistence adapters (first EF Core adapter)
- [ ] M8: Ship security adapters (JWT, authenticators)
- [ ] M9: Ship cross-cutting concern adapters (Serilog, FluentValidation, Mapster, etc.)

Planned deliverables:

- [ ] EF Core adapter implementing repository abstractions
- [ ] Default `.NET` security wiring for secured operations and OpenAPI integration (JWT, authenticator flows)
- [ ] Validation adapters (FluentValidation)
- [ ] Mapping adapters (Mapster or manual mapping support)
- [ ] Logging adapters (Serilog)
- [ ] Exception handling and Problem Details integration for the HTTP stack
- [ ] Integration tests for persistence, security, and generated API flows

Dependencies:

- [ ] Phase `2` command and query conventions must remain stable
- [ ] Route and DI generators must support secured and CRUD-generated endpoints
- [ ] Persistence abstractions must be stable before additional adapters are attempted
- [ ] The command contract for CRUD generation must be finalized before public beta documentation is written

Resource estimate:

- `2` framework engineers
- `1` generator and scaffolding engineer
- `1` security and HTTP integration engineer
- `1` persistence and adapter engineer
- `0.5` QA automation support
- Approximate effort: `55-60` engineer-weeks

Risk mitigation:

- [ ] Implement abstraction contract tests before adapter-specific tests
- [ ] Prioritize the first-party adapter list named in PRD section `11` before expanding to lower-priority libraries
- [ ] Keep generated CRUD flows fixture-based so refactors do not silently change output
- [ ] Resolve the `nfw add entity` versus `nfw add crud` scope mismatch between PRD sections `7` and `11` before the milestone freeze

Exit criteria:

- [ ] A generated service can persist data, secure operations, and expose CRUD endpoints with minimal manual wiring
- [ ] Domain and application layers remain isolated from adapter-specific types
- [ ] Integration tests validate repository, authentication, and authorization workflows
- [ ] Generated services still build and test through the documented commands

PRD traceability:

- [ ] Section `3`: goals for topic support, adapter-based design, and repeatable service generation
- [ ] Section `5`: principles for replaceable adapters and pure core
- [ ] Section `6`: initial beta scope for topic packages and adapters
- [ ] Section `7`: `US-003`, `US-010`, `US-011`, `US-021`, `US-022`, `US-023`
- [ ] Section `8`: `FR-7`, `FR-21` to `FR-34`
- [ ] Section `11`: first-class beta abstractions and first-party adapter priorities

## Phase 4: Beta Hardening and Public Beta

Target window: January-March 2027

Goal:
Close the beta gate with documentation, KPI validation, release hardening, and a clear separation between beta-critical scope and beta-train follow-on items.

Why this phase matters:
This phase converts engineering completeness into product readiness by proving the PRD success metrics, making onboarding reliable, and keeping scope discipline around the first public beta.

Milestones:

- [ ] M10: Publish quickstart, architecture guidance, and troubleshooting
- [ ] M11: Lock benchmark harness and pass AOT, startup, and generation KPIs
- [ ] M12: Cut the first public beta and schedule beta follow-on packages

Planned deliverables:

- [ ] Quickstart documentation from workspace creation to running sample
- [ ] Architecture documentation covering layer responsibilities and forbidden dependencies
- [ ] Documentation for templates, service creation, command generation, query generation, CRUD workflows, supported feature options, and extension points
- [ ] Troubleshooting guidance for generator, configuration, and local setup failures
- [ ] Continuous benchmark reporting for workspace creation time, CRUD generation time, and cold start
- [ ] Release checklists for AOT, trimming, smoke tests, and CI reproducibility
- [ ] Beta follow-on packaging plan for localization, translation, mailing, and search if those items threaten the public beta date

Dependencies:

- [ ] Core `.NET` beta workflows must already be functional end-to-end
- [ ] Benchmark environment must be finalized before KPI sign-off
- [ ] Public command syntax and template conventions must remain frozen through the beta cut

Resource estimate:

- `3` engineers for hardening and fixes
- `1` engineer shared for release and tooling support
- `1` QA automation engineer
- `0.5` technical writer
- Approximate effort: `30-34` engineer-weeks

Risk mitigation:

- [ ] Treat AOT warnings, trimming warnings, and cold-start regressions as release blockers
- [ ] Protect the beta date by moving lower-priority topic adapters into beta follow-on releases when needed
- [ ] Run onboarding dry-runs with a clean environment before beta approval
- [ ] Keep the beta definition anchored to PRD section `12` metrics, not to an expanding adapter wish list

Exit criteria:

- [ ] A generated hello-world `.NET` service builds with `0` Native AOT or trimming warnings
- [ ] A generated standard `.NET` service cold-starts in less than `50 ms` under the agreed benchmark conditions
- [ ] Generating a standard CRUD flow takes less than `10 seconds`
- [ ] Creating a new workspace completes in less than `1 second` on the agreed baseline machine
- [ ] Generated starter solutions build and test successfully in CI without manual patch steps
- [ ] External adopters can follow the documentation without reverse-engineering generated code

PRD traceability:

- [ ] Section `3`: goals for fast onboarding, AOT readiness, and documentation-backed adoption
- [ ] Section `6`: documentation required for new teams plus broader beta topic scope
- [ ] Section `7`: `US-015`, `US-024`
- [ ] Section `8`: `FR-36`, `FR-37`, `FR-46`
- [ ] Section `11`: continuous Native AOT validation and documented local setup defaults
- [ ] Section `12`: all beta gate success metrics except polyglot metrics

## Phase 5: Distributed `.NET` Expansion

Target window: April-July 2027

Goal:
Expand from standalone `.NET` services into distributed local development, observability defaults, and Dapr-backed platform adapters.

Why this phase matters:
This phase fulfills the PRD promise that cloud-native defaults become part of the framework once the standalone path is proven, without polluting domain or application code with platform-specific concerns.

Milestones:

- [ ] M13: Ship Aspire AppHost and ServiceDefaults generation
- [ ] M14: Ship first-party Dapr adapters for state, pub/sub, and secret workflows
- [ ] M15: Ship `nfw up` and distributed `.NET` guidance

Planned deliverables:

- [ ] Generated `.AppHost` and `.ServiceDefaults` projects
- [ ] Logging, metrics, and tracing enabled by default in distributed samples
- [ ] First-party Dapr adapters for pub/sub, state management, and secret store
- [ ] `nfw up` for local orchestration with actionable startup diagnostics
- [ ] Sample services demonstrating at least one asynchronous event flow and one state interaction
- [ ] Smoke tests for distributed startup and adapter wiring
- [ ] Documentation for distributed `.NET` service development

Dependencies:

- [ ] Standalone `.NET` beta must be stable before distributed features expand the support matrix
- [ ] Messaging and platform abstractions must be mature enough to keep Dapr types out of core layers
- [ ] Local development automation must account for Dapr and Aspire dependencies explicitly

Resource estimate:

- `2` platform and framework engineers
- `1` distributed systems engineer
- `1` CLI and orchestration engineer
- `1` adapter engineer
- `0.5` QA automation support
- Approximate effort: `45-50` engineer-weeks

Risk mitigation:

- [ ] Keep distributed support opt-in at the template and workspace level
- [ ] Validate local dependency setup through automation, not manual README steps
- [ ] Use abstraction conformance tests to prevent Dapr leakage into domain and application layers
- [ ] Keep standalone `.NET` smoke tests running in parallel with distributed test suites

Exit criteria:

- [ ] Developers can boot a distributed `.NET` workspace with the documented workflow
- [ ] Distributed concerns stay behind NFramework abstractions and adapters
- [ ] Generated samples expose logging, metrics, and tracing defaults
- [ ] Distributed startup failures surface actionable diagnostics

PRD traceability:

- [ ] Section `3`: goals for cloud-native defaults after the standalone path is proven
- [ ] Section `5`: cloud-native by default principle
- [ ] Section `6`: post-beta scope for Aspire, Dapr, and local orchestration
- [ ] Section `7`: `US-012`, `US-013`, `US-014`
- [ ] Section `8`: `FR-38`, `FR-39`, `FR-40`
- [ ] Section `11`: Dapr and Aspire local dependency automation

## Phase 6: Interactive TUI Interface

Target window: August-November 2027 (after all .NET expansion phases are stable)

Goal:
Deliver an interactive TUI layer on top of the stable Rust CLI to provide visual workspace management, guided wizards, and real-time feedback for common workflows.

Why this phase matters:
TUI lowers the barrier for teams who prefer guided, visual workflows over CLI-only interaction. By deferring TUI until after the entire .NET framework path — workspace scaffolding, compile-time generation, core service capabilities, beta hardening, and distributed features — is proven, the TUI can wrap a stable, production-ready foundation rather than chasing a moving target.

Milestones:

- [ ] M16: Ship TUI architecture, component library, and navigation model
- [ ] M17: Ship interactive workspace dashboard and service creation wizard
- [ ] M18: Ship command palette, configuration editor, and progress diagnostics

Planned deliverables:

- [ ] TUI component library with dashboard layout, form wizards, and real-time validation feedback
- [ ] Workspace dashboard showing service status, health indicators, recent operations, and quick-action shortcuts
- [ ] Interactive service creation wizard with step-by-step guidance, template preview, and configuration options
- [ ] Command palette with fuzzy search, command history, keyboard shortcuts, and contextual help
- [ ] Configuration editor for workspace and service settings with syntax highlighting and validation
- [ ] Progress indicators, spinners, and diagnostic panels for long-running operations

Dependencies:

- [ ] All core CLI commands (`nfw templates`, `nfw new`, `nfw add service`, `nfw check`, etc.) must have stable, documented behavior contracts
- [ ] Workspace conventions, template system, and service scaffolding must be proven in production use
- [ ] The .NET framework beta must be stable with distributed features (Phase 5) fully validated
- [ ] TUI implementation should follow the stable CLI patterns established in Phase 1-5

Resource estimate:

- `1` Rust CLI/TUI engineer
- `1` framework engineer
- `0.5` QA automation support
- Approximate effort: `20-24` engineer-weeks

Risk mitigation:

- [ ] TUI wraps existing CLI commands; no duplicate business logic
- [ ] All TUI workflows remain available through the CLI for CI and scripting use cases
- [ ] Treat TUI as an optional layer; CLI remains the primary interface

Exit criteria:

- [ ] TUI can create a workspace, scaffold a service, and run architecture validation through guided workflows
- [ ] All TUI actions produce identical results to their CLI equivalents
- [ ] TUI runs on supported terminal platforms without rendering issues

PRD traceability:

- [ ] Section `3`: goals for CLI-driven workflow (CLI remains primary; TUI is complementary)
- [ ] Section `7`: `US-001`, `US-002` (interactive prompting paths)
- [ ] Section `8`: `FR-1`, `FR-5` (interactive and non-interactive workflows)

## Phase 7: Polyglot Standards and Ecosystem Tooling

Target window: December 2027-May 2028

Goal:
Extend the workspace standard beyond `.NET`, add contract sync, and make the CLI and workspace model consumable by later MCP-compatible tooling.

Why this phase matters:
This phase delivers the long-term product vision of one architectural standard across languages while preserving the `.NET` reference path as the source of truth for conventions, contracts, and tooling behavior.

Milestones:

- [ ] M19: Ship Go and Rust service scaffolds using the shared workspace model
- [ ] M20: Ship Protobuf-driven contract sync across supported languages
- [ ] M21: Publish workspace metadata and automation surfaces required for MCP-compatible tooling

Planned deliverables:

- [ ] `nfw add service --lang go`
- [ ] `nfw add service --lang rust`
- [ ] Generated instructions for build, test, and runtime commands in Go and Rust services
- [ ] `nfw sync` for Protobuf-driven contract regeneration
- [ ] Shared contract workflows across at least two supported languages
- [ ] Cross-language sample validating one gRPC contract
- [ ] Stable workspace metadata and CLI surfaces for future MCP-compatible tool and agent integrations
- [ ] Documentation for polyglot workspace conventions and contract ownership

Dependencies:

- [ ] `.NET` conventions, folder structure, and contract placement must already be stable
- [ ] Protobuf ownership rules and generated artifact locations must be deterministic
- [ ] Language-specific scaffolds must preserve the same architectural expectations without forcing `.NET` implementation details into non-`.NET` services

Resource estimate:

- `2` framework engineers
- `1` Go or Rust engineer
- `1` tooling and contract-sync engineer
- `1` DX and documentation engineer
- `0.5` QA automation support
- Approximate effort: `50-56` engineer-weeks

Risk mitigation:

- [ ] Start with scaffold parity and documentation before deep runtime feature parity
- [ ] Use one shared conformance checklist for folder structure, build commands, and layer boundaries across languages
- [ ] Keep generated contract locations deterministic to avoid drift across languages
- [ ] Treat MCP-compatible tooling as a consumer of stable CLI and workspace contracts rather than a driver of architectural changes

Exit criteria:

- [ ] Go and Rust services follow the same NFramework structure and boundary rules
- [ ] Shared contracts can be regenerated through one documented workflow
- [ ] At least two languages interoperate through the same Protobuf contract flow
- [ ] Polyglot expansion does not weaken the `.NET` service path

PRD traceability:

- [ ] Section `1`: long-term polyglot and MCP-compatible product vision
- [ ] Section `3`: goals for one standard across languages and contract-driven inter-service communication
- [ ] Section `5`: one standard, many languages principle
- [ ] Section `6`: post-beta scope for Go, Rust, MCP-compatible tooling, and Protobuf sync
- [ ] Section `7`: `US-016`, `US-017`, `US-018`
- [ ] Section `8`: `FR-41` to `FR-45`
- [ ] Section `12`: polyglot structure-understanding and cross-language gRPC metrics

## Cross-Cutting Priorities

These priorities apply across all phases:

- [ ] Keep domain and application layers independent from implementation-specific libraries
- [ ] Keep the `.NET` service path coherent as abstractions, adapters, and generators expand
- [ ] Prefer framework abstractions plus adapters over direct library coupling
- [ ] Maintain Native AOT and trimming compatibility as product-level constraints
- [ ] Keep generated code readable, reviewable, and deterministic
- [ ] Keep build, test, and benchmark workflows simple and repeatable
- [ ] Use CI smoke tests and fixture-based generation tests as release blockers, not as optional quality improvements

## Remaining Planning Dependencies

The roadmap still depends on a small number of product-level decisions or clarifications:

- [ ] Resolve the command contract for CRUD generation between PRD section `7` (`US-003`) and section `11`
- [ ] Confirm whether localization, translation, mailing, and search ship in the first public beta or in beta follow-on releases within the same beta train
- [ ] Align the PRD technical consideration for CLI implementation language with the Rust CLI roadmap decision
- [ ] Lock the benchmark environment used for startup and generation KPI sign-off
- [ ] Define the minimum stable surface required before MCP-compatible tooling work begins

## Notes

- This roadmap is directional and should be updated whenever the PRD changes materially.
- If beta scope expands, the roadmap should be revised explicitly rather than allowing milestone drift.
- If staffing drops below the planning assumption, the first public beta should slip rather than weakening the compile-time, AOT, or clean architecture constraints.

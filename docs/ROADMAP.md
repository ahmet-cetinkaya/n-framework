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

- [x] `nfw templates`, `nfw new`, and `nfw add service --template dotnet-service` (Phase 1 ✅)
- [x] One-command build and one-command test workflows for generated samples (Phase 1 ✅)
- [ ] `NFramework.Domain` and `NFramework.Application`
- [ ] Result-based application flow and workflow contracts
- [ ] Framework-native CQRS execution for commands, queries, events, stream requests, and behaviors
- [ ] Source-generated DI registration and Minimal API route generation
- [x] Architecture validation through `nfw check` (Phase 1 ✅)
- [ ] End-to-end feature generation for commands, queries, and CRUD workflows, with the final command contract resolved during the beta train
- [ ] Topic abstractions and first-party adapters required to prove the standalone `.NET` service path
- [ ] Quickstart, architecture guidance, and feature-complete `.NET` documentation
- [x] Continuous validation for Native AOT, trimming, smoke tests, and benchmark KPIs (Phase 1 ✅)

Beta follow-on items that remain in PRD scope but are not on the critical path for the first external beta cut:

- [ ] Localization and translation adapters
- [ ] Mailing adapters
- [ ] Search adapters

These follow-on items remain part of the broader beta train because PRD section `6` keeps them in initial beta scope, while PRD section `11` explicitly deprioritizes some of them to shortly after beta if the core path needs protection.

## Phase 1: Workspace and Core Foundations ✅ COMPLETE

Target window: April-May 2026
**Status**: Completed April 2026

Goal:
Establish the Rust CLI, workspace shape, service scaffold, template system, architecture validation, and build/test workflows needed for every later generator and adapter investment.

Why this phase matters:
This phase creates the shortest path to the PRD promise of one-command workspace setup, enforceable Clean Architecture boundaries, and a usable `.NET` baseline that later compile-time tooling can rely on.

Milestones:

- [x] M1: Lock workspace structure, namespace conventions, and template metadata model
- [x] M2: Ship the Rust `nfw` CLI (CLI-only), including `nfw templates`, `nfw new`, and `nfw add service --template dotnet-service`
- [x] M3: Establish baseline architecture rules and `nfw check` validation

Planned deliverables:

- [x] Rust CLI skeleton with deterministic command parsing for template selection and workspace setup
- [x] Template catalog, template version rules, and remote catalog support (`nfw templates`)
- [x] Workspace creation with documented build and test commands (`nfw new`)
- [x] `.NET` service scaffold with `Domain`, `Application`, `Infrastructure`, and `Api` projects (`nfw add service --template dotnet-service`)
- [x] Sample health or readiness endpoint in generated services
- [x] Initial layer rules, package boundaries, and forbidden dependency definitions
- [x] Architecture validation via `nfw check` for forbidden references, namespaces, and packages
- [x] CLI smoke tests for template selection, workspace generation, and service scaffolding (interactive and non-interactive modes)
- [x] Single-command build and single-command test workflows for generated samples
- [x] Benchmark harness validating workspace and service creation performance targets

**Performance Results**: Combined workspace + service creation achieves **41ms median** (P95: 46ms), **355x faster** than the 1000ms target.

Dependencies:

- [x] Finalize generated folder, namespace, and solution conventions before source generator work begins
- [x] Finalize the Rust CLI command model before generator work begins
- [x] Define the sample workspace used by smoke tests, AOT checks, and future generator fixtures
- [x] Keep build and test entry points stable so later phases do not break onboarding

Risk mitigation:

- [x] Freeze workspace conventions at the phase boundary to avoid generator churn in later phases
- [x] Add smoke tests early for interactive and non-interactive command paths
- [x] Validate CLI usability with real developer workflows before phase exit

Exit criteria:

- [x] A new `.NET` workspace and service can be created from the Rust CLI
- [x] Generated projects compile without manual file edits
- [x] Template selection works in interactive and non-interactive flows
- [x] Architecture validation detects violations with actionable remediation hints
- [x] The project exposes a documented single build command and single test command
- [x] CLI smoke tests pass for all Phase 1 command scenarios

PRD traceability:

- [x] Section `3`: goals for CLI workflow, coherent `.NET` service framework, architecture enforcement, and time-to-first-service
- [x] Section `6`: initial beta scope for CLI, service creation, and documentation
- [x] Section `7`: `US-001`, `US-002`
- [x] Section `8`: `FR-1` to `FR-6`, `FR-11`, `FR-36`
- [x] Section `11`: template determinism, one-command build/test workflows, and the CLI implementation choice reflected in this roadmap

**Test Coverage**: 20+ integration tests, comprehensive unit tests, 5 smoke test scripts, and benchmark harness all passing. See [docs/phase1-status.md](./phase1-status.md) for detailed completion report.

## Phase 2: Compile-Time Application Model

Target window: June-August 2026

Goal:
Prove the compile-time-first application model by delivering the CQRS pipeline, command, query, and CRUD generation, source-generated DI registration, and establishing the foundational .NET topic packages containing the base abstractions and contracts.

Why this phase matters:
This phase validates the core product claim that NFramework can replace runtime reflection and repetitive wiring with deterministic generation without sacrificing developer clarity or AOT compatibility.

Milestones:

- [ ] M4: Deliver foundational .NET topic packages (`NFramework.Persistence.*`, `NFramework.Mediator.*`) containing base abstractions and EF Core/MediatR implementations
- [ ] M5: Deliver source-generated DI registration for repositories and handlers
- [ ] M6: Deliver interactive wizard-like command, query, and CRUD generation with mustache templates and configuration-driven flow

Planned deliverables:

- [ ] `NFramework.Persistence.Abstractions`, `NFramework.Persistence.EFCore`, and `NFramework.Persistence.Generators` packages
- [ ] `NFramework.Mediator.Abstractions`, `NFramework.Mediator.Mediator` (adapter for martinothamar/Mediator), and `NFramework.Mediator.Generators` packages
- [ ] Repository abstractions (IRepository<T, TId>, IUnitOfWork), entity base classes, and pagination interfaces
- [ ] CQRS abstractions (`ICommand<TResult>`, `IQuery<TResult>`, `IRequestHandler<TRequest, TResult>`, `IPipelineBehavior<TRequest, TResult>`)
- [ ] `nfw gen command <NAME> <FEATURE>`, `nfw gen query <NAME> <FEATURE>`, and `nfw gen crud <NAME> --props <DEFINITIONS>` with interactive prompts
- [ ] Support for `--no-input` flag and `--project` parameter for non-interactive mode
- [ ] Feature folder auto-creation following NFramework conventions
- [ ] Mustache templates and configurations in `src/nfw-templates/` submodule for scaffolding
- [ ] Configuration-driven generation flow (no hardcoded logic in nfw)
- [ ] Source-generated DI registration code with incremental Roslyn generators
- [ ] Generated code is trimmable and AOT-compatible (zero warnings)
- [ ] `nfw check` command for architecture validation (forbidden dependencies, namespace violations, banned packages)
- [ ] Golden-file tests for generated code and AOT build validation

Dependencies:

- [x] Phase `1` workspace, service, and CLI conventions must remain stable (✅ Complete)
- [ ] Generators and analyzers must share one metadata and naming model
- [ ] The Rust CLI public command model must be frozen before documentation and release hardening begin
- [x] Sample services must exist for benchmark and integration coverage (✅ Complete from Phase 1)

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

## Phase 3: Cross-Cutting Concerns and API Routing

Target window: September-December 2026

Goal:
Expand the compile-time foundation with cross-cutting concern abstractions, API routing source generators, and infrastructure implementations required by most real services.

Why this phase matters:
This phase delivers the essential cross-cutting building blocks (`Result<T>`, validators, mappers, cache, logging) and API routing automation that make NFramework a complete application platform while preserving clean boundaries.

Milestones:

- [ ] M7: Ship cross-cutting concern abstractions and adapters (`Result<T>`, validators, mappers, cache, logging)
- [ ] M8: Ship source-generated Minimal API route generation with documented naming conventions
- [ ] M9: Deliver integration tests for cross-cutting concerns and API routing

Planned deliverables:

- [ ] `NFramework.CrossCuttingConcerns.Abstractions` and `NFramework.CrossCuttingConcerns.*` adapter packages
- [ ] `Result<T>` type for explicit error handling without exceptions
- [ ] Validation abstractions and FluentValidation adapters
- [ ] Mapping abstractions and Mapster adapters
- [ ] Caching abstractions and IMemoryCache/IDistributedCache adapters
- [ ] Logging abstractions and Serilog/ILogger adapters
- [ ] Exception handling and Problem Details integration for the HTTP stack
- [ ] Source-generated Minimal API route mapping using incremental Roslyn generators
- [ ] API route discovery from command/query handlers with attribute-based or convention-based configuration
- [ ] OpenAPI/Swagger integration for generated endpoints
- [ ] Golden-file tests for generated route mappings
- [ ] Integration tests for cross-cutting concerns and API flows

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

## Phase 4: Security Abstractions and Implementations

Target window: January-March 2027

Goal:
Deliver security abstractions and first-party implementations (authentication, authorization, encryption) for securing NFramework services.

Why this phase matters:
This phase provides the security building blocks required for production services while maintaining clean architecture boundaries and keeping security concerns out of domain and application layers.

Milestones:

- [ ] M10: Ship security abstractions (IUser, IIdentity, claims, permissions)
- [ ] M11: Ship authentication and authorization adapters (JWT, API keys)
- [ ] M12: Ship encryption and secret management adapters

Planned deliverables:

- [ ] `NFramework.Security.Abstractions`, `NFramework.Security.*` adapter packages
- [ ] Security abstractions for users, identities, claims, permissions, and roles
- [ ] Attribute-based authorization (`[RequiresPermission]`, `[RequiresRole]`)
- [ ] JWT authentication adapter with token generation and validation
- [ ] API key authentication adapter
- [ ] Authorization handlers for permission and role-based access control
- [ ] Encryption adapters for data at rest (symmetric/asymmetric)
- [ ] Secret management adapters for environment variables and key vault integration
- [ ] Security pipeline behaviors for CQRS commands and queries
- [ ] Integration tests for authentication, authorization, and encryption flows

Dependencies:

- [ ] Phase `2` CQRS abstractions must be stable
- [ ] Phase `3` cross-cutting concerns (`Result<T>`) must be available for error handling
- [ ] Phase `3` API routing generators must support secured endpoints

Resource estimate:

- `2` security engineers
- `1` framework engineer
- `0.5` QA automation support
- Approximate effort: `30-35` engineer-weeks

Risk mitigation:

- [ ] Keep security types out of domain and application layers
- [ ] Use adapter pattern for multiple authentication providers
- [ ] Security audit before public beta release
- [ ] Document security assumptions and threat model

Exit criteria:

- [ ] Generated services can secure operations with attributes and behaviors
- [ ] Authentication and authorization work without runtime reflection
- [ ] Security adapters are replaceable without modifying domain/application code
- [ ] Integration tests validate end-to-end security workflows

PRD traceability:

- [ ] Section `3`: goals for security-first design
- [ ] Section `5`: principles for security as a cross-cutting adapter
- [ ] Section `7`: user stories for secured operations
- [ ] Section `8`: functional requirements for authentication and authorization

## Phase 5: Diagnostic Analyzers

Target window: April-June 2027

Goal:
Deliver Roslyn diagnostic analyzers for AOT compatibility checking, architecture validation, and compile-time enforcement of NFramework conventions.

Why this phase matters:
This phase provides developer-friendly compile-time diagnostics that catch architecture violations, AOT incompatibilities, and framework usage errors before runtime, improving developer experience and reducing debugging time.

Milestones:

- [ ] M13: Ship AOT compatibility analyzer with diagnostics for reflection, dynamic types, and unsupported patterns
- [ ] M14: Ship architecture validation analyzer for layer violations and forbidden dependencies
- [ ] M15: Ship framework usage analyzer for NFramework-specific patterns and conventions

Planned deliverables:

- [ ] `NFramework.Analyzers` NuGet package with multiple diagnostic analyzers
- [ ] AOT compatibility analyzer detecting:
  - [ ] Runtime reflection usage (GetType(), GetMethods(), etc.)
  - [ ] Dynamic type usage (dynamic, ExpandoObject)
  - [ ] Activator.CreateInstance and other instantiation patterns
  - [ ] Serialization attributes incompatible with AOT
- [ ] Architecture validation analyzer detecting:
  - [ ] Domain layer dependencies on Infrastructure
  - [ ] Application layer dependencies on presentation/frameworks
  - [ ] Direct HTTP/database access from Domain or Application
  - [ ] Forbidden namespace references
- [ ] Framework usage analyzer for:
  - [ ] Missing handler registrations
  - [ ] Improper command/query naming conventions
  - [ ] Missing repository interface implementations
  - [ ] Incorrect attribute usage
- [ ] Configurable diagnostic severities (error, warning, info)
- [ ] Code fixes and refactoring suggestions for common violations
- [ ] Integration with `nfw check` CLI command
- [ ] Unit tests for analyzer diagnostics and code fixes

Dependencies:

- [ ] Phase `2` compile-time application model must be stable
- [ ] Phase `3` cross-cutting concerns and API routing must be defined
- [ ] Phase `4` security abstractions must be finalized

Resource estimate:

- `1-2` analyzer engineers
- `0.5` QA automation support
- Approximate effort: `20-25` engineer-weeks

Risk mitigation:

- [ ] Start with high-impact diagnostics that prevent real issues
- [ ] Make diagnostics opt-out via configuration for legacy codebases
- [ ] Provide clear documentation and error messages
- [ ] Treat analyzer warnings as errors in CI for new projects

Exit criteria:

- [ ] Analyzers detect common AOT incompatibilities with actionable error messages
- [ ] Architecture violations are caught at compile-time with file/line locations
- [ ] Developers can opt-in to analyzer package via single NuGet reference
- [ ] Analyzer diagnostics integrate with Visual Studio and VS Code

PRD traceability:

- [ ] Section `3`: goals for compile-time enforcement and architecture validation
- [ ] Section `5`: principles for fail-fast validation
- [ ] Section `8`: functional requirements for architecture checking
- [ ] Section `11`: analyzer and validation tooling

## Phase 6: Beta Hardening and Public Beta

Target window: July-September 2027

Goal:
Close the beta gate with documentation, KPI validation, release hardening, and a clear separation between beta-critical scope and beta-train follow-on items.

Why this phase matters:
This phase converts engineering completeness into product readiness by proving the PRD success metrics, making onboarding reliable, and keeping scope discipline around the first public beta.

Milestones:

- [ ] M16: Publish quickstart, architecture guidance, and troubleshooting
- [ ] M17: Lock benchmark harness and pass AOT, startup, and generation KPIs
- [ ] M18: Cut the first public beta and schedule beta follow-on packages

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

## Phase 7: Distributed `.NET` Expansion

Target window: April-July 2027

Goal:
Expand from standalone `.NET` services into distributed local development, observability defaults, and Dapr-backed platform adapters.

Why this phase matters:
This phase fulfills the PRD promise that cloud-native defaults become part of the framework once the standalone path is proven, without polluting domain or application code with platform-specific concerns.

Milestones:

- [ ] M19: Ship Aspire AppHost and ServiceDefaults generation
- [ ] M20: Ship first-party Dapr adapters for state, pub/sub, and secret workflows
- [ ] M21: Ship `nfw up` and distributed `.NET` guidance

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

## Phase 8: Interactive TUI Interface

Target window: October 2027-January 2028 (after all .NET expansion phases are stable)

Goal:
Deliver an interactive TUI layer on top of the stable Rust CLI to provide visual workspace management, guided wizards, and real-time feedback for common workflows.

Why this phase matters:
TUI lowers the barrier for teams who prefer guided, visual workflows over CLI-only interaction. By deferring TUI until after the entire .NET framework path — workspace scaffolding, compile-time generation, core service capabilities, beta hardening, and distributed features — is proven, the TUI can wrap a stable, production-ready foundation rather than chasing a moving target.

Milestones:

- [ ] M22: Ship TUI architecture, component library, and navigation model
- [ ] M23: Ship interactive workspace dashboard and service creation wizard
- [ ] M24: Ship command palette, configuration editor, and progress diagnostics

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
- [ ] The .NET framework beta must be stable with distributed features (Phase 7) fully validated
- [ ] TUI implementation should follow the stable CLI patterns established in Phase 1-7

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

## Phase 9: Polyglot Standards and Ecosystem Tooling

Target window: February-July 2028

Goal:
Extend the workspace standard beyond `.NET`, add contract sync, and make the CLI and workspace model consumable by later MCP-compatible tooling.

Why this phase matters:
This phase delivers the long-term product vision of one architectural standard across languages while preserving the `.NET` reference path as the source of truth for conventions, contracts, and tooling behavior.

Milestones:

- [ ] M25: Ship Go and Rust service scaffolds using the shared workspace model
- [ ] M26: Ship Protobuf-driven contract sync across supported languages
- [ ] M27: Publish workspace metadata and automation surfaces required for MCP-compatible tooling

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

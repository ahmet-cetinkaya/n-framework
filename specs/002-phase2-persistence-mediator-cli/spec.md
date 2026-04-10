# Feature Specification: Compile-Time Application Model

**Feature Branch**: `002-phase2-persistence-mediator-cli`
**Created**: 2026-04-10
**Status**: Draft
**Input**: User description: "Read @docs/PRD.md, @docs/ROADMAP.md. Create phase 2 monorepo specs according to @docs/SPECIFICATION_GUIDELINES.md"

## User Scenarios & Testing

### User Story 1 - Foundational Framework Abstractions (Priority: P1)

As a framework author, I want stable, well-defined abstractions for domain entities, application workflows, and cross-cutting concerns so that infrastructure adapters and code generators can build on a common contract without coupling to specific implementations.

**Why this priority**: This is the foundation upon which all other Phase 2 work depends. Without these abstractions, generators have no stable contracts to generate against, and adapters have no interfaces to implement. This delivers value by establishing the "law" that governs how all framework components interact.

**Independent Test**: Can be fully tested by creating sample domain entities and application workflows using the abstractions, then verifying that infrastructure adapters can implement the required interfaces without knowing specific implementation details. Delivers the value of having a clean separation between core framework contracts and any specific persistence, logging, or validation library.

**Acceptance Scenarios**:

1. **Given** the NFramework.Core abstractions are referenced, **When** a developer creates a domain entity inheriting from `Entity<TId>`, **Then** the entity has identity comparison, domain event collection, and aggregation root capabilities without requiring any infrastructure dependencies.
2. **Given** a command handler implements the application abstraction, **When** the handler returns a `Result<T>` outcome, **Then** the result explicitly indicates success, validation failure, or business rule violation without throwing exceptions for expected business outcomes.
3. **Given** a repository abstraction is defined, **When** an infrastructure adapter implements it, **Then** the application layer can use the repository without knowing whether the backing implementation uses EF Core, Dapper, or another data access library.

---

### User Story 2 - Source-Generated Service Registration and Routing (Priority: P1)

As a .NET developer, I want dependency injection registration and API route mapping generated at compile time so that my service starts quickly, is compatible with Native AOT, and doesn't require runtime assembly scanning.

**Why this priority**: This validates the core product claim that NFramework replaces runtime reflection with deterministic generation. It delivers immediate value by removing the performance cost and AOT incompatibility of runtime DI scanning while keeping developer code simple and maintainable.

**Independent Test**: Can be fully tested by creating a sample service with handlers, building it with source generators enabled, and verifying that (a) the service starts without runtime assembly scanning, (b) all handlers are registered, and (c) routes are mapped correctly. Delivers the value of fast startup and AOT compatibility.

**Acceptance Scenarios**:

1. **Given** a service has command and query handlers, **When** the project is compiled, **Then** source generators emit deterministic DI registration code that registers all handlers without runtime scanning.
2. **Given** a query handler is marked for API exposure, **When** the project is compiled, **Then** source generators emit Minimal API route mappings that wire the handler to an HTTP endpoint.
3. **Given** a generated service is built, **When** the service starts, **Then** no runtime assembly scanning occurs and the service cold-starts within the performance target specified in the PRD.
4. **Given** the generated service is published with Native AOT, **When** the executable runs, **Then** it produces no AOT or trimming warnings related to DI or routing.

---

### User Story 3 - Interactive Feature Generation (Priority: P1)

As an application developer, I want to generate commands, queries, and CRUD scaffolding through an interactive CLI wizard so that I can deliver features faster while staying within architectural boundaries.

**Why this priority**: This is the primary developer-facing workflow that demonstrates the value of the entire framework. It delivers immediate productivity gains by automating boilerplate creation while enforcing clean architecture rules.

**Independent Test**: Can be fully tested by running the CLI commands, providing inputs through the interactive prompts, and verifying that generated code compiles, follows architectural conventions, and can be executed end-to-end. Delivers the value of rapid feature development with consistent structure.

**Acceptance Scenarios**:

1. **Given** an existing .NET service in the workspace, **When** I run `nfw add command`, **Then** the CLI prompts me for command name, feature, return type, and workflow options, then generates all required artifacts in the correct layer projects.
2. **Given** a feature folder doesn't exist, **When** I generate a command for that feature, **Then** the CLI creates the feature folder structure before generating the command artifacts.
3. **Given** I want to generate CRUD scaffolding, **When** I run `nfw add entity` with property definitions, **Then** the CLI generates the entity, repository contract, DTOs, commands, queries, handlers, and API endpoints.
4. **Given** I enable workflow options like caching or logging, **When** the command handler is generated, **Then** the handler includes the appropriate pipeline behaviors or attributes.
5. **Given** I mark an operation as secured, **When** the handler and endpoint are generated, **Then** they include authorization checks and OpenAPI security documentation.

---

### User Story 4 - CQRS Execution Pipeline (Priority: P2)

As an application developer, I want a built-in CQRS dispatch pipeline so that my handlers execute through a consistent execution model with support for behaviors, logging, and transactions.

**Why this priority**: This demonstrates that NFramework provides a complete application model rather than just scaffolding. It delivers value by giving developers a standard way to execute commands and queries with cross-cutting concerns applied consistently.

**Independent Test**: Can be fully tested by creating command and query handlers, dispatching them through the CQRS pipeline, and verifying that behaviors execute, logging occurs, and transactions are applied when configured. Delivers the value of consistent handler execution with cross-cutting concerns.

**Acceptance Scenarios**:

1. **Given** a command handler is registered, **When** I dispatch a command through the mediator, **Then** the handler executes and any configured behaviors run before and after handler execution.
2. **Given** a query handler implements caching, **When** I dispatch the same query twice, **Then** the second call returns cached results without executing the handler.
3. **Given** a command is configured to run in a transaction, **When** the command handler executes, **Then** database operations participate in the transaction and commit only if the handler succeeds.
4. **Given** a handler throws an unexpected exception, **When** the pipeline catches it, **Then** the exception is logged and converted to an appropriate error result rather than propagating as an unhandled exception.

---

### User Story 5 - Build Validation and Continuous AOT Checking (Priority: P2)

As a platform engineer, I want automated validation of architecture rules and AOT compatibility in CI so that architectural violations and trimming issues are caught before they reach production.

**Why this priority**: This protects the investment in clean architecture by ensuring violations are detected early. It delivers value by preventing architectural decay and maintaining AOT compatibility across the codebase.

**Independent Test**: Can be fully tested by introducing intentional architecture violations and AOT-incompatible code, then running the validation commands and verifying that they fail with actionable error messages. Delivers the value of automated architectural governance.

**Acceptance Scenarios**:

1. **Given** a project references a forbidden dependency, **When** I run `nfw check`, **Then** the command exits with a non-zero status and identifies the violating project reference with a remediation hint.
2. **Given** code uses a forbidden namespace from an infrastructure package in the domain layer, **When** I run `nfw check`, **Then** the command identifies the file and line number with the violation.
3. **Given** a service is built with AOT enabled, **When** the build completes, **Then** warnings about trimming or AOT incompatibility are surfaced in the build output.
4. **Given** the CI pipeline runs, **When** architecture validation or AOT checks fail, **Then** the pipeline fails and prevents merge of violating code.

---

### User Story 6 - Result-Based Application Flow (Priority: P2)

As an application developer, I want to return explicit result objects from handlers instead of throwing exceptions for expected business outcomes so that my application flow is predictable and AOT-friendly.

**Why this priority**: This establishes the pattern for how business outcomes are represented throughout the framework. It delivers value by making error handling explicit and reducing the performance cost of exception-based flow.

**Independent Test**: Can be fully tested by writing handlers that return success and failure results, then verifying that calling code can match on results and handle different outcomes appropriately. Delivers the value of explicit, analyzable business outcomes.

**Acceptance Scenarios**:

1. **Given** a command handler validates input, **When** validation fails, **Then** the handler returns a failure result with validation error details rather than throwing a validation exception.
2. **Given** a command handler encounters a business rule violation, **When** the rule check fails, **Then** the handler returns a business failure result with a user-friendly error message.
3. **Given** a handler returns a failure result, **When** an API endpoint receives the result, **Then** the endpoint maps the failure to an appropriate HTTP status code and error response.
4. **Given** multiple handlers in a workflow, **When** one handler returns a failure result, **Then** subsequent handlers can short-circuit based on the failure without catching exceptions.

---

### Edge Cases

- **Empty handler sets**: When a service has no command or query handlers, source generators should produce valid (though minimal) registration and route code without errors.
- **Duplicate registrations**: When multiple handlers would register the same service type, the generator should emit a diagnostic explaining the conflict.
- **Circular dependencies**: When domain entities reference each other in ways that could cause issues, the abstractions should support modeling these relationships without requiring infrastructure coupling.
- **Unsupported handler patterns**: When a handler doesn't follow expected conventions (e.g., wrong base type, missing generic parameters), the generator should emit actionable diagnostics explaining what's unsupported.
- **Feature folder conflicts**: When a feature folder already exists with incompatible structure, the CLI should detect this and prompt for resolution rather than overwriting existing files.
- **Partial generation failures**: When generation fails partway through (e.g., disk full, permission error), the workspace should not be left in an inconsistent state—either all files are written or none are.
- **Concurrent workspace modifications**: When the workspace is modified while a generation command is running, the CLI should detect changes and either retry or fail gracefully with a clear error.
- **AOT-incompatible patterns**: When generated code would use features incompatible with AOT (e.g., reflection-based serialization in handlers), validators should catch this before the code reaches production.
- **Large handler counts**: When a service has hundreds of handlers, generated registration code should remain efficient and compile times should stay reasonable.
- **Nested feature folders**: When organizing features hierarchically, generators should correctly place artifacts in the right layer projects regardless of nesting depth.

## Requirements

### Functional Requirements

#### Foundational Abstractions

- **FR-001**: Framework MUST provide base abstractions for domain entities including `Entity<TId>`, `AggregateRoot`, `ValueObject`, and `DomainEvent` with zero external dependencies.
- **FR-002**: Framework MUST provide application contracts including `ICommand<TResult>`, `IQuery<TResult>`, `IEvent`, `IRequestHandler<T, TResult>`, `IStreamRequest`, `IPipelineBehavior`, `IBusinessRule`, and `IPageableRequest`.
- **FR-003**: Framework MUST provide explicit result types `Result` and `Result<T>` for representing success, validation failure, and business failure outcomes without using exceptions.
- **FR-004**: Framework MUST provide repository abstractions supporting CRUD operations, pagination, dynamic querying, bulk operations, and migration application hooks.
- **FR-005**: Framework MUST define abstractions for cross-cutting concerns including validation, mapping, structured logging, caching, transactions, and security (authorization and authentication).
- **FR-006**: Framework MUST provide abstractions for workflow markers including cacheable operations, logged operations, transactional operations, and secured operations.

#### Source Generation

- **FR-007**: Framework MUST provide source generators that emit deterministic DI registration code for command handlers, query handlers, stream handlers, and application services without requiring runtime assembly scanning.
- **FR-008**: Framework MUST provide source generators that emit Minimal API route mappings for commands and queries marked for API exposure.
- **FR-009**: Generated registration code MUST be visible in build output for debugging and MUST emit actionable diagnostics for unsupported patterns.
- **FR-010**: Generated route mappings MUST follow documented naming and versioning conventions and MUST NOT require controller-based APIs.
- **FR-011**: Source generators MUST handle empty project sets without errors and MUST validate that generated code remains trimmable and AOT-compatible.

#### CLI Generation Commands

- **FR-012**: CLI MUST provide `nfw add command <name> <feature>` with interactive prompts for return type, workflow options (caching, logging, transaction, secured), and API exposure settings.
- **FR-013**: CLI MUST provide `nfw add query <name> <feature>` with interactive prompts for return type, caching options, and API exposure settings.
- **FR-014**: CLI MUST provide `nfw add entity <name> --props <definitions>` that generates entity, repository contract, DTOs, commands, queries, handlers, and API endpoints for CRUD operations.
- **FR-015**: CLI MUST support `--no-input` flag for non-interactive mode with all required parameters provided as arguments.
- **FR-016**: CLI MUST create feature folder structures automatically when they don't exist.
- **FR-017**: CLI MUST support targeting specific projects in the workspace via `--project` parameter.
- **FR-018**: Generated artifacts MUST be placed in the correct layer projects following documented namespace and folder conventions.

#### CQRS Pipeline

- **FR-019**: Framework MUST provide a built-in CQRS dispatch pipeline (mediator) that executes commands, queries, events, and stream requests through registered handlers.
- **FR-020**: CQRS pipeline MUST support pipeline behaviors that execute before and after handler execution in a configurable order.
- **FR-021**: CQRS pipeline MUST integrate with Result-based application flow for expected business outcomes.
- **FR-022**: CQRS pipeline MUST support workflow markers for caching, logging, transactions, and security checks.

#### Architecture Validation

- **FR-023**: CLI MUST provide `nfw check` command that scans workspace for forbidden project references, forbidden namespace usage, and forbidden package dependencies.
- **FR-024**: Architecture validation MUST exit with non-zero status when violations are found and MUST identify the violating project, file, or dependency with concrete remediation hints.
- **FR-025**: Architecture validation MUST be executable in CI without requiring interactive input.

#### Build and Test Integration

- **FR-026**: Framework MUST provide build fixtures for testing empty and non-empty generator scenarios.
- **FR-027**: CI MUST include AOT and trimming compatibility checks that fail builds when warnings are detected.
- **FR-028**: Generated samples MUST build with a single documented command and test with a single documented command.

### Key Entities

- **Domain Entity**: A business object with identity, capable of holding domain events and participating in aggregates. Key attributes: unique identifier, equality based on ID, domain event collection.
- **Aggregate Root**: A entity that acts as the consistency boundary for a group of related entities. Key attributes: manages domain events, enforces invariants across the aggregate.
- **Value Object**: An immutable object defined by its attributes rather than identity. Key attributes: equality based on all properties, no identity.
- **Domain Event**: A representation of something that happened in the domain. Key attributes: occurrence timestamp, event type, association with aggregate.
- **Command**: A request to perform an action or change state. Key attributes: command data, return type, optional workflow markers.
- **Query**: A request to retrieve data without modifying state. Key attributes: query parameters, return type, optional caching settings.
- **Result**: An explicit outcome type representing success or failure with context. Key attributes: success flag, error details, optional value.
- **Repository Contract**: An abstraction for data access operations. Key attributes: CRUD methods, query support, pagination, transaction integration.
- **Handler**: A class that processes commands or queries. Key attributes: handle method, input type, output type, optional behavior attributes.
- **Pipeline Behavior**: A cross-cutting concern that wraps handler execution. Key attributes: execute method, order, applicability to command/query/both.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Generated .NET services build with zero Native AOT warnings in all core framework packages and generated handler code.
- **SC-002**: Generated .NET services build with zero trimming warnings in all core framework packages and generated handler code.
- **SC-003**: A standard generated .NET service cold-starts in less than 50 milliseconds under the PRD benchmark conditions (Docker container, 2 CPU, 4GB RAM).
- **SC-004**: Source-generated DI registration eliminates all runtime assembly scanning for handler discovery—measured by zero calls to assembly scanning APIs during startup.
- **SC-005**: Interactive command generation (`nfw add command`) completes in less than 5 seconds from invocation to buildable output on the PRD baseline developer machine.
- **SC-006**: Interactive CRUD generation (`nfw add entity`) completes in less than 10 seconds from invocation to buildable output on the PRD baseline developer machine.
- **SC-007**: Architecture validation (`nfw check`) detects all defined violations (forbidden references, namespaces, packages) with zero false positives in test fixtures.
- **SC-008**: Developers can create a working command handler with API exposure through the CLI in under 3 minutes without prior framework experience.
- **SC-009**: Generated handler code follows Result pattern consistently—measured by 100% of generated handlers returning `Result<T>` rather than throwing exceptions for business outcomes.
- **SC-010**: All framework abstractions have zero external package dependencies—measured by analyzing `NFramework.Core.*` package references.

## Assumptions

- Phase 1 workspace structure, service scaffold, and CLI conventions remain stable and are used as the foundation for Phase 2 work.
- Target runtime is .NET 11 with C# 14/15 features used where they improve clarity, code generation, or AOT compatibility.
- Source generators and analyzers share one metadata and naming model for consistency.
- Generated code should remain human-readable and suitable for normal code review.
- Framework abstractions prioritize AOT compatibility and trimming over reflection-based convenience patterns.
- The Rust CLI public command model can be extended with new commands without breaking existing functionality.
- Sample services from Phase 1 remain valid and can be extended with Phase 2 features.
- CI infrastructure supports AOT builds and trimming validation.
- Development team has access to .NET 11 preview tooling and Native AOT build environments.
- First-party adapter support (EF Core, FluentValidation, Mapster, Serilog) will be implemented in Phase 3, not Phase 2.

## Dependencies

- **Phase 1 completion**: Workspace scaffolding, service templates, CLI structure, and architecture validation must be complete and stable.
- **.NET 11 tooling**: Access to .NET 11 SDK, C# 14/15 compiler, and Native AOT publishing tooling.
- **Source generator infrastructure**: Roslyn source generator APIs and analyzer diagnostic APIs.
- **Rust CLI extensions**: Ability to add new commands to the `nfw` CLI for feature generation.
- **Test infrastructure**: Build fixtures, golden-file test infrastructure, and AOT validation tooling in CI.

## Clarifications

None at this time. This spec is derived from the PRD and ROADMAP which define the Phase 2 scope explicitly.

## Non-Goals

The following are explicitly out of scope for Phase 2:

- First-party adapters for persistence, validation, mapping, logging, or security implementations (these are Phase 3).
- Dapr and Aspire integration (Phase 5).
- Polyglot support for Go and Rust (Phase 7).
- Interactive TUI interface (Phase 6).
- Localization, translation, mailing, and search adapters (post-beta or Phase 3+).
- Controller-based API scaffolding.
- Runtime reflection fallbacks for framework features.
- Supporting every database, queue, cache, or cloud provider.
- Replacing Dapr with provider-specific abstractions in domain or application layers.
- Graphical UI for project generation.
- Arbitrary non-standard project layouts outside the NFramework standard structure.
- Full feature parity across .NET, Go, and Rust (this is the .NET reference implementation).
- Hiding all generated code from developers—generated code should remain inspectable and debuggable.
- Solving deployment platform setup for every hosting environment.
- Supporting exception-driven business flow as a primary application pattern (Result pattern is required).

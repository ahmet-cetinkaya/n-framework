# Feature Specification: Phase 1 - Workspace and Core Foundations

## Overview

This specification defines the orchestration work required to establish the foundational workspace model, CLI/TUI entry point, and core package boundaries for NFramework. This phase creates the shortest path to one-command workspace setup, enforceable Clean Architecture boundaries, and a usable .NET baseline that later compile-time tooling can rely on.

## User Scenarios & Testing

### User Story 1 - Create New Workspace (Priority: P1)

As a platform engineer, I want to create a new NFramework workspace with a single command so that I can start a service ecosystem without manual setup.

**Why this priority**: This is the primary entry point for all NFramework users. Without workspace creation, no other workflows are possible.

**Independent Test**: Can be fully tested by running `nfw new <workspace-name>` and verifying the workspace structure is created with expected folders, solution files, and baseline configuration. Delivers immediate value: a working workspace ready for service creation.

**Acceptance Scenarios**:

1. **Given** the nfw CLI is installed, **When** I run `nfw new MyWorkspace`, **Then** a workspace root is created with the expected folder structure, solution files, and baseline configuration
2. **Given** an interactive terminal, **When** I run `nfw new` without arguments, **Then** I am prompted for required input (workspace name, template selection) before generation starts
3. **Given** a template catalog exists, **When** I run `nfw new MyWorkspace --template <id> --no-input`, **Then** the workspace is created using the specified template without interactive prompts
4. **Given** a newly created workspace, **When** I run the documented build command, **Then** the workspace builds successfully without manual file edits

---

### User Story 2 - Add .NET Service to Workspace (Priority: P1)

As a .NET developer, I want to generate a service scaffold with Clean Architecture layers so that I can start from a standard baseline instead of creating projects by hand.

**Why this priority**: Service creation is the primary workflow after workspace creation. This establishes the architectural patterns that all services must follow.

**Independent Test**: Can be fully tested by running `nfw add service <name> --lang dotnet` in a workspace and verifying the four-layer structure is created. Delivers immediate value: a compilable service with domain, application, infrastructure, and API layers.

**Acceptance Scenarios**:

1. **Given** an active workspace, **When** I run `nfw add service Orders --lang dotnet`, **Then** a service with Domain, Application, Infrastructure, and Api projects is created
2. **Given** a newly created service, **When** I inspect project references, **Then** each layer references only allowed dependencies for its architectural boundary
3. **Given** a newly created service, **When** I build the service, **Then** it compiles successfully without manual file edits
4. **Given** a newly created service, **When** I inspect the API project, **Then** sample health or readiness endpoints are included

---

### User Story 3 - Use Core Domain Abstractions (Priority: P2)

As a domain developer, I want standard base abstractions so that aggregates and value objects are modeled consistently across services.

**Why this priority**: Domain consistency is critical for long-term maintainability, but basic CRUD can be done without these abstractions using manual code.

**Independent Test**: Can be fully tested by creating an entity that inherits from framework base classes and verifying identity, equality, and domain event behavior work correctly. Delivers value: reusable domain patterns that reduce boilerplate.

**Acceptance Scenarios**:

1. **Given** the NFramework.Domain package, **When** I create an entity inheriting from `Entity<TId>`, **Then** identity and equality are handled correctly
2. **Given** an aggregate root, **When** I raise a domain event, **Then** the event is captured and can be retrieved
3. **Given** a value object, **When** I compare two instances with the same values, **Then** they are considered equal
4. **Given** domain abstractions, **When** I inspect their dependencies, **Then** they do not depend on infrastructure packages

---

### User Story 4 - Use Explicit Application Results (Priority: P2)

As an application developer, I want handlers to return explicit result objects so that business outcomes are predictable and AOT-friendly.

**Why this priority**: Explicit results enable AOT compilation and predictable business flow, but basic exception-based flow can work temporarily.

**Independent Test**: Can be fully tested by creating a handler that returns `Result<T>` and verifying success, validation failure, and business failure paths work correctly. Delivers value: AOT-friendly application flow without exceptions for business logic.

**Acceptance Scenarios**:

1. **Given** the NFramework.Application package, **When** I create a handler that returns `Result<T>`, **Then** success and failure states can be represented without throwing exceptions
2. **Given** a failed result, **When** I inspect the error, **Then** it contains actionable failure information
3. **Given** validation failures, **When** they occur in business logic, **Then** they are represented as failed results rather than exceptions
4. **Given** application abstractions, **When** I inspect their dependencies, **Then** they do not depend on infrastructure packages

---

### User Story 5 - Validate Architecture Boundaries (Priority: P2)

As a tech lead, I want an automated architecture audit so that boundary violations are detected before they reach production.

**Why this priority**: Architecture enforcement is critical for long-term code quality, but initial development can proceed without it through manual code review.

**Independent Test**: Can be fully tested by creating a service with an invalid cross-layer reference and running `nfw check` to verify the violation is detected. Delivers value: automated enforcement of clean architecture rules.

**Acceptance Scenarios**:

1. **Given** a workspace with services, **When** I run `nfw check`, **Then** the system scans for forbidden project references and namespace usage
2. **Given** an architecture violation, **When** `nfw check` runs, **Then** it exits with a non-zero status and identifies the violating project and file
3. **Given** a clean workspace, **When** I run `nfw check`, **Then** it exits successfully with no violations reported
4. **Given** a CI pipeline, **When** `nfw check` is executed, **Then** it runs without requiring interactive input

---

### User Story 6 - List Available Templates (Priority: P3)

As a developer, I want to see available starter templates so that I can choose an appropriate starting point for my workspace.

**Why this priority**: Template discovery improves developer experience but manual template specification (`--template <id>`) can work without it.

**Independent Test**: Can be fully tested by running `nfw templates` and verifying the output shows template identifiers and descriptions. Delivers value: discoverable template catalog.

**Acceptance Scenarios**:

1. **Given** the nfw CLI is installed, **When** I run `nfw templates`, **Then** I see a list of available templates with identifiers and descriptions
2. **Given** a template catalog, **When** a template includes a description, **Then** the description explains when to use that template
3. **Given** remote template repositories, **When** I run `nfw templates`, **Then** both local and remote templates are displayed

---

### Edge Cases

- **No arguments**: When `nfw new` is run without a workspace name in an interactive terminal, the user is prompted for required input. In a non-interactive terminal, an actionable error message is displayed.
- **Directory exists**: When `nfw new` is run and the target directory already exists and is not empty, the CLI fails with an error message indicating the directory must be empty or a different name should be used.
- **Invalid language**: When `nfw add service` is run with an unsupported language, the CLI exits with an error message listing supported languages.
- **Invalid workspace name**: When an invalid workspace name is provided (e.g., contains special characters, starts with number), the CLI provides an actionable error with naming rules.
- **Empty template catalog**: When no templates are available, `nfw templates` displays an informative message about where to find templates.
- **Interrupt signal**: When the user sends Ctrl+C during generation, any partially created files or directories are deleted and the CLI exits with code 130 (Unix-like systems).
- **Missing workspace context**: When `nfw add service` is run outside a workspace (no `nfw.yaml` found in current directory or parent directories), the CLI exits with an error indicating the command must be run within a workspace.
- **Conflicting service names**: When a service with the same name already exists, the CLI exits with an error and suggests using a different name or `--force` to overwrite.

## Requirements

### Functional Requirements

#### Workspace Creation

- **FR-001**: The system MUST support `nfw new <workspace-name>` to create a new workspace with documented folder structure, solution files, baseline configuration, and `nfw.yaml` marker file at workspace root
- **FR-002**: The system MUST support `nfw new` with interactive prompting for missing required input when run in an interactive terminal
- **FR-003**: The system MUST support `--template <id>` flag to select a specific template without interactive prompts
- **FR-004**: The system MUST support `--no-input` flag to suppress all interactive prompts and fail with actionable errors if required input is missing
- **FR-005**: The system MUST validate workspace names according to documented naming rules (alphanumeric and hyphens, must start with letter)
- **FR-006**: The system MUST create a workspace that can be built with a single documented command

#### Service Generation

- **FR-007**: The system MUST support `nfw add service <name> --lang dotnet` to generate a .NET service with Domain, Application, Infrastructure, and Api layers
- **FR-008**: The system MUST enforce that generated projects reference only allowed dependencies for their layer
- **FR-009**: The system MUST generate services that compile immediately after generation without manual file edits
- **FR-010**: The system MUST include sample health or readiness endpoints in generated API projects
- **FR-011**: The system MUST validate service names according to documented naming rules

#### Template System

- **FR-012**: The system MUST support `nfw templates` to list available starter templates with identifiers, descriptions, and git repository URLs
- **FR-013**: The system MUST support remote templates by cloning git repositories to a local cache (integration tests with real git clone; unit tests mock git operations)
- **FR-014**: The system MUST include at least one default template for standalone .NET service workspace creation
- **FR-015**: The system MUST support adding custom templates via git repository URLs

#### Core Domain Abstractions

- **FR-016**: The system MUST provide base abstractions for `Entity<TId>`, `AggregateRoot`, `ValueObject`, and `DomainEvent`
- **FR-017**: The system MUST ensure domain abstractions do not depend on infrastructure packages
- **FR-018**: The system MUST provide unit tests for domain abstractions covering equality, identity, and basic domain event behavior

#### Core Application Abstractions

- **FR-019**: The system MUST provide `Result` and `Result<T>` types for explicit outcome representation
- **FR-020**: The system MUST ensure application abstractions do not depend on infrastructure packages
- **FR-021**: The system MUST provide unit tests for result types covering success, validation failure, and business failure outcomes

#### Architecture Validation

- **FR-022**: The system MUST support `nfw check` to scan workspace for forbidden project references and forbidden namespace or package usage using hardcoded framework-defined architecture rules
- **FR-023**: The system MUST exit with non-zero status when architecture violations are found
- **FR-024**: The system MUST identify violating project, file, or dependency with concrete remediation hints
- **FR-025**: The system MUST support execution in CI without requiring interactive input

Architecture rules enforced include: Layer dependency rules (Domain→no Infra/Api, Application→no Infra/Api), namespace/package restrictions (Domain/Application→no EF Core, Dapr, HTTP frameworks, or infrastructure packages), and structural requirements (all services must have exactly 4 layers as separate projects)

#### CLI Behavior

- **FR-026**: The system MUST provide actionable error messages for invalid input, unsupported languages, and invalid option combinations
- **FR-027**: The system MUST handle Ctrl+C gracefully by cleaning up in-progress files (delete any partially created files/directories) and exiting with code 130 on Unix-like systems
- **FR-028**: The system MUST fail with clear errors when run outside appropriate context (e.g., service creation outside workspace)

#### Testing Infrastructure

- **FR-029**: The system MUST provide CLI smoke tests that validate template selection and workspace generation
- **FR-030**: The system MUST provide architecture validation tests that prove detection of valid and invalid cases
- **FR-031**: The system MUST support single-command build and single-command test workflows for generated samples

### Key Entities

- **Workspace**: Root container for services, identified by presence of `nfw.yaml` (YAML format) at workspace root, containing configuration files, solution structure, and shared settings
- **Service**: A deployable unit with four layers (Domain, Application, Infrastructure, Api) following Clean Architecture
- **Template**: A workspace starter definition stored as a git repository containing metadata, file templates, and default configuration
- **Entity**: Domain object with identity, inheriting from framework base abstractions
- **Result**: Explicit outcome type representing success or failure with actionable error information

## Success Criteria

### Measurable Outcomes

- **SC-001**: A new .NET workspace and service can be created from the CLI in less than 1 second on baseline developer hardware (2 CPU cores, 4GB RAM)
- **SC-002**: Generated projects compile without manual file edits 100% of the time
- **SC-003**: Template selection works in both interactive and non-interactive flows with 100% success rate
- **SC-004**: Core domain abstractions are usable without infrastructure dependencies (verified by dependency analysis)
- **SC-005**: The workspace provides a documented single build command and single test command that succeed on first run
- **SC-006**: Architecture validation detects all documented violation types with zero false positives in test fixtures
- **SC-007**: CLI smoke tests pass for template selection and workspace generation scenarios

## Assumptions

- The workspace structure, namespace conventions, and folder organization defined in this phase will remain stable through all subsequent phases
- The Rust CLI/TUI implementation provides the interactive and scripted entry points for all workspace and service operations
- Module repositories for `nfw` CLI and core framework packages will be implemented as separate git submodules
- Core framework packages (Domain, Application, etc.) will be created as needed based on framework requirements
- Generated .NET services target .NET 11 as the baseline runtime
- Templates are distributed as git repositories that can be cloned to a local cache
- Template repositories contain metadata describing the template (name, description, supported features) in a standard format
- Workspace configuration is stored in `nfw.yaml` in YAML format
- Architecture rules are defined as forbidden project references and namespace/package usage patterns

## Dependencies

- **Submodule structure**: Git submodules for `src/nfw` and core framework packages must be created and initialized as needed
- **PRD Section 11**: Technical considerations for workspace conventions, CLI implementation language, and baseline structure
- **ROADMAP Phase 2**: Source generator work depends on stable workspace and service conventions from this phase
- **ROADMAP Phase 3**: Adapter work depends on stable domain and application abstractions from this phase

## Clarifications

- Q: Should the workspace creation support custom folder structures or only the standard NFramework layout? → A: Only the standard NFramework layout is supported in Phase 1. Custom layouts are out of scope to ensure generator stability and architecture enforcement.
- Q: Can users skip certain layers (e.g., create a service without Infrastructure layer)? → A: No. All four layers (Domain, Application, Infrastructure, Api) are mandatory to preserve architectural boundaries.
- Q: Should `nfw check` support auto-fix for violations or only detection? → A: Detection only in Phase 1. Auto-fix is deferred to a later phase to avoid unexpected code modifications.
- Q: How should the `nfw check` command handle architecture rule definitions? → A: Hardcoded rules defined by the framework with clear documentation (framework enforces consistent layer dependency rules, namespace restrictions, and structural requirements across all workspaces)
- Q: How should the CLI detect that it's running within an NFramework workspace? → A: Presence of `nfw.yaml` file at workspace root
- Q: When `nfw new` is run and the target directory already exists, what should happen? → A: Fail with error if directory exists and is not empty
- Q: What protocol should be used for remote template repositories? → A: Git-based templates (clone repos for templates)
- Q: What format should `nfw.yaml` use for workspace configuration? → A: YAML format
- Q: How should template git clone operations be tested? → A: Unit tests mock git operations (no network access); integration tests use real git clone but are clearly isolated and labeled as integration tests
- Q: What is the baseline developer hardware for performance targets? → A: 2 CPU cores, 4GB RAM
- Q: What cleanup should occur on Ctrl+C interrupt? → A: Delete any partially created files or directories, exit with code 130 on Unix-like systems

## Non-Goals

- Supporting ASP.NET MVC or controller-based scaffolding
- Providing runtime reflection fallbacks for framework features
- Supporting every database, queue, or cloud provider in the first release
- Generating arbitrary non-standard project layouts
- Hiding all generated code from developers (generated code should be inspectable and debuggable)
- Supporting distributed .NET features (Aspire, Dapr)
- Polyglot support (Go, Rust service scaffolding)
- MCP-compatible tooling integrations
- Source-generated DI registration or route generation (deferred to Phase 2)
- Command, query, or CRUD generation (deferred to Phase 2/3)

## Downstream Specifications Required

The following project-level specifications must be created in module repositories to implement this orchestrator spec:

1. **nfw CLI/TUI Specification** (`src/nfw/specs/`):
   - Command parsing and routing
   - Interactive and non-interactive workflows
   - Template catalog management
   - Workspace creation orchestration
   - Service generation orchestration
   - Architecture validation

2. **Core Framework Packages** (created as needed):
   - Domain abstractions (`Entity<TId>`, AggregateRoot, ValueObject, DomainEvent)
   - Application abstractions (Result types, CQRS contracts, validation)
   - Specific package structure and naming to be determined during implementation

3. **Template Metadata Specification** (`src/nfw/specs/` or separate template repo):
   - Template schema and structure
   - Template catalog format
   - Remote template discovery
   - Template versioning rules

4. **Workspace Conventions Specification** (root `specs/` or as part of nfw CLI spec):
   - Folder structure definition
   - Namespace conventions
   - Solution file organization
   - `nfw.yaml` configuration file format (YAML schema)
   - Configuration file locations

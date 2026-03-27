# Contributing to NFramework

Thank you for your interest in contributing to NFramework.

## Prerequisites

- .NET 11 (preview)
- C# 12+
- Git

## Getting Started

```bash
git clone https://github.com/n-framework/n-framework.git
cd n-framework
make setup
```

`make setup` initializes submodules and restores tooling.

## Development Commands

| Command       | Description                          |
| ------------- | ------------------------------------ |
| `make setup`  | Initialize submodules and tooling    |
| `make format` | Format C# and config files           |
| `make lint`   | Run static analysis and style checks |

Each command has an equivalent script in `./scripts/` (e.g., `./scripts/format.sh`).

## Key Rules

- **Pure Core**: Domain and Application layers must not depend on infrastructure libraries
- **Compile-Time Generation**: Use source generators instead of runtime reflection
- **Explicit Outcomes**: Use `Result<T>` pattern instead of exceptions for expected failures
- **Feature-Based Structure**: Organize code by feature, not by layer type

## Code Style

- File-scoped namespaces, LF line endings, 4-space indentation
- PascalCase for types and public members, `_camelCase` for private fields
- Explicit types (no `var`), `sealed` classes by default
- Format with CSharpier (`make format`), lint with Roslynator (`make lint`)

## Specifications

This repo follows spec-driven development. See [SPECIFICATION_GUIDELINES.md](SPECIFICATION_GUIDELINES.md) for the full workflow.

Specs live in:

- Meta-repo: `docs/`
- Module specs: `specs/<id>-<slug>/`

## License

Contributions are licensed under the Apache License 2.0. See [LICENSE](../LICENSE).

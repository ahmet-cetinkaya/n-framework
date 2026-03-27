<!-- markdownlint-disable MD041 -->

# `NFramework`

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/n-framework/n-framework?style=social)](https://github.com/n-framework/n-framework/stargazers)
[![GitHub stars](https://img.shields.io/github/stars/n-framework/n-framework?style=social)](https://github.com/n-framework/n-framework/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/n-framework/n-framework?style=social)](https://github.com/n-framework/n-framework/network/members)
[![GitHub contributors](https://img.shields.io/github/contributors/n-framework/n-framework)](https://github.com/n-framework/n-framework/graphs/contributors)
[![GitHub issues](https://img.shields.io/github/issues/n-framework/n-framework)](https://github.com/n-framework/n-framework/issues)
[![Buy A Coffee](https://img.shields.io/badge/Buy%20a%20Coffee-ffdd00?logo=buy-me-a-coffee&logoColor=black&style=flat)](https://ahmetcetinkaya.me/donate)

NFramework is a compile-time-first framework and workspace standard for building clean architecture services across `.NET`, `Go`, and `Rust`.

It is designed for teams that want faster service setup, stronger architecture boundaries, and one consistent model for building polyglot services without relying on reflection-heavy runtime conventions.

## ❗ What NFramework Tries to Fix

Modern service teams keep running into the same problems:

- Too much manual scaffolding before a service becomes useful
- Clean architecture rules that exist in docs but are not enforced in code
- Infrastructure concerns leaking into application and domain layers
- Reflection-heavy frameworks that work against trimming and Native AOT goals
- Inconsistent project structure across teams and languages

NFramework aims to solve those problems with one opinionated system:

- CLI-driven workspace and service generation
- Compile-time generation instead of runtime discovery where practical
- Strict architectural boundaries
- Topic-specific abstractions with replaceable infrastructure adapters
- MCP support for tool and agent integrations
- One workspace model across multiple languages

## 💡 Why It Matters

NFramework is built around a simple idea: service foundations should be explicit, enforceable, and generated safely at build time.

That means the project is optimized around these principles:

- Compile-time behavior over runtime magic
- Pure core layers with no direct infrastructure coupling
- Explicit business outcomes over exception-driven flow
- Replaceable adapters instead of hard framework lock-in
- Cloud-ready direction without polluting the core model
- One architectural standard across multiple languages

## 🛠 Planned Developer Experience

The long-term developer workflow centers on the `nfw` CLI for polyglot workspaces and services.

Representative commands include:

```bash
nfw templates
nfw new my-workspace
nfw add service orders --lang dotnet
nfw add entity Product --props Name:string,Price:decimal
nfw add command ApproveOrder Orders
nfw add query GetOrderByNumber Orders
nfw check
```

These commands describe the intended product direction. They should not be read as a guarantee that every workflow is fully implemented in the current repository state.

## 📚 Documentation

Start with [docs/README.md](docs/README.md) for the full documentation index and entry point.

## 🤝 Contributing

Contributions are welcome across framework direction, developer workflow, documentation quality, and the core platform work that will prove the polyglot model.

For setup, standards, and day-to-day commands, see [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).

## 📄 License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

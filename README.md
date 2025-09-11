# Bitiq Ecosystem

Welcome to the central repository for the Bitiq ecosystem! This repository serves as the foundation for all Bitiq projects, providing standardized development guides, documentation templates, and best practices.

## What is Bitiq?

Bitiq is a FOSS (Free and Open Source Software), AI-enhanced search engine for Nostr that incorporates Web-of-Trust concepts. The platform consists of multiple microservices running on OpenShift, leveraging GitOps and Pipelines for deployment and ODF for storage.

## Purpose of This Repository

The `ecosystem` repository is the central hub for:

- Development standards and best practices
- Project management workflows
- Documentation templates
- Architectural guidance

Rather than duplicating these standards across multiple repositories, we maintain them here as a single source of truth that all Bitiq projects reference.

## Repository Structure

```
ecosystem/
├── CONTRIBUTING.md        # Contribution guidelines for all Bitiq projects
├── README.md              # This file
├── guides/                # Comprehensive development guides
│   └── golang-microservices.md 
├── project-management/    # Project lifecycle and templates
│   ├── project-lifecycle.md
│   ├── spec-template.md
│   ├── todo-template.md
│   └── adr-template.md
└── docs/                  # General ecosystem documentation
    └── architecture-overview.md
```

## Key Resources

### Development Guides

- [Golang Microservices Development Guide](guides/golang-microservices.md) - Definitive standards for Bitiq Golang microservices

### Project Management

- [Project Lifecycle Guide](project-management/project-lifecycle.md) - The complete Bitiq project lifecycle from ideation to maintenance
- [SPEC.md Template](project-management/spec-template.md) - Template for creating project specifications
- [ADR Template](project-management/adr-template.md) - Template for Architecture Decision Records

## Contribution Guidelines

Please review our [CONTRIBUTING.md](CONTRIBUTING.md) and guides like [Automation Workflow](guides/automation-workflow.md) and [Golang Microservices](guides/golang-microservices.md) before contributing. Any AI assistant involved in this repository should adhere to these guidelines.

## How to Use This Repository

### For New Contributors

1. Start by reading the [CONTRIBUTING.md](CONTRIBUTING.md) to understand our workflow
2. Familiarize yourself with the [Project Lifecycle Guide](project-management/project-lifecycle.md)
3. Reference the appropriate development guide for your project type
4. Use the templates when creating new documents in any Bitiq project

### For Project Maintainers

1. Reference these documents in your project READMEs
2. Ensure your project follows the established structure and standards
3. Propose updates to these standards when improvements are identified

### Initializing a New Project

When starting a new repository, copy the standard documentation templates from this repository:

```bash
# from the root of your new project
cp path/to/ecosystem/project-management/spec-template.md SPEC.md
cp path/to/ecosystem/project-management/todo-template.md TODO.md
mkdir -p docs/adr
cp path/to/ecosystem/project-management/adr-template.md docs/adr/0001-example-decision.md
```

Place `SPEC.md` and `TODO.md` in the project root (or within a `docs/` directory). Each ADR should live in `docs/adr/` using the template with an incrementing number and descriptive title.

## Related Projects

- [example-backend](https://github.com/paulcapestany/example-backend) - Reference implementation of a Bitiq microservice
- *(Other projects will be listed here as they are created)*

## Contributing

We welcome contributions to improve these standards and templates! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## Release Process

Commits are validated against the [Conventional Commits](https://www.conventionalcommits.org/) specification using commitlint and Husky. A GitHub Actions workflow runs [semantic-release](https://semantic-release.gitbook.io) on pushes to `main` to tag new releases based on commit history.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- GitHub Issues: Please use issues in this repository for questions or suggestions about ecosystem-wide standards
- Project-specific questions should go to their respective repositories

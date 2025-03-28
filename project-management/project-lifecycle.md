# Bitiq Project Lifecycle Guide

**Version:** 1.0.0  
**Last Updated:** 2025-03-28  
**Status:** Approved

## Table of Contents

- [Bitiq Project Lifecycle Guide](#bitiq-project-lifecycle-guide)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Project Lifecycle Overview](#project-lifecycle-overview)
  - [Phase 1: Ideation and Specification](#phase-1-ideation-and-specification)
    - [Activities](#activities)
    - [Key Deliverable: SPEC.md](#key-deliverable-specmd)
    - [SPEC.md Creation Process](#specmd-creation-process)
    - [Roles and Responsibilities](#roles-and-responsibilities)
  - [Phase 2: Planning and Task Creation](#phase-2-planning-and-task-creation)
    - [Activities](#activities-1)
    - [Key Deliverable: TODO.md](#key-deliverable-todomd)
    - [Converting Specifications to Tasks](#converting-specifications-to-tasks)
    - [Example Conversion](#example-conversion)
  - [Phase 3: Development and Implementation](#phase-3-development-and-implementation)
    - [Activities](#activities-2)
    - [Development Workflow](#development-workflow)
    - [Making Architecture Decisions](#making-architecture-decisions)
  - [Phase 4: Testing and Validation](#phase-4-testing-and-validation)
    - [Activities](#activities-3)
    - [Validation Against Specifications](#validation-against-specifications)
  - [Phase 5: Deployment and Release](#phase-5-deployment-and-release)
    - [Activities](#activities-4)
    - [Release Process](#release-process)
  - [Phase 6: Maintenance and Evolution](#phase-6-maintenance-and-evolution)
    - [Activities](#activities-5)
    - [Evolution Process](#evolution-process)
  - [Document Standards](#document-standards)
    - [SPEC.md Format](#specmd-format)
      - [1. Header Information](#1-header-information)
      - [2. Overview](#2-overview)
      - [3. Core Functionality](#3-core-functionality)
      - [4. Technical Requirements](#4-technical-requirements)
      - [5. Non-Functional Requirements](#5-non-functional-requirements)
      - [6. Development Process](#6-development-process)
      - [7. Deliverables](#7-deliverables)
      - [8. Acceptance Criteria](#8-acceptance-criteria)
      - [9. Additional Resources](#9-additional-resources)
      - [10. Change History](#10-change-history)
    - [TODO.md Format](#todomd-format)
    - [README.md Format](#readmemd-format)
    - [Architecture Decision Records](#architecture-decision-records)
  - [Workflows and Processes](#workflows-and-processes)
    - [Specification Changes](#specification-changes)
    - [Issue and Task Management](#issue-and-task-management)
    - [Release Management](#release-management)
  - [Appendix: Templates and Examples](#appendix-templates-and-examples)

## Introduction

This guide describes the standard project lifecycle for Bitiq microservices, from initial concept through development, deployment, and maintenance. It defines the key documents, processes, and practices that ensure consistency, quality, and efficiency across all Bitiq projects.

Our project lifecycle is designed to be:
- **Lightweight** - Focusing on essential documents and processes
- **Developer-friendly** - Supporting efficient development workflows
- **Transparent** - Making project status and decisions visible
- **Consistent** - Ensuring uniform practices across services

This guide serves as the definitive reference for how projects are managed within the Bitiq ecosystem.

## Project Lifecycle Overview

The Bitiq project lifecycle consists of six primary phases:

1. **Ideation and Specification** - Define what needs to be built
2. **Planning and Task Creation** - Break down work into actionable tasks
3. **Development and Implementation** - Build the service
4. **Testing and Validation** - Ensure quality and correctness
5. **Deployment and Release** - Make the service available
6. **Maintenance and Evolution** - Support and improve the service

Key documents guide each phase:
- **SPEC.md** - Project requirements and specifications document
- **TODO.md** - Prioritized tasks and development tracking
- **README.md** - Service documentation and usage guide
- **Architecture Decision Records (ADRs)** - Record of key technical decisions

![Project Lifecycle Diagram](../workflow-diagrams/project-lifecycle.png)

## Phase 1: Ideation and Specification

The project begins with defining what needs to be built and why.

### Activities

1. **Identify Need** - Determine the purpose and value of the new service
2. **Research** - Investigate technical options and constraints
3. **Draft Specification** - Create initial SPEC.md document
4. **Review** - Seek feedback from stakeholders
5. **Finalize** - Refine and approve the specification

### Key Deliverable: SPEC.md

The SPEC.md document defines the service requirements, scope, and technical specifications. It serves as the reference point throughout development and answers the fundamental question: "What are we building and why?"

### SPEC.md Creation Process

1. Start with the [SPEC.md template](./spec-template.md)
2. Fill in all required sections
3. Review with relevant stakeholders
4. Iterate based on feedback
5. Finalize and commit to the repository

### Roles and Responsibilities

- **Project Manager or Tech Lead** - Primary author of SPEC.md
- **Engineering Team** - Technical review and input
- **Stakeholders** - Requirements validation and approval

## Phase 2: Planning and Task Creation

Once the specifications are defined, the work is broken down into actionable tasks.

### Activities

1. **Decompose Requirements** - Break specs into implementable components
2. **Define Tasks** - Create specific, actionable development tasks
3. **Prioritize** - Determine task sequence and importance
4. **Estimate** - Assess effort and complexity
5. **Document** - Populate the TODO.md file

### Key Deliverable: TODO.md

The TODO.md file organizes tasks into a structured format compatible with Semantic Versioning and Conventional Commits. It provides a clear roadmap for development and tracks progress.

### Converting Specifications to Tasks

Each requirement in SPEC.md should be translated into one or more tasks in TODO.md:

1. **Group by Type** - Categorize as features, fixes, refactoring, etc.
2. **Scope Appropriately** - Each task should be completable in a reasonable timeframe
3. **Define Acceptance Criteria** - What does "done" look like for each task?
4. **Assign GitHub Issue Numbers** - Create corresponding issues and reference them
5. **Prioritize** - Order tasks by importance and dependencies

### Example Conversion

**From SPEC.md:**
```markdown
### API Design

1. **gRPC Service Definition** - Define the service in Protocol Buffers with these operations:
   - `CreateEvent` - Create a new Nostr event
   - `GetEvents` - Retrieve events with filters
   - `GetEvent` - Retrieve a single event by ID
```

**To TODO.md:**
```markdown
### Feat ✨
- [ ] **api:** Define base proto service definition (#10)
- [ ] **api:** Implement CreateEvent gRPC method (#11)
- [ ] **api:** Implement GetEvents gRPC method (#12)
- [ ] **api:** Implement GetEvent gRPC method (#13)
- [ ] **api:** Configure gRPC-Gateway for REST endpoints (#14)
```

## Phase 3: Development and Implementation

The development phase is where the service is actually built according to the specifications and tasks.

### Activities

1. **Repository Setup** - Initialize codebase with standard structure
2. **Architecture Implementation** - Build core components based on ADRs
3. **Feature Development** - Implement tasks from TODO.md
4. **Code Reviews** - Ensure quality through peer review
5. **Documentation** - Update code comments and README.md

### Development Workflow

1. Select a task from TODO.md
2. Create a feature branch using the Conventional Commits format
   - Example: `feat/implement-create-event-endpoint`
3. Implement the functionality
4. Write tests
5. Update documentation
6. Submit a Pull Request
7. Address review feedback
8. Merge to the main branch
9. Mark the task as completed in TODO.md

### Making Architecture Decisions

When significant technical decisions arise during development:

1. Draft an Architecture Decision Record (ADR)
2. Review with the engineering team
3. Finalize and store in the `docs/adr/` directory
4. Reference the ADR in code comments and documentation

## Phase 4: Testing and Validation

Comprehensive testing ensures the service meets its requirements and quality standards.

### Activities

1. **Unit Testing** - Test individual components
2. **Integration Testing** - Test component interactions
3. **End-to-End Testing** - Test complete workflows
4. **Performance Testing** - Verify performance characteristics
5. **Security Testing** - Identify and address vulnerabilities

### Validation Against Specifications

Before completing development:

1. Review each requirement in SPEC.md
2. Verify implementation against specifications
3. Document any differences or limitations
4. Update tests to cover all requirements
5. Ensure all tasks in TODO.md are completed or explicitly deferred

## Phase 5: Deployment and Release

Once developed and tested, the service is deployed to production environments.

### Activities

1. **Version Tagging** - Create release version based on semantic versioning
2. **CHANGELOG Generation** - Document changes since previous release
3. **Container Build** - Create and test container images
4. **Deployment** - Update GitOps configuration for target environments
5. **Verification** - Confirm successful deployment and operation

### Release Process

1. Ensure all tests pass
2. Generate CHANGELOG from Conventional Commits history
3. Create a release tag following semantic versioning
4. Build and push container images
5. Update deployment manifests in GitOps repository
6. Monitor deployment progress and health

## Phase 6: Maintenance and Evolution

After initial deployment, the service enters the maintenance and evolution phase.

### Activities

1. **Monitoring** - Track service health and performance
2. **Bug Fixing** - Address issues as they arise
3. **Feature Enhancements** - Implement new capabilities
4. **Technical Debt** - Refactor and improve codebase
5. **Documentation Updates** - Keep documentation current

### Evolution Process

When significant new features or changes are needed:

1. Create a new section in SPEC.md for the enhancements
2. Add new tasks to TODO.md
3. Follow the development workflow for implementing changes
4. Release new versions according to semantic versioning principles

## Document Standards

### SPEC.md Format

The SPEC.md document should include the following sections:

#### 1. Header Information
```markdown
# Service Name Project Specification

**Version:** 1.0.0  
**Date:** YYYY-MM-DD  
**Status:** [Draft|In Review|Approved]  
```

#### 2. Overview
A brief description of the service, its purpose, and its role in the Bitiq ecosystem.

#### 3. Core Functionality
Clear description of what the service will do, focusing on user-facing functionality.

#### 4. Technical Requirements
Detailed technical specifications, including:
- Service architecture
- API design
- Data models
- External dependencies
- Storage requirements

#### 5. Non-Functional Requirements
Requirements related to:
- Performance
- Security
- Scalability
- Observability
- Reliability

#### 6. Development Process
Any specific guidance for the development process.

#### 7. Deliverables
Concrete outputs expected from the project.

#### 8. Acceptance Criteria
Conditions that must be met for the project to be considered complete.

#### 9. Additional Resources
References, links, and other relevant information.

#### 10. Change History
Record of significant changes to the specification.

### TODO.md Format

The TODO.md document organizes tasks using Conventional Commits categories and semantic versioning:

```markdown
# TODO - Service Name

## [Unreleased]

### Feat ✨
- [ ] **scope:** Description of feature task (#issue-number)
- [x] **scope:** Completed feature task (#issue-number)

### Fix 🐛
- [ ] **scope:** Description of bug fix (#issue-number)

### Refactor 🔨
- [ ] **scope:** Description of refactoring task (#issue-number)

## [v1.0.0] - YYYY-MM-DD

### Feat ✨
- [x] **scope:** Completed feature from previous release (#issue-number)
```

Common categories include:
- **Feat ✨** - New features
- **Fix 🐛** - Bug fixes
- **Docs 📚** - Documentation changes
- **Style 💎** - Formatting, white-space, etc.
- **Refactor 🔨** - Code changes that neither fix bugs nor add features
- **Perf ⚡** - Performance improvements
- **Test 🧪** - Adding or modifying tests
- **Build 🏗️** - Changes to build process or tools
- **CI 🤖** - Changes to CI configuration
- **Chore 🧹** - Other changes that don't modify src or test files

> **Note:** The emoji icons are optional but provide visual distinction between categories.

### README.md Format

The README.md should include:

1. **Service Overview** - What the service does
2. **Getting Started** - Setup and installation instructions
3. **Usage** - How to use the service
4. **API Documentation** - Endpoints and methods
5. **Configuration** - Available options
6. **Development** - How to contribute
7. **Testing** - How to run tests
8. **Deployment** - How to deploy
9. **References** - Related resources

### Architecture Decision Records

ADRs should follow this format:

```markdown
# ADR-NNNN: Title

## Status
[Proposed|Accepted|Deprecated|Superseded by ADR-XXXX]

## Context
Description of the issue and relevant background.

## Decision
The decision that was made.

## Consequences
What becomes easier or more difficult as a result of this decision?

## Alternatives Considered
What other options were considered and why were they not chosen?

## References
Links to relevant information.
```

Store ADRs in the `docs/adr/` directory with sequential numbering:
- `0001-use-couchbase.md`
- `0002-adopt-grpc.md`
- etc.

## Workflows and Processes

### Specification Changes

When requirements change during development:

1. **Document the Change**
   - Update SPEC.md with the new requirements
   - Add an entry to the Change History section
   - Include rationale for the change

2. **Update Tasks**
   - Modify affected tasks in TODO.md
   - Add new tasks as needed
   - Clearly mark any removed tasks

3. **Communicate**
   - Notify the team of the changes
   - Discuss impacts on timeline and dependencies
   - Update any related issues or pull requests

4. **Assess Impact**
   - Determine if the change affects the architecture
   - Create new ADRs if necessary
   - Update existing documentation

### Issue and Task Management

To maintain alignment between GitHub issues and TODO.md:

1. **Create issues** for each significant task
2. **Reference issue numbers** in TODO.md entries
3. **Update both** when tasks are completed or changed
4. **Use labels** that correspond to Conventional Commits categories

### Release Management

When preparing a release:

1. **Review specifications** to ensure all requirements are met
2. **Move completed tasks** in TODO.md to the appropriate version section
3. **Generate CHANGELOG** from commit history
4. **Tag the release** with semantic version
5. **Update documentation** to reflect the new release

## Appendix: Templates and Examples

- [SPEC.md Template](./spec-template.md)
- [TODO.md Template](./todo-template.md)
- [README.md Template](./readme-template.md)
- [ADR Template](./adr-template.md)
- [Example Service: example-backend](https://github.com/bitiq/example-backend)

---

This document serves as the definitive guide for the Bitiq project lifecycle. By following these standards and processes, we ensure consistency, quality, and efficiency across all services in the Bitiq ecosystem. For questions or suggestions regarding this document, please open an issue in the ecosystem repository.
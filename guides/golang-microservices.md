# Bitiq Golang Microservices: Definitive Development Guide

**Version:** 1.0.0  
**Last Updated:** 2025-03-28  

## Table of Contents
1. [Introduction](#introduction)
2. [Core Principles](#core-principles)
3. [Project Structure and Organization](#project-structure-and-organization)
4. [API Design and Implementation](#api-design-and-implementation)
5. [Coding Standards and Practices](#coding-standards-and-practices)
6. [Error Handling](#error-handling)
7. [Logging and Observability](#logging-and-observability)
8. [Testing Strategy](#testing-strategy)
9. [Version Control and Contribution Workflow](#version-control-and-contribution-workflow)
10. [CI/CD and GitOps](#cicd-and-gitops)
11. [Documentation Standards](#documentation-standards)
12. [Security Guidelines](#security-guidelines)
13. [Local Development and Concurrency](#local-development-and-concurrency)
14. [Appendix and References](#appendix-and-references)

---

## Introduction

Welcome to the definitive guide for developing and contributing to Bitiq's Golang microservices. Bitiq is a **FOSS** (Free and Open Source Software), AI-enhanced search engine for **Nostr** (a decentralized protocol for social networking and event sharing) that incorporates Web-of-Trust concepts. The platform consists of multiple microservices running on OpenShift, leveraging GitOps and Pipelines for deployment, and ODF for storage.

This document consolidates best practices, standards, and workflows to ensure code quality, consistency, maintainability, and effective collaboration across all Bitiq Golang microservices. It serves as both a reference for experienced Go developers and a learning resource for those newer to Go or microservice architectures.

### Project Architecture Overview

Bitiq employs a microservices architecture, with each service having a specific responsibility:

- **strfry**: 3rd party Nostr relay (C++)
- **nostouch**: Ingests Nostr events from strfry and stores them in Couchbase
- **nostr_threads**: Constructs and manages threads from Nostr events
- **nostr_query**: Handles search requests (FTS and vector similarity search)
- **nostr_ai**: Generates vector embeddings for Nostr threads
- **nostr_site**: Provides a search interface for end users

All services communicate via well-defined APIs and operate in a cloud-agnostic manner on OpenShift.

---

## Core Principles

Our development philosophy is guided by these core principles:

* **FOSS Values:** We operate with transparency, encourage community collaboration, and strive for the highest quality in our open-source offerings.
* **Robustness & Reliability:** Inspired by cypherpunk and Bitcoin principles, our services must be resilient, fault-tolerant, and performant. Rigorous testing and meticulous error handling are paramount.
* **Clarity & Maintainability:** Code should be easy to understand, well-documented, and maintainable over the long term.
* **Security:** Protecting the system and potentially user-related data (even pseudonymous Nostr data) is a fundamental requirement.
* **Automation:** We leverage automation for testing, building, deployment (via OpenShift GitOps/Pipelines), and code quality checks wherever possible.

---

## Project Structure and Organization

### Directory Structure

We follow a standard Go project layout with some Bitiq-specific adaptations:

```
service-name/
├── api/
│   ├── grpc/
│   │   └── proto/
│   └── rest/
│       └── openapi/
├── cmd/
│   └── service-name/
│       └── main.go
├── docs/
│   └── adr/
├── internal/
│   ├── config/
│   ├── models/
│   ├── repository/
│   ├── server/
│   └── service/
├── pkg/
│   └── shared/
├── scripts/
├── test/
│   ├── integration/
│   └── performance/
├── Dockerfile
├── go.mod
├── go.sum
├── CHANGELOG.md
├── Makefile
├── README.md
├── SPEC.md
└── TODO.md
```

**Purpose of each directory:**

- **/cmd/service-name/**: Main application entry point with minimal code that parses config and initializes the service. Keep `main.go` small—it just wires things together.

- **/internal/**: Private application code that should not be imported by other projects. Most of your service's code lives here:
  - **/config/**: Configuration structures and loading logic
  - **/models/**: Domain model definitions
  - **/repository/**: Data access logic (Couchbase interactions, etc.)
  - **/server/**: API server implementation (gRPC, HTTP handlers)
  - **/service/**: Core business logic

- **/pkg/**: (Optional) Library code that's OK to be used by external applications. Use sparingly—prefer `/internal/` for service-specific code.

- **/api/**: API definitions
  - **/grpc/proto/**: Protocol Buffer definitions for gRPC services
  - **/rest/openapi/**: OpenAPI specifications for REST endpoints

- **/scripts/**: Utility scripts for building, deploying, etc.

- **/test/**: Additional test files beyond the standard Go unit tests
  - **/integration/**: Tests that verify components working together
  - **/performance/**: Load and performance tests

### Project Documentation Standards

Each microservice repository **MUST** include these key documents:

1. **SPEC.md**: Defines project requirements and specifications (what the service should do)
2. **README.md**: Provides setup instructions, usage guides, and overview information
3. **TODO.md**: Tracks pending development tasks in Conventional Commits format
4. **CHANGELOG.md**: Automatically generated record of all changes (generated from commit history)

The relationship between these documents follows the project lifecycle:
- SPEC.md defines the "what and why" (requirements)
- TODO.md lists the "what's next" (pending implementation tasks)
- README.md explains the "how to use" (consumption)
- CHANGELOG.md documents the "what changed" (history)

See the [Project Lifecycle Guide](../project-management/project-lifecycle.md) for detailed information on these documents and workflow.

Example TODO.md:
```markdown
# TODO - `nostr_query` Service

## Next Release Tasks

### feat: Features
- feat(api): define initial gRPC service for vector search (#123)
- feat(search): implement cosine similarity calculation (#124)

### fix: Bug Fixes
- fix(config): load Couchbase credentials from environment variables (#125)
```

Following the automation-friendly approach:
1. When a task is implemented, use its description as your commit message
2. After the commit, remove the task from TODO.md
3. The task will automatically become part of the project history via commit logs
4. CHANGELOG.md can be automatically generated for each release

### Development Workflow

1. Select a task from TODO.md
2. Create a feature branch with a name that matches the task type/scope
   - Example: `feat/vector-search-api`
3. Implement the functionality
4. Commit with a message that exactly matches the TODO item
   - Example: `feat(api): define initial gRPC service for vector search (#123)`
5. Remove the completed task from TODO.md
6. Submit a Pull Request
7. After approval and merging, the commit becomes part of the project history
8. For releases, generate CHANGELOG.md automatically from commits

### Makefile Standards

Every service should include a `Makefile` with at least these standard targets. You can define environment-specific variables (like `SERVICE_NAME`, `REGISTRY`, and `VERSION`) at the top of the Makefile **or** pass them in through environment variables in your CI/CD pipeline:

```makefile
.PHONY: build test lint run dev-setup docker-build docker-push deploy-dev generate clean

# Variables can be defined here or passed via env vars
SERVICE_NAME ?= nostr_query
REGISTRY ?= quay.io/bitiq
VERSION ?= latest

# Build the service binary
build:
	go build -o bin/$(SERVICE_NAME) ./cmd/$(SERVICE_NAME)

# Run all tests
test:
	go test -race -coverprofile=coverage.out ./...

# Run linters
lint:
	golangci-lint run

# Run the service locally
run:
	go run ./cmd/$(SERVICE_NAME)

# Set up development environment
dev-setup:
	go mod download
	# Additional setup commands...

# Build Docker image
docker-build:
	docker build -t $(REGISTRY)/$(SERVICE_NAME):$(VERSION) .

# Push Docker image to registry
docker-push:
	docker push $(REGISTRY)/$(SERVICE_NAME):$(VERSION)

# Deploy to development environment
deploy-dev:
	# OpenShift/Kubernetes deployment commands...

# Generate code from protobuf/OpenAPI definitions
generate:
	protoc -I=api/grpc/proto --go_out=. --go-grpc_out=. api/grpc/proto/*.proto
	# Additional generation commands...

# Clean build artifacts
clean:
	rm -rf bin/ coverage.out
```

> **Tip:** Always include a `clean` target so developers can remove build artifacts, coverage files, etc., ensuring a fresh build environment.

---

## API Design and Implementation

### API-First Approach

We use an **API-first** approach to define clear contracts before implementation. This encourages thoughtful design and enhances collaboration between frontend and backend teams.

### gRPC for Internal Communication

All internal service-to-service communication must use gRPC for these benefits:

- **Performance**: Binary Protocol Buffers over HTTP/2 provide efficient serialization
- **Type Safety**: Strong typing with code generation prevents many runtime errors
- **Streaming**: Support for client, server, and bidirectional streaming
- **Language Agnostic**: Clients can be generated in many languages

Example proto file structure:

```protobuf
syntax = "proto3";

package bitiq.nostr_query.v1;

option go_package = "github.com/paulcapestany/nostr_query/api/grpc/proto/v1";

service NostrQueryService {
  rpc Search(SearchRequest) returns (SearchResponse);
  rpc GetThread(GetThreadRequest) returns (GetThreadResponse);
  rpc StreamUpdates(StreamUpdatesRequest) returns (stream UpdateEvent);
}

message SearchRequest {
  string query = 1;
  int32 page = 2;
  int32 page_size = 3;
  SearchType search_type = 4;
}

enum SearchType {
  SEARCH_TYPE_UNSPECIFIED = 0;
  SEARCH_TYPE_FTS = 1;
  SEARCH_TYPE_VECTOR = 2;
  SEARCH_TYPE_HYBRID = 3;
}
```

### REST/HTTP APIs with gRPC-Gateway

For external-facing services, we use **gRPC-Gateway** to expose REST APIs derived from our gRPC definitions. This gives us the best of both worlds:

- Internal high-performance gRPC calls  
- External-friendly REST/JSON endpoints  
- Single source of truth for API definitions  
- Automatic OpenAPI generation  

Example gRPC-Gateway annotation in proto:

```protobuf
service NostrQueryService {
  rpc Search(SearchRequest) returns (SearchResponse) {
    option (google.api.http) = {
      get: "/api/v1/search"
    };
  }
}
```

### API Versioning

1. Use semantic versioning for all APIs.  
2. Include the version in the URL path (e.g., `/api/v1/resource`).  
3. Never make breaking changes to published APIs without a version increment.  
4. Maintain backward compatibility within a major version.

### OpenAPI/REST Services

Some services may primarily serve external clients and prefer OpenAPI-first design with **oapi-codegen**:

1. Define your API in OpenAPI 3.0 YAML/JSON.  
2. Generate server stubs using `oapi-codegen`.  
3. Implement the generated interfaces.  

The resulting OpenAPI definition also feeds into tools like Swagger UI or ReDoc for easily browsable docs.

---

## Coding Standards and Practices

### Language Version

We standardize on **Go 1.21+** to leverage newer features like the `slog` package for structured logging.

### Formatting and Linting

1. **Formatting**: All code **MUST** be formatted with `gofmt` or `go fmt`. Configure your editor to run this automatically on save.
2. **Linting**: We use `golangci-lint` with a standard configuration. Create a `.golangci.yml` file in each project:

```yaml
run:
  timeout: 5m
  tests: true
  skip-dirs: 
    - vendor

linters:
  enable:
    - errcheck       # Checks for unchecked errors
    - govet          # Examines code for suspicious constructs
    - staticcheck    # Comprehensive static analysis
    - gofmt          # Formatting
    - goimports      # Import organization
    - ineffassign    # Detects unused variable assignments
    - unused         # Detects unused code
    - gosimple       # Simplifies code
    - revive         # Replacement for golint
    - bodyclose      # Checks for unclosed HTTP response bodies
    - gocritic       # Advanced linter with many checks
```

### Naming Conventions

1. **Package names** are lowercase, single-word (no underscores/camelCase).  
2. **Identifiers**: In Go, *unexported* identifiers typically use `camelCase`. *Exported* identifiers use `PascalCase`.  
3. **Acronyms**: Use consistent capitalization of acronyms (`HTTPServer`, not `HttpServer`).  
4. **Clarity**: Descriptive but concise—avoid unnecessary abbreviations.

Example:

```go
// Good
type OrderService struct{}

// Exported (PascalCase) method
func (s *OrderService) ProcessPayment(ctx context.Context, orderID string) error {
    // ...
    return nil
}

// Avoid
type OrderSvc struct{}

// Exported method with confusing name
func (s *OrderSvc) ProcPmt(ctx context.Context, ordId string) error {
    // ...
    return nil
}
```

### Variable Declarations

Prefer explicit types for public APIs and use type inference for local variables:

```go
// Public function - explicit types for clarity
func ProcessOrder(order *Order, paymentAmount float64) (*Receipt, error) {
    // Local variable - use := for brevity
    receipt := &Receipt{
        OrderID:      order.ID,
        Amount:       paymentAmount,
        ProcessedAt:  time.Now(),
    }
    return receipt, nil
}
```

### Dependency Management

1. Use Go modules (`go.mod`, `go.sum`).  
2. Pin dependencies to specific versions.  
3. Regularly update dependencies for security patches.  
4. Run `go mod tidy` before commits.  

```sh
# Add a dependency with a specific version
go get github.com/example/package@v1.2.3

# Update dependencies and prune unused ones
go mod tidy
```

### Configuration Management

We follow the 12-factor principle of storing configuration in environment variables (injected via K8s/Secrets). However, you **may** use libraries like [Viper](https://github.com/spf13/viper) or [Koanf](https://github.com/knadh/koanf) if you need advanced features. *Avoid* bundling config files inside the service image.  

Example:

```go
func LoadConfig() (*Config, error) {
    c := &Config{
        CouchbaseURI: os.Getenv("COUCHBASE_URI"),
        Username:     os.Getenv("COUCHBASE_USER"),
        Password:     os.Getenv("COUCHBASE_PASS"),
    }
    // Validate c...
    return c, nil
}
```

---

## Error Handling

Error handling is critical for robust microservices. Follow these principles:

### Error Creation and Wrapping

1. Define **sentinel errors** for known, expected conditions:
   ```go
   var (
       ErrOrderNotFound        = errors.New("order not found")
       ErrInvalidPaymentAmount = errors.New("invalid payment amount")
   )
   ```
2. Use **custom error types** when you need to attach additional context/data:
   ```go
   type ValidationError struct {
       Field string
       Value interface{}
       Reason string
   }

   func (e *ValidationError) Error() string {
       return fmt.Sprintf("validation failed for field %s with value %v: %s",
           e.Field, e.Value, e.Reason)
   }
   ```
3. **Wrap errors** to add context while preserving the original error (Go 1.13+):
   ```go
   return fmt.Errorf("finding order %s: %w", orderID, err)
   ```

4. Check wrapped errors using `errors.Is` or `errors.As`:
   ```go
   if errors.Is(err, ErrOrderNotFound) { ... }
   var vErr *ValidationError
   if errors.As(err, &vErr) { ... }
   ```

> **When to choose sentinel vs. custom error?**  
> - **Sentinel**: Simple, fixed conditions (e.g., “not found”).  
> - **Custom**: When you need extra fields or specialized behavior.

### Error Logging

Always log errors with context:

```go
func (s *Service) ProcessOrder(ctx context.Context, orderID string) error {
    logger := slog.With("service", "order", "method", "ProcessOrder", "orderID", orderID)
    
    logger.Info("Processing order")
    order, err := s.repo.FindOrder(ctx, orderID)
    if err != nil {
        if errors.Is(err, ErrOrderNotFound) {
            logger.Warn("Order not found", "error", err)
            return err
        }
        logger.Error("Failed to find order", "error", err)
        return fmt.Errorf("finding order: %w", err)
    }
    // Process order...
    logger.Info("Order processed successfully")
    return nil
}
```

### Error Handling Rules

1. Never ignore errors unless there's an explicit reason.  
2. Return errors rather than panic in library code.  
3. Handle errors at the appropriate level—don’t just pass them up.  
4. Use custom error types for domain-specific errors that need extra data.  
5. Map internal errors to the correct API status codes (gRPC or HTTP) for clients.

---

## Logging and Observability

Observability consists of **logs**, **metrics**, and **traces**. We implement all three for comprehensive visibility.

### Structured Logging with slog

We standardize on Go's built-in `log/slog` (Go 1.21+) for structured logging:

```go
// Initialize logger (in main.go)
func initLogger() {
    // For production: JSON format
    if os.Getenv("ENV") == "production" {
        slog.SetDefault(slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
            Level: slog.LevelInfo,
        })))
    } else {
        // For development: text format
        slog.SetDefault(slog.New(slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{
            Level: slog.LevelDebug,
        })))
    }
}

// Usage in code
func ProcessRequest(ctx context.Context, req *Request) (*Response, error) {
    logger := slog.With("service", "nostr_query", "method", "ProcessRequest", "requestID", req.ID)
    
    logger.Debug("Processing request")
    if err := req.Validate(); err != nil {
        logger.Error("Request validation failed", "error", err)
        return nil, fmt.Errorf("validating request: %w", err)
    }
    // ...
    logger.Info("Request processed successfully", "requestID", req.ID)
    return resp, nil
}
```

**Benefits:**
- Standard library, no extra deps  
- Structured logging with key-value pairs  
- Different output formats (JSON, text)  
- Leveled logs (DEBUG, INFO, WARN, ERROR)  
- Good performance  

**Always** include relevant context (service name, method name, request ID).

### Metrics with OpenTelemetry

We use **OpenTelemetry** to collect metrics. Define a meter and instruments, then record metrics:

```go
import (
    "go.opentelemetry.io/otel"
    "go.opentelemetry.io/otel/metric"
)

var (
    meter = otel.GetMeterProvider().Meter("bitiq.nostr_query")
    requestCounter = metric.Must(meter).NewInt64Counter(
        "bitiq_nostr_query_requests_total",
        metric.WithDescription("Total number of requests"),
    )
)

func (s *Server) HandleRequest(ctx context.Context, req *pb.Request) (*pb.Response, error) {
    startTime := time.Now()
    requestCounter.Add(ctx, 1, metric.WithAttributes(...))

    // ...
    requestDuration := time.Since(startTime).Seconds()
    // record requestDuration in a histogram, etc.
    return resp, nil
}
```

### Distributed Tracing with OpenTelemetry

Distributed tracing gives end-to-end visibility:

```go
import (
    "go.opentelemetry.io/otel"
    "go.opentelemetry.io/otel/trace"
)

var tracer = otel.GetTracerProvider().Tracer("bitiq.nostr_query")

func (s *Service) ProcessQuery(ctx context.Context, query string) (*Result, error) {
    ctx, span := tracer.Start(ctx, "ProcessQuery")
    defer span.End()

    span.SetAttributes(attribute.String("query", query))
    // ...
    if err != nil {
        span.RecordError(err)
        span.SetStatus(codes.Error, err.Error())
        return nil, err
    }
    // ...
    return result, nil
}
```

**Use instrumentation** for gRPC or HTTP client/servers to propagate trace context automatically.

### Health Checks

Implement HTTP endpoints (or separate gRPC endpoints) for liveness/readiness:

```go
func (s *Server) LivenessHandler(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("alive"))
}

func (s *Server) ReadinessHandler(w http.ResponseWriter, r *http.Request) {
    if !s.db.IsConnected() {
        w.WriteHeader(http.StatusServiceUnavailable)
        w.Write([]byte("database not connected"))
        return
    }
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("ready"))
}
```

Configure in Kubernetes/OpenShift:

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 15
  periodSeconds: 20
readinessProbe:
  httpGet:
    path: /readyz
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 10
```

### Log Aggregation

We typically export JSON logs to a central aggregator (e.g., ELK, Loki, Splunk, etc.). Adjust your `slog` handler or environment variables so the logs fit your aggregation pipeline. This helps unify logs from all Bitiq services.

---

## Testing Strategy

### Unit Testing

All business logic must be covered by unit tests, with at least 80% code coverage. We often enforce coverage thresholds in CI via `golangci-lint` or additional Tekton tasks.

```go
func TestProcessOrder(t *testing.T) {
    tests := []struct {
        name        string
        orderID     string
        paymentAmount float64
        mockSetup   func(*mocks.MockRepository)
        wantErr     bool
        errType     error
    }{
        {
            name:    "valid order",
            orderID: "order123",
            paymentAmount: 100.0,
            mockSetup: func(r *mocks.MockRepository) {
                r.EXPECT().FindOrder(gomock.Any(), "order123").Return(&models.Order{
                    ID: "order123", Amount: 100.0, Status: models.OrderStatusPending,
                }, nil)
                r.EXPECT().UpdateOrder(gomock.Any(), gomock.Any()).Return(nil)
            },
            wantErr: false,
        },
        {
            name:    "order not found",
            orderID: "invalid",
            paymentAmount: 100.0,
            mockSetup: func(r *mocks.MockRepository) {
                r.EXPECT().FindOrder(gomock.Any(), "invalid").Return(nil, ErrOrderNotFound)
            },
            wantErr: true,
            errType: ErrOrderNotFound,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            ctrl := gomock.NewController(t)
            defer ctrl.Finish()

            mockRepo := mocks.NewMockRepository(ctrl)
            tt.mockSetup(mockRepo)

            service := NewOrderService(mockRepo)
            err := service.ProcessOrder(context.Background(), tt.orderID, tt.paymentAmount)

            if tt.wantErr {
                require.Error(t, err)
                if tt.errType != nil {
                    assert.ErrorIs(t, err, tt.errType)
                }
            } else {
                require.NoError(t, err)
            }
        })
    }
}
```

### Integration Testing

Integration tests verify that components work together. Use a real or containerized database (e.g., [testcontainers-go](https://github.com/testcontainers/testcontainers-go)):

```go
// +build integration

package integration

import (
    "testing"
    "github.com/stretchr/testify/require"
    // ...
)

func TestSearchIntegration(t *testing.T) {
    // Spin up ephemeral Couchbase via testcontainers-go, or connect to a dev environment
    // ...
    
    // Create repository, service, etc.
    // ...
    results, err := svc.Search(context.Background(), "test query", 1, 10)
    require.NoError(t, err)
    require.NotEmpty(t, results)
}
```

### Load and Performance Testing

For critical services, add performance or load tests:

```go
// +build performance

package performance

import (
    "testing"
    "time"
    "github.com/stretchr/testify/require"
)

func BenchmarkSearch(b *testing.B) {
    // Setup service...
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _, err := svc.Search(context.Background(), "test query", 1, 10)
        require.NoError(b, err)
    }
}
```

### E2E (End-to-End) Testing

When multiple microservices interact, consider E2E flows:
1. Start all services in a local environment (e.g., Docker Compose or a local K8s cluster).  
2. Run a test that triggers the entire user flow—like ingesting Nostr events, querying them, and validating results.  

E2E ensures cross-service logic remains correct.

---

## Version Control and Contribution Workflow

### Semantic Versioning

We strictly follow [Semantic Versioning 2.0.0](https://semver.org/):
- **MAJOR**: Incompatible API changes  
- **MINOR**: Backward-compatible features  
- **PATCH**: Backward-compatible bug fixes

### Conventional Commits

All commits must follow [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/):

```
<type>[optional scope]: <description>
[optional body]
[optional footer(s)]
```

Common types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`.

**Breaking changes**: add `BREAKING CHANGE:` in the footer or use `!` after the type/scope.

### Automated CHANGELOG Generation

One key benefit of Conventional Commits + SemVer is **automatic CHANGELOG** creation. Tools like `git-chglog` parse Git history and produce a structured CHANGELOG for each release.

1. Refer to issue/PR numbers in commit messages (`Fixes #123`) for traceability.  
2. Let your CI pipeline or release script generate the CHANGELOG.  
3. Keep the CHANGELOG in source control so it’s always up to date.

### Git Workflow

We use a GitHub Flow-inspired model:
1. **Branches**: 
   - `main`: Latest stable, released code  
   - `develop`: Integration branch for new features  
   - Feature/fix branches from `develop`  
2. **Branch Naming**:
   - `feat/awesome-feature`
   - `fix/some-bug`
   - `docs/update-readme`
3. **Pull Requests**:
   - Commit changes using Conventional Commits  
   - Submit a PR to `develop`  
   - Get code review + pass CI  
   - Squash merge with a conventional commit message  
4. **Release**:
   - Merge `develop` into `main`  
   - Tag release version  
   - CI/CD pipeline updates GitOps repo

---

## CI/CD and GitOps

### Continuous Integration with Tekton

We use Tekton pipelines on OpenShift for CI:

```yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: nostr-query-pipeline
spec:
  params:
    - name: git-url
      type: string
    - name: git-revision
      type: string
    - name: image-name
      type: string
  workspaces:
    - name: shared-workspace
  tasks:
    - name: fetch-repository
      taskRef:
        name: git-clone
      params:
        - name: url
          value: $(params.git-url)
        - name: revision
          value: $(params.git-revision)
      workspaces:
        - name: output
          workspace: shared-workspace
    
    - name: lint
      taskRef:
        name: golangci-lint
      runAfter:
        - fetch-repository
      workspaces:
        - name: source
          workspace: shared-workspace
    
    - name: run-tests
      taskRef:
        name: go-test
      runAfter:
        - fetch-repository
      params:
        - name: package
          value: ./...
        - name: flags
          value: -race -coverprofile=coverage.out
      workspaces:
        - name: source
          workspace: shared-workspace
    
    - name: build-image
      taskRef:
        name: buildah
      runAfter:
        - lint
        - run-tests
      params:
        - name: IMAGE
          value: $(params.image-name)
      workspaces:
        - name: source
          workspace: shared-workspace
    
    - name: update-deployment
      taskRef:
        name: update-gitops-repository
      runAfter:
        - build-image
      params:
        - name: image-name
          value: $(params.image-name)
```

### Continuous Deployment with OpenShift GitOps (Argo CD)

We manage deployments through GitOps with Argo CD:
1. The desired state (K8s manifests) is stored in a Git repository.  
2. Argo CD continuously reconciles the cluster to match Git.  
3. To deploy a new version, update the image tag in Git, and Argo CD applies the change.  
4. Rollbacks are as simple as reverting a Git commit.

---

## Documentation Standards

### Code Comments

Every exported identifier must have a doc comment:

```go
// OrderService handles business logic for order processing.
type OrderService struct {
    repo   Repository
    logger *slog.Logger
    config *Config
}

// ProcessOrder handles end-to-end order processing, including
// validation, payment, and status updates.
func (s *OrderService) ProcessOrder(ctx context.Context, orderID string) error {
    // ...
}
```

### README Structure

Each service’s `README.md` should cover:

1. **Overview**: What the service does.  
2. **Architecture**: Interactions with other services.  
3. **Development Setup**: Local build/test instructions.  
4. **API Documentation**: Summaries of exposed endpoints or gRPC methods.  
5. **Configuration**: Required environment variables.  
6. **Testing**: How to run unit/integration tests.  
7. **Deployment**: Any notes on container images, resource usage, etc.  
8. **Contributing**: Guidelines for new contributors.

### Architecture Decision Records (ADRs)

We use [ADRs](https://adr.github.io/) to document significant architectural decisions:
1. Store them in `/docs/adr/` within each repo **or** a central repo if they affect multiple services.  
2. Use a numbering scheme: `0001-use-couchbase.md`, `0002-adopt-grpc.md`, etc.  
3. Follow a standard ADR template (Context, Decision, Consequences, Alternatives, References).  

This ensures we have a history of *why* certain decisions were made.

### API Documentation

For gRPC services, add doc comments in `.proto` definitions. For REST, maintain an OpenAPI 3.0 spec. Keep them **in sync** with code using generation tools (e.g., `oapi-codegen`, `protoc-gen-doc`).

---

## Security Guidelines

### Authentication and Authorization

1. Use JWT for user authentication if needed.  
2. Implement role-based access control (RBAC) for more complex requirements.  
3. Apply the principle of least privilege for each service.  
4. Use mTLS for internal service-to-service calls where possible.

### Input Validation

Validate incoming data from external clients:

```go
func validateSearchRequest(req *pb.SearchRequest) error {
    if req == nil {
        return errors.New("request cannot be nil")
    }
    if req.Page < 1 {
        return errors.New("page must be >= 1")
    }
    if req.PageSize < 1 || req.PageSize > 100 {
        return errors.New("page_size must be between 1 and 100")
    }
    // ...
    return nil
}
```

### Secrets Management

1. **Never** hardcode secrets in source code.  
2. Store secrets in Kubernetes Secrets or equivalent.  
3. Mount secrets as environment variables or files.  
4. Use tools like SOPS to encrypt secrets in Git if needed.

### Dependency Management & Scanning

1. Regularly scan for vulnerabilities (`govulncheck`, Trivy, Grype, etc.).  
2. Keep dependencies up to date, focusing on security patches.  
3. Generate an SBOM (Software Bill of Materials) with tools like [Syft](https://github.com/anchore/syft) if required by your security posture.

### Container Security

1. Use minimal base images (e.g., `distroless`).  
2. Run as a non-root user; set pod security contexts to disallow privilege escalation.  
3. Scan container images for known vulnerabilities before pushing them to the registry.

Example Dockerfile:

```dockerfile
# Build stage
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o service ./cmd/service

# Final stage
FROM gcr.io/distroless/static-debian11
WORKDIR /app
COPY --from=builder /app/service /app/service
USER nonroot:nonroot
EXPOSE 8080 9090
ENTRYPOINT ["/app/service"]
```

---

## Local Development and Concurrency

### Local Dev Environment

1. **Docker Compose / KinD / Minikube**:  
   - If you need to spin up Couchbase, a Nostr relay, or other dependencies, use a local container-based environment.  
   - Provide sample `docker-compose.yml` or dev scripts that mirror the production dependencies (e.g., Couchbase, Redis, etc.).  

2. **Environment Variables**:  
   - Load them via a `.env` file or pass directly into your `make run` / `make dev-setup`.  
   - Avoid committing `.env` files with secrets to source control—use `.env.example` instead.

### Concurrency and Goroutine Best Practices

1. **Avoid Goroutine Leaks**  
   - Always ensure goroutines have a way to exit (cancellation channels, context timeouts).  
2. **Worker Pools**  
   - If your service spawns multiple goroutines for processing, consider a pool or concurrency limiter to avoid resource exhaustion.  
3. **Channels and sync**  
   - Use channels carefully, and prefer simple concurrency patterns (`sync.WaitGroup`, contexts) for straightforward tasks.  
4. **Testing**  
   - For concurrency-sensitive code, write targeted tests to detect race conditions.  
   - Use `-race` in `go test` to catch data races early.

---

## Appendix and References

- **FOSS** definition: [Free and Open Source Software](https://en.wikipedia.org/wiki/Free_and_open-source_software)  
- **Nostr**: [Nostr Protocol on GitHub](https://github.com/nostr-protocol)  
- [Effective Go](https://go.dev/doc/effective_go)  
- [Go Modules Reference](https://go.dev/ref/mod)  
- [Semantic Versioning 2.0.0](https://semver.org/)  
- [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)  
- [Standard Go Project Layout](https://github.com/golang-standards/project-layout)  
- [`golangci-lint`](https://golangci-lint.run/)  
- [`slog` documentation (Go stdlib)](https://pkg.go.dev/log/slog)  
- [OpenTelemetry Go Documentation](https://opentelemetry.io/docs/instrumentation/go/)  
- [gRPC Documentation](https://grpc.io/docs/)  
- [Protocol Buffers Language Guide (proto3)](https://developers.google.com/protocol-buffers/docs/proto3)  
- [gRPC-Gateway](https://github.com/grpc-ecosystem/grpc-gateway)  
- [OpenShift Documentation](https://docs.openshift.com/)  
- [`testify` library](https://github.com/stretchr/testify)  
- [`govulncheck`](https://go.dev/vuln/)  
- [OpenAPI Specification](https://spec.openapis.org/oas/v3.1.0)  
- [testcontainers-go](https://github.com/testcontainers/testcontainers-go) for integration testing  
- [Syft](https://github.com/anchore/syft) and [Trivy](https://aquasecurity.github.io/trivy/) for container scanning  

---

This document serves as the **definitive guide** for Bitiq Golang microservice development. It will evolve as our practices and technologies advance. All contributors should follow these guidelines to ensure consistency and quality across our services.

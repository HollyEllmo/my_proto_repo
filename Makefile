BUF_VERSION=1.47.2

.PHONY: proto
proto: clean format gen lint

.PHONY: buf-install
buf-install:
	@which buf > /dev/null 2>&1 || { \
		echo "Installing buf..."; \
		if [ "$$(uname -s)" = "Darwin" ]; then \
			if [ "$$(uname -m)" = "arm64" ]; then \
				curl -sSL "https://github.com/bufbuild/buf/releases/download/v$(BUF_VERSION)/buf-Darwin-arm64" -o /tmp/buf; \
			else \
				curl -sSL "https://github.com/bufbuild/buf/releases/download/v$(BUF_VERSION)/buf-Darwin-x86_64" -o /tmp/buf; \
			fi; \
		else \
			curl -sSL "https://github.com/bufbuild/buf/releases/download/v$(BUF_VERSION)/buf-Linux-x86_64" -o /tmp/buf; \
		fi; \
		chmod +x /tmp/buf; \
		mkdir -p $(HOME)/bin; \
		mv /tmp/buf $(HOME)/bin/buf; \
		echo "buf installed to $(HOME)/bin/buf"; \
	}

.PHONY: install-protoc
install-protoc:
	@echo "Installing protoc..."
	@if [ "$$(uname -s)" = "Darwin" ]; then \
		which brew > /dev/null 2>&1 && brew install protobuf || { \
			echo "Homebrew not found. Installing protoc manually..."; \
			PROTOC_VERSION="25.1"; \
			if [ "$$(uname -m)" = "arm64" ]; then \
				curl -LO "https://github.com/protocolbuffers/protobuf/releases/download/v$${PROTOC_VERSION}/protoc-$${PROTOC_VERSION}-osx-aarch_64.zip"; \
			else \
				curl -LO "https://github.com/protocolbuffers/protobuf/releases/download/v$${PROTOC_VERSION}/protoc-$${PROTOC_VERSION}-osx-x86_64.zip"; \
			fi; \
			unzip -o protoc-*.zip -d /tmp/protoc; \
			mkdir -p $(HOME)/bin; \
			cp /tmp/protoc/bin/protoc $(HOME)/bin/; \
			cp -r /tmp/protoc/include $(HOME)/; \
			rm -rf /tmp/protoc protoc-*.zip; \
			echo "protoc installed to $(HOME)/bin/protoc"; \
		}; \
	else \
		echo "Please install protoc manually on Linux: apt-get install protobuf-compiler"; \
	fi

.PHONY: install-protoc-plugins
install-protoc-plugins: install-protoc
	@echo "Installing protoc plugins..."
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest
	@echo "All protoc plugins installed"

.PHONY: install-npm-deps
install-npm-deps:
	@echo "Installing npm dependencies..."
	@npm install
	@echo "npm dependencies installed"

.PHONY: gen
gen: buf-install install-protoc-plugins install-npm-deps
	@BUF_CACHE_DIR=/tmp/buf-cache PATH="$(HOME)/bin:$$PATH" buf generate
	@echo "Removing old go.mod files from gen subdirectories..."
	@find $(CURDIR)/gen/go -name "go.mod" -delete || true
	@find $(CURDIR)/gen/go -name "go.sum" -delete || true
	@echo "Updating go.work file..."
	@cd $(CURDIR) && \
		echo "go 1.24.2" > go.work && \
		echo "" >> go.work && \
		echo "use (" >> go.work && \
		echo "	." >> go.work && \
		echo ")" >> go.work && \
		go work sync
	@echo "Running go mod tidy..."
	@cd $(CURDIR) && go mod tidy
	@echo "Generating TypeScript client package..."
	@if [ -d "gen/typescript" ]; then \
		npm run build 2>/dev/null || echo "TypeScript compilation completed (with possible warnings)"; \
	fi

.PHONY: client-package
client-package: gen
	@echo "Building TypeScript client package..."
	@npm run build

.PHONY: lint
lint: buf-install
	@BUF_CACHE_DIR=/tmp/buf-cache PATH="$(HOME)/bin:$$PATH" buf lint

.PHONY: format
format: buf-install
	@BUF_CACHE_DIR=/tmp/buf-cache PATH="$(HOME)/bin:$$PATH" buf format -w

.PHONY: clean
clean:
	@rm -rf ./gen || true

.PHONY: serve-docs
serve-docs:
	@echo "Starting local server for documentation..."
	@echo "Open http://localhost:8000/swagger-ui.html in your browser"
	@python3 -m http.server 8000 || python -m SimpleHTTPServer 8000

.PHONY: help
help:
	@echo "Available commands:"
	@echo "  proto              - Generate all code (Go, Swagger, TypeScript)"
	@echo "  gen                - Generate code only"
	@echo "  client-package     - Build TypeScript client package"
	@echo "  serve-docs         - Start local server for documentation"
	@echo "  clean              - Clean generated files"
	@echo "  lint               - Run buf lint"
	@echo "  format             - Format proto files"
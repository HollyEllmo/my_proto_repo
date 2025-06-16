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

.PHONY: gen
gen: buf-install
	@BUF_CACHE_DIR=/tmp/buf-cache PATH="$(HOME)/bin:$$PATH" buf generate
	@for dir in $(CURDIR)/gen/go/*/; do \
		cd $$dir && \
		go mod init && go mod tidy; \
	done

.PHONY: lint
lint: buf-install
	@BUF_CACHE_DIR=/tmp/buf-cache PATH="$(HOME)/bin:$$PATH" buf lint

.PHONY: format
format: buf-install
	@BUF_CACHE_DIR=/tmp/buf-cache PATH="$(HOME)/bin:$$PATH" buf format -w

.PHONY: clean
clean:
	@rm -rf ./gen || true
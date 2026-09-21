# the first target is the default, so just run help
help: ## This message
	@echo "===================="
	@echo " Available Commands"
	@echo "===================="
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

TEST_TARGET ?= tests
uv_run ?= uv run

default: help

###########
##@ General
all: lint cov wheel ## Complete cycle: lint/test everything

clean: ## Remove build/test artifacts
	rm -rf `find . -name __pycache__`
	rm -rf `find . -name .pytest_cache`
	rm -rf `find . -name .ruff_cache`
	rm -rf `find . -name .coverage`
	rm -rf `find . -name htmlcov`
	rm -rf `find . -name dist`

###########
##@ Build
build: wheel
wheel: ## Build the wheel file
	uv build

prereq: install
install: ## Install package(s) and development tools
	uv sync

###########
##@ Lint
lint: ## Check code formatting
	$(uv_run) ruff check

delint: ## Fix formatting issues
	$(uv_run) ruff check --fix

###########
##@ Test
test: ## Run unit tests (use TEST_TARGET to scope)
	$(uv_run) pytest -v $(TEST_TARGET)

cov: ## Run unit tests with code coverage measurments (use TEST_TARGET to scope)
	$(uv_run) coverage run -m pytest -v $(TEST_TARGET)
	$(uv_run) coverage report -m
	$(uv_run) coverage html

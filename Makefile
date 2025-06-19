.PHONY: test test-unit test-format format lint install-deps help

# Default target
help:
	@echo "Available commands:"
	@echo "  make test          - Run all tests"
	@echo "  make test-unit     - Run unit tests"
	@echo "  make test-format   - Check code formatting"
	@echo "  make format        - Format code"
	@echo "  make lint          - Run linter"
	@echo "  make install-deps  - Install dependencies"

# Run all tests
test: test-unit test-format

# Run unit tests
test-unit:
	@echo "Running unit tests..."
	@nvim --headless -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal_init.vim'}" +q

# Check code formatting
test-format:
	@echo "Checking code formatting..."
	@stylua --check .

# Format code
format:
	@echo "Formatting code..."
	@stylua .

# Run linter
lint:
	@echo "Running linter..."
	@luacheck . --exclude-files tests/

# Install dependencies
install-deps:
	@echo "Installing dependencies..."
	@echo "Please ensure you have the following installed:"
	@echo "  - Neovim >= 0.7.0"
	@echo "  - plenary.nvim (for testing)"
	@echo "  - stylua (for formatting)"
	@echo "  - luacheck (for linting)"
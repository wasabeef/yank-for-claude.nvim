# Contributing to yank-for-claude.nvim

Thank you for your interest in contributing to yank-for-claude.nvim! This document provides guidelines and instructions for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/yank-for-claude.nvim.git`
3. Create a new branch: `git checkout -b feature/your-feature-name`

## Development Setup

### Prerequisites

- Neovim >= 0.7.0
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) (for testing)
- [StyLua](https://github.com/JohnnyMorganz/StyLua) (for code formatting)
- [luacheck](https://github.com/mpeterv/luacheck) (optional, for linting)

Install dependencies:

```bash
# Install test dependencies
bun run install-test-deps
# or
./scripts/install-test-deps.sh

# Install development tools (macOS)
brew install stylua
brew install luacheck

# Install development tools (Linux)
# For StyLua: Download from GitHub releases
# For luacheck:
sudo apt install luarocks
sudo luarocks install luacheck
```

### Running Tests

```bash
# Using bun
bun run test          # Run all tests
bun run test:unit     # Run unit tests
bun run test:format   # Check code formatting

# Using make
make test         # Run all tests
make test-unit    # Run unit tests
make test-format  # Check code formatting

# Or directly
nvim --headless -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal_init.vim'}" +q
nvim --headless -c "PlenaryBustedFile tests/yank-for-claude_spec.lua {minimal_init = 'tests/minimal_init.vim'}" +q
```

### Code Formatting

We use StyLua for consistent code formatting. Before submitting a PR:

```bash
# Using bun
bun run format        # Format all Lua files
bun run test:format   # Check formatting without modifying files

# Using make
make format       # Format all Lua files
make test-format  # Check formatting without modifying files

# Or directly
stylua .          # Format all Lua files
stylua --check .  # Check formatting without modifying files
```

## Contribution Guidelines

### Code Style

- Follow existing code patterns and conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and small

### Pull Request Process

1. **Create a focused PR**: Each PR should address a single issue or feature
2. **Write clear commit messages**: Use conventional commit format when possible
3. **Update documentation**: Include any necessary documentation updates
4. **Add tests**: New features should include tests
5. **Pass CI checks**: Ensure all tests and formatting checks pass

### Commit Message Format

```
<type>: <description>

[optional body]

[optional footer]
```

Types:

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Test additions or changes
- `chore`: Maintenance tasks

Example:

```
feat: add support for visual block mode

Add handling for visual block mode selections to properly
calculate line ranges when yanking rectangular selections.
```

## Testing Guidelines

- Write tests for new features
- Update existing tests when modifying functionality
- Use descriptive test names that explain what is being tested
- Test edge cases and error conditions

## Documentation

- Update README.md for user-facing changes
- Update help documentation (doc/yank-for-claude.txt) for new commands or options
- Include inline documentation for complex functions

## Reporting Issues

When reporting issues, please include:

1. Neovim version (`nvim --version`)
2. Steps to reproduce the issue
3. Expected behavior
4. Actual behavior
5. Any error messages
6. Minimal configuration to reproduce

## Feature Requests

Feature requests are welcome! Please:

1. Check existing issues to avoid duplicates
2. Clearly describe the feature and its use case
3. Explain why this feature would be valuable

## Questions?

If you have questions about contributing, feel free to:

- Open an issue with the "question" label
- Start a discussion in the GitHub Discussions tab

Thank you for contributing to yank-for-claude.nvim!

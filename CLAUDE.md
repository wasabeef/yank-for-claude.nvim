# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Neovim plugin called `yank-for-claude.nvim` that helps users yank code references in Claude AI's preferred format (`@filename#L10-20`).

**Current Status**: The project is fully implemented with a simplified API. Stack functionality has been removed to focus on core features.

## Development Commands

### Testing
```bash
# Run all tests (using bun)
bun test

# Run tests directly with Neovim
nvim --headless -u tests/minimal_init.vim -c "PlenaryBustedDirectory tests/" +qa

# Run a single test file
nvim --headless -u tests/minimal_init.vim -c "PlenaryBustedFile tests/yank-for-claude_spec.lua" +qa
```

### Code Formatting & Linting
```bash
# Format code
bun format
# or
stylua .

# Check formatting
stylua --check .

# Lint code
luacheck .
```

### Git Hooks (Lefthook)
```bash
# Install git hooks
bun prepare
# or
lefthook install

# The following hooks are configured:
# - pre-commit: format check, lint, and tests
# - pre-push: tests
# - commit-msg: conventional commit format check
```

## Architecture

### Core Components

1. **Main Module** (`lua/yank-for-claude/init.lua`):
   - Provides commands: `YankForClaude` and `YankForClaudeWithContent`
   - Contains core logic for formatting references
   - Handles command arguments (line1, line2) for range support
   - Exports direct mapping functions from yank.lua

2. **Config Module** (`lua/yank-for-claude/config.lua`):
   - Simple configuration management
   - Only contains `notify` option (boolean)

3. **Yank Module** (`lua/yank-for-claude/yank.lua`):
   - Direct functions for key mappings
   - Each function first performs normal yank to trigger TextYankPost
   - Then replaces clipboard with formatted reference
   - Functions: `yank_visual()`, `yank_line()`, `yank_visual_with_content()`, `yank_line_with_content()`

### Key Design Decisions

1. **TextYankPost Compatibility**: 
   - The yank.lua functions perform normal yank operations first
   - This ensures TextYankPost autocmds are triggered for highlight integration
   - Clipboard content is then replaced with the formatted reference

2. **Dual API**: 
   - Commands for traditional Vim users (`:YankForClaude`)
   - Direct functions for modern key mapping (`require('yank-for-claude').yank_visual()`)

3. **No Stack Feature**: 
   - Simplified from original design
   - Focus on core functionality only

### Testing Approach

- Tests run locally with full clipboard support
- CI only runs format and lint checks (no tests due to clipboard limitations)
- Test structure includes:
  - Command function tests
  - Direct mapping function tests
  - TextYankPost trigger verification
  - Configuration tests

### Important Notes

- The plugin requires `setup()` to be called before using direct mapping functions
- Both `+` and `*` registers are set for maximum compatibility
- File paths are relative to current working directory
- Empty buffers are handled gracefully with warning notifications
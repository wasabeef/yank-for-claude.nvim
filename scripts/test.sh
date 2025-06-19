#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Running yank-for-claude.nvim tests..."
echo "======================================"

# Check if plenary.nvim is installed
if [ ! -d "$HOME/.local/share/nvim/site/pack/vendor/start/plenary.nvim" ]; then
    echo -e "${RED}Error: plenary.nvim not found${NC}"
    echo "Installing plenary.nvim..."
    mkdir -p ~/.local/share/nvim/site/pack/vendor/start
    git clone --depth 1 https://github.com/nvim-lua/plenary.nvim \
        ~/.local/share/nvim/site/pack/vendor/start/plenary.nvim
fi

# Run tests
nvim --headless -u tests/minimal_init.vim -c "PlenaryBustedDirectory tests/ {sequential = true}" +qa

# Check exit code
if [ $? -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
else
    echo -e "${RED}Some tests failed${NC}"
    exit 1
fi
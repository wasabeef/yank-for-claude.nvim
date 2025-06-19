#!/bin/bash

# Install test dependencies

echo "Installing test dependencies..."

# Install plenary.nvim
if [ ! -d "$HOME/.local/share/nvim/site/pack/vendor/start/plenary.nvim" ]; then
    echo "Installing plenary.nvim..."
    mkdir -p ~/.local/share/nvim/site/pack/vendor/start
    git clone --depth 1 https://github.com/nvim-lua/plenary.nvim \
        ~/.local/share/nvim/site/pack/vendor/start/plenary.nvim
else
    echo "plenary.nvim already installed"
fi

echo "Test dependencies installed!"
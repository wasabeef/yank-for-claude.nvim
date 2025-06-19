-- vim: ft=lua tw=80

stds.nvim = {
  globals = {
    "vim",
  },
}
std = "lua51+nvim"

-- Neovim globals
globals = {
  "vim",
}

-- Allow setting vim.g fields
new_globals = {
  "vim.g.loaded_yank_for_claude",
}

-- Read-only globals
read_globals = {
  "vim",
}

-- Per-file overrides
files["tests/*"] = {
  globals = {
    "describe",
    "it",
    "before_each",
    "after_each",
    "assert",
    -- Mock clipboard globals for CI
    "vim.g.clipboard",
    "vim.g.mock_clipboard_plus",
    "vim.g.mock_clipboard_star",
  },
}

-- Ignore some warnings
ignore = {
  "212", -- Unused argument
  "213", -- Unused loop variable
}

-- Don't report unused self arguments
self = false
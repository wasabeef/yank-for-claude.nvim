# yank-for-claude.nvim

[![Format & Lint](https://github.com/wasabeef/yank-for-claude.nvim/actions/workflows/ci.yml/badge.svg)](https://github.com/wasabeef/yank-for-claude.nvim/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Neovim](https://img.shields.io/badge/Neovim-0.7+-blueviolet.svg?style=flat&logo=Neovim&logoColor=white)](https://neovim.io)

A Neovim plugin that yanks code references in Claude AI's preferred format (`@filename#L10-20`), making it seamless to share code context in conversations.

https://github.com/user-attachments/assets/a5f42615-9639-4b90-b207-c7a8ddaa136b

## ✨ Features

- **Smart Format**: Automatically formats code references as `@file.lua#L10-L20` for multi-line or `@file.lua#L10` for single line
- **Visual Mode Support**: Works naturally with Neovim's visual selection
- **Yank Highlight**: Integrates with existing `TextYankPost` autocmds to show visual feedback
- **Flexible**: Use via commands or direct key mappings
- **Include Code**: Option to include actual code content along with references

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'wasabeef/yank-for-claude.nvim',
  config = function()
    require('yank-for-claude').setup()
  end,
  keys = {
    -- Reference only
    { '<leader>y', function() require('yank-for-claude').yank_visual() end, mode = 'v', desc = 'Yank for Claude' },
    { '<leader>y', function() require('yank-for-claude').yank_line() end, mode = 'n', desc = 'Yank line for Claude' },

    -- Reference + Code
    { '<leader>Y', function() require('yank-for-claude').yank_visual_with_content() end, mode = 'v', desc = 'Yank with content' },
    { '<leader>Y', function() require('yank-for-claude').yank_line_with_content() end, mode = 'n', desc = 'Yank line with content' },
  },
}
```

### Using packer.nvim

```lua
use {
  'wasabeef/yank-for-claude.nvim',
  config = function()
    require('yank-for-claude').setup()
  end
}
```

### Alternative: Using commands

```lua
-- Setup the plugin first
require('yank-for-claude').setup()

-- Map keys to commands
vim.keymap.set('v', '<leader>y', ':YankForClaude<cr>', { desc = 'Yank for Claude' })
vim.keymap.set('v', '<leader>Y', ':YankForClaudeWithContent<cr>', { desc = 'Yank with content' })
```

## 🚀 Usage

### Basic Usage

1. **Visual Mode**: Select code and press your mapped key (e.g., `<leader>y`)
2. **Normal Mode**: Press your mapped key to yank current line reference
3. **Paste** in Claude AI chat - it will recognize the format

### Examples

**Reference only** (`<leader>y`):

```
@src/utils.lua#L45-L67
```

**Reference with code** (`<leader>Y`):

```
@src/utils.lua#L45-L67
function calculateTotal(items)
  local total = 0
  for _, item in ipairs(items) do
    total = total + item.price
  end
  return total
end
```

## ⚙️ Configuration

```lua
require('yank-for-claude').setup({
  -- Show notifications after yanking
  notify = true,
})
```

## 🔧 Commands

| Command                     | Description                             |
| --------------------------- | --------------------------------------- |
| `:YankForClaude`            | Yank code reference in Claude AI format |
| `:YankForClaudeWithContent` | Yank code reference with content        |

All commands support range (work with visual selection).

## 📚 Functions

For direct key mappings, these functions are available:

| Function                     | Mode   | Description                 |
| ---------------------------- | ------ | --------------------------- |
| `yank_visual()`              | Visual | Yank reference only         |
| `yank_visual_with_content()` | Visual | Yank reference + code       |
| `yank_line()`                | Normal | Yank current line reference |
| `yank_line_with_content()`   | Normal | Yank current line + code    |

## 🎯 Tips

- The plugin respects your existing yank highlight settings (`TextYankPost`)
- Works with both `+` and `*` registers for maximum compatibility
- File paths are relative to your current working directory

## 📋 Requirements

- Neovim >= 0.7.0

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

Made with ❤️ to enhance Claude AI conversations

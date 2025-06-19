# API Documentation

## Module: `yank-for-claude`

The main module providing commands and functions for yanking code references.

### Functions

#### `setup(opts)`

Initialize the plugin with custom configuration.

**Parameters:**

- `opts` (table|nil): Configuration options
  - `stack_size` (number): Maximum number of references in stack (default: 50)
  - `include_content` (boolean): Include code content by default (default: false)
  - `notify` (boolean): Show notifications (default: true)
  - `telescope_mappings` (table): Telescope picker key mappings
    - `yank` (string): Key to yank selected reference (default: '<CR>')
    - `delete` (string): Key to delete from stack (default: '<C-d>')

**Example:**

```lua
require('yank-for-claude').setup({
  stack_size = 100,
  notify = false,
  include_content = true,
})
```

#### `yank(args)`

Yank code reference for selected lines.

**Parameters:**

- `args` (table|nil): Command arguments
  - `args` (string): Optional 'content' to include code
  - `line1` (number): Start line (from command range)
  - `line2` (number): End line (from command range)

#### `yank_add(args)`

Yank code reference and add to stack.

**Parameters:**

- Same as `yank(args)`

#### `yank_stack()`

Open Telescope picker to browse and manage the reference stack.
Requires telescope.nvim to be installed.

#### `yank_clear()`

Clear all references from the stack.

#### `yank_visual()`

Direct function for visual mode key mapping. Yanks reference of selected lines.

**Example:**

```lua
vim.keymap.set('v', '<leader>y', require('yank-for-claude').yank_visual)
```

#### `yank_line()`

Direct function for normal mode key mapping. Yanks reference of current line.

**Example:**

```lua
vim.keymap.set('n', '<leader>y', require('yank-for-claude').yank_line)
```

## Module: `yank-for-claude.config`

Configuration management module.

### Functions

#### `setup(opts)`

Setup configuration with user options.

#### `get()`

Get current configuration.

**Returns:**

- table: Current configuration

#### `add_to_stack(reference)`

Add a reference to the stack.

**Parameters:**

- `reference` (string): The code reference to add

#### `get_stack()`

Get the current stack of references.

**Returns:**

- table[]: Array of reference entries with `reference` and `timestamp`

#### `remove_from_stack(reference)`

Remove a reference from the stack.

**Parameters:**

- `reference` (string): The reference to remove

#### `clear_stack()`

Clear all references from the stack.

## Commands

### `:YankForClaude [content]`

Yank code reference for selected lines or current line.

**Arguments:**

- `content` (optional): Include actual code content with reference

**Example:**

```vim
" Yank reference only
:'<,'>YankForClaude

" Yank with content
:'<,'>YankForClaude content
```

### `:YankForClaudeAdd [content]`

Same as `:YankForClaude` but also adds the reference to the stack.

### `:YankForClaudeStack`

Open Telescope picker to browse and manage the reference stack.

**Mappings in picker:**

- `<CR>`: Yank selected reference to clipboard
- `<C-d>`: Delete selected reference from stack

### `:YankForClaudeClear`

Clear all references from the stack.

## Reference Format

The plugin formats references in Claude AI's preferred format:

- Single line: `@filename#L10`
- Multiple lines: `@filename#L10-L20`

File paths are relative to the current working directory.

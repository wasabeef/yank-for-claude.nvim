--- Autocmd module for automatic yank transformation
--- @module 'yank-for-claude.autocmd'
--- Note: This module is not currently used but kept for potential future features
local M = {}

--- Transform yanked text to Claude AI reference format
--- @private
local function transform_to_claude_format()
  -- Get the yanked text
  local yanked = vim.fn.getreg('"')
  if not yanked or yanked == '' then
    return
  end

  -- Get file path
  local filepath = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  if filepath == '' then
    return
  end

  -- Get the range of yanked text
  local start_line = vim.fn.getpos("'[")[2]
  local end_line = vim.fn.getpos("']")[2]

  -- Format reference
  local reference
  if start_line == end_line then
    reference = string.format('@%s#L%d', filepath, start_line)
  else
    reference = string.format('@%s#L%d-L%d', filepath, start_line, end_line)
  end

  -- Set to clipboard
  vim.fn.setreg('+', reference)
  vim.fn.setreg('*', reference)

  -- Show notification
  vim.notify('Copied: ' .. reference, vim.log.levels.INFO, { title = 'Yank for Claude' })
end

--- Setup autocmd for automatic yank transformation
--- Creates an autocommand that triggers on TextYankPost events
function M.setup()
  -- Create an autocommand group
  local group = vim.api.nvim_create_augroup('YankForClaude', { clear = true })

  -- Set up the autocmd for yank operations
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = group,
    callback = function()
      -- Only trigger for visual mode yanks to clipboard
      local event = vim.v.event
      if event.operator == 'y' and event.regname == '+' then
        transform_to_claude_format()
      end
    end,
  })
end

return M

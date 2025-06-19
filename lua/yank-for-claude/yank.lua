--- Direct yank functions for key mappings
--- @module 'yank-for-claude.yank'
local M = {}

--- Yank code reference in visual mode
--- Performs a normal yank first to trigger TextYankPost,
--- then replaces the clipboard content with the formatted reference
function M.yank_visual()
  -- First, perform normal yank to clipboard
  vim.cmd('normal! "+y')

  -- Get file path
  local filepath = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  if filepath == '' then
    return
  end

  -- Get the visual selection range
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]

  -- Format reference
  local reference
  if start_line == end_line then
    reference = string.format('@%s#L%d', filepath, start_line)
  else
    reference = string.format('@%s#L%d-L%d', filepath, start_line, end_line)
  end

  -- Replace clipboard content
  vim.fn.setreg('+', reference)
  vim.fn.setreg('*', reference)

  -- Show notification if enabled
  local config = require('yank-for-claude.config')
  if config.get().notify then
    vim.notify('Copied: ' .. reference, vim.log.levels.INFO, { title = 'Yank for Claude' })
  end
end

--- Yank current line reference in normal mode
--- Performs a normal line yank first to trigger TextYankPost,
--- then replaces the clipboard content with the formatted reference
function M.yank_line()
  -- First, yank the current line to trigger TextYankPost
  vim.cmd('normal! yy')

  local filepath = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  if filepath == '' then
    return
  end

  local line = vim.fn.line('.')
  local reference = string.format('@%s#L%d', filepath, line)

  vim.fn.setreg('+', reference)
  vim.fn.setreg('*', reference)

  local config = require('yank-for-claude.config')
  if config.get().notify then
    vim.notify('Copied: ' .. reference, vim.log.levels.INFO, { title = 'Yank for Claude' })
  end
end

--- Yank current line reference with content in normal mode
--- Performs a normal line yank first to trigger TextYankPost,
--- then replaces the clipboard content with the reference and code
function M.yank_line_with_content()
  -- First, yank the current line to trigger TextYankPost
  vim.cmd('normal! yy')

  local filepath = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  if filepath == '' then
    return
  end

  local line = vim.fn.line('.')
  local reference = string.format('@%s#L%d', filepath, line)

  -- Get the actual code content
  local lines = vim.api.nvim_buf_get_lines(0, line - 1, line, false)
  local content = lines[1] or ''
  local text_to_yank = reference .. '\n' .. content

  -- Replace clipboard content
  vim.fn.setreg('+', text_to_yank)
  vim.fn.setreg('*', text_to_yank)

  -- Show notification if enabled
  local config = require('yank-for-claude.config')
  if config.get().notify then
    vim.notify('Copied with content: ' .. reference, vim.log.levels.INFO, { title = 'Yank for Claude' })
  end
end

--- Yank code reference with content in visual mode
--- Performs a normal yank first to trigger TextYankPost,
--- then replaces the clipboard content with the reference and code
function M.yank_visual_with_content()
  -- First, perform normal yank to trigger TextYankPost
  vim.cmd('normal! "+y')

  -- Get file path
  local filepath = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  if filepath == '' then
    return
  end

  -- Get the visual selection range
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]

  -- Format reference
  local reference
  if start_line == end_line then
    reference = string.format('@%s#L%d', filepath, start_line)
  else
    reference = string.format('@%s#L%d-L%d', filepath, start_line, end_line)
  end

  -- Get the actual code content
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local content = table.concat(lines, '\n')
  local text_to_yank = reference .. '\n' .. content

  -- Replace clipboard content
  vim.fn.setreg('+', text_to_yank)
  vim.fn.setreg('*', text_to_yank)

  -- Show notification if enabled
  local config = require('yank-for-claude.config')
  if config.get().notify then
    vim.notify('Copied with content: ' .. reference, vim.log.levels.INFO, { title = 'Yank for Claude' })
  end
end

return M

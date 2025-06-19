--- yank-for-claude.nvim main module
--- @module 'yank-for-claude'
local M = {}
local config = require('yank-for-claude.config')

--- Get the visual selection range from command args or visual marks
--- @param args table|nil Command arguments containing line1 and line2
--- @return number start_line Starting line number
--- @return number end_line Ending line number
--- @private
local function get_visual_selection_range(args)
  -- Use command range if available
  if args and args.line1 and args.line2 then
    return args.line1, args.line2
  end

  -- Get visual selection marks
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]

  -- If marks are not set (no visual selection), use current line
  if start_line == 0 or end_line == 0 then
    local line = vim.fn.line('.')
    return line, line
  end

  return start_line, end_line
end

--- Get the relative filepath of the current buffer
--- @return string filepath Relative path from current working directory
--- @private
local function get_relative_filepath()
  return vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
end

--- Format a code reference in Claude AI's preferred format
--- @param filepath string The file path
--- @param start_line number Starting line number
--- @param end_line number Ending line number
--- @return string reference Formatted reference (e.g., @file.lua#L10-L20)
--- @private
local function format_reference(filepath, start_line, end_line)
  if start_line == end_line then
    return string.format('@%s#L%d', filepath, start_line)
  else
    return string.format('@%s#L%d-L%d', filepath, start_line, end_line)
  end
end

--- Yank a code reference to the clipboard
--- @param include_content boolean Whether to include actual code content
--- @param args table|nil Command arguments
--- @return string|nil reference The yanked reference or nil if failed
--- @private
local function yank_reference(include_content, args)
  local filepath = get_relative_filepath()
  if filepath == '' then
    vim.notify('No file in current buffer', vim.log.levels.WARN, { title = 'Yank for Claude' })
    return
  end

  local start_line, end_line = get_visual_selection_range(args)
  local reference = format_reference(filepath, start_line, end_line)

  local text_to_yank = reference

  if include_content then
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local content = table.concat(lines, '\n')
    text_to_yank = reference .. '\n' .. content
  end

  vim.fn.setreg('+', text_to_yank)
  vim.fn.setreg('*', text_to_yank)

  if config.get().notify then
    vim.notify('Copied: ' .. reference, vim.log.levels.INFO, { title = 'Yank for Claude' })
  end

  return reference
end

--- Yank code reference for selected lines
--- @param args table|nil Command arguments
function M.yank(args)
  yank_reference(false, args)
end

--- Yank code reference with content for selected lines
--- @param args table|nil Command arguments
function M.yank_with_content(args)
  yank_reference(true, args)
end

--- Setup the plugin with user configuration
--- @param opts table|nil Configuration options
--- @field notify boolean Show notifications (default: true)
function M.setup(opts)
  config.setup(opts)

  vim.api.nvim_create_user_command('YankForClaude', function(args)
    M.yank(args)
  end, { range = true, desc = 'Yank code reference in Claude AI format' })

  vim.api.nvim_create_user_command('YankForClaudeWithContent', function(args)
    M.yank_with_content(args)
  end, { range = true, desc = 'Yank code reference with content in Claude AI format' })

  -- Export yank module for direct key mapping
  M.yank_visual = require('yank-for-claude.yank').yank_visual
  M.yank_line = require('yank-for-claude.yank').yank_line
  M.yank_visual_with_content = require('yank-for-claude.yank').yank_visual_with_content
  M.yank_line_with_content = require('yank-for-claude.yank').yank_line_with_content
end

return M

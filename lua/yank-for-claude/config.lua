--- Configuration module for yank-for-claude.nvim
--- @module 'yank-for-claude.config'
local M = {}

--- Default configuration values
--- @type table
local default_config = {
  notify = true,
}

--- Current configuration
--- @type table
local config = vim.deepcopy(default_config)

--- Setup configuration with user options
--- @param opts table|nil User configuration options
--- @field notify boolean Whether to show notifications
function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})
end

--- Get current configuration
--- @return table config Current configuration
function M.get()
  return config
end

return M

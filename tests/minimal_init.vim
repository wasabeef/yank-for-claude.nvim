set rtp+=.
set rtp+=../plenary.nvim
set rtp+=~/.local/share/nvim/site/pack/vendor/start/plenary.nvim

" Load plenary first
runtime! plugin/plenary.vim

" Ensure plenary is loaded
lua << EOF
local ok = pcall(require, 'plenary.busted')
if not ok then
  vim.api.nvim_err_writeln('plenary.nvim not found! Please install it first.')
  vim.api.nvim_err_writeln('Run: bun run install-test-deps')
  vim.cmd('cquit 1')
end
EOF

" Load the plugin
runtime! plugin/yank-for-claude.lua
lua require('yank-for-claude').setup()
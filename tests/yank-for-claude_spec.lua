describe('yank-for-claude', function()
  local yank_for_claude = require('yank-for-claude')
  local config = require('yank-for-claude.config')

  -- Initialize the plugin before all tests
  yank_for_claude.setup({})

  before_each(function()
    vim.fn.setreg('+', '')
    vim.fn.setreg('*', '')
  end)

  describe('command functions', function()
    it('should format single line reference correctly', function()
      vim.cmd('enew')
      vim.fn.setline(1, { 'line 1', 'line 2', 'line 3' })
      vim.cmd('file test1.lua')

      vim.cmd('normal! 2G')
      vim.cmd('normal! V')

      yank_for_claude.yank({})

      local yanked = vim.fn.getreg('+')
      assert.equals('@test1.lua#L2', yanked)
    end)

    it('should format multi-line reference correctly', function()
      vim.cmd('enew')
      vim.fn.setline(1, { 'line 1', 'line 2', 'line 3', 'line 4' })
      vim.cmd('file test2.lua')

      -- Use command range directly
      yank_for_claude.yank({ line1 = 2, line2 = 4 })

      local yanked = vim.fn.getreg('+')
      assert.equals('@test2.lua#L2-L4', yanked)
    end)

    it('should include content when requested', function()
      vim.cmd('enew')
      vim.fn.setline(1, { 'function test()', '  return true', 'end' })
      vim.cmd('file test3.lua')

      yank_for_claude.yank_with_content({ line1 = 1, line2 = 3 })

      local yanked = vim.fn.getreg('+')
      local expected = '@test3.lua#L1-L3\nfunction test()\n  return true\nend'
      assert.equals(expected, yanked)
    end)
  end)

  describe('direct mapping functions', function()
    it('should trigger TextYankPost and then yank reference in visual mode', function()
      vim.cmd('enew')
      vim.fn.setline(1, { 'line 1', 'line 2', 'line 3' })
      vim.cmd('file test4.lua')

      -- Track if TextYankPost was triggered
      local yanked_text = nil
      vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
          yanked_text = vim.v.event.regcontents
        end,
        once = true,
      })

      -- Select lines 2-3
      vim.cmd('normal! 2GV3G')

      -- Call the direct mapping function
      yank_for_claude.yank_visual()

      -- Verify TextYankPost was triggered with correct content
      assert.is_not_nil(yanked_text)
      assert.same({ 'line 2', 'line 3' }, yanked_text)

      -- Verify final clipboard has reference
      local yanked = vim.fn.getreg('+')
      assert.equals('@test4.lua#L2-L3', yanked)
    end)

    it('should trigger TextYankPost for single line', function()
      vim.cmd('enew')
      vim.fn.setline(1, { 'first line', 'second line', 'third line' })
      vim.cmd('file test5.lua')

      -- Track if TextYankPost was triggered
      local yanked_text = nil
      vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
          yanked_text = vim.v.event.regcontents
        end,
        once = true,
      })

      -- Position on line 2
      vim.cmd('normal! 2G')

      -- Call the direct mapping function
      yank_for_claude.yank_line()

      -- Verify TextYankPost was triggered
      assert.is_not_nil(yanked_text)
      assert.same({ 'second line' }, yanked_text)

      -- Verify final clipboard has reference
      local yanked = vim.fn.getreg('+')
      assert.equals('@test5.lua#L2', yanked)
    end)

    it('should include content with visual selection', function()
      vim.cmd('enew')
      vim.fn.setline(1, { 'function hello()', '  print("world")', 'end' })
      vim.cmd('file test6.lua')

      -- Select all lines
      vim.cmd('normal! ggVG')

      -- Call the direct mapping function
      yank_for_claude.yank_visual_with_content()

      local yanked = vim.fn.getreg('+')
      local expected = '@test6.lua#L1-L3\nfunction hello()\n  print("world")\nend'
      assert.equals(expected, yanked)
    end)
  end)

  describe('configuration', function()
    it('should respect notify configuration', function()
      config.setup({
        notify = false,
      })

      vim.cmd('enew')
      vim.fn.setline(1, { 'test line' })
      vim.cmd('file test7.lua')

      vim.cmd('normal! 1G')
      vim.cmd('normal! V')

      yank_for_claude.yank({})

      local yanked = vim.fn.getreg('+')
      assert.equals('@test7.lua#L1', yanked)
    end)
  end)
end)

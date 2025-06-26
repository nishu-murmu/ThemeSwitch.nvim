local config = require("ThemeSwitch.config")
local utils = require("ThemeSwitch.utils")
local M = {}
local buf = nil
local win = nil

function M.close_win()
  if not vim.api.nvim_win_is_valid(win) then
    return
  end
  vim.api.nvim_win_close(win, true)
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
end

function M.toggle_win()
  if win and vim.api.nvim_win_is_valid(win) then
    M.close_win()
    return
  end

  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true)
  else
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {}) -- clear content
  end

  win = utils.create_win(buf)
  vim.api.nvim_set_option_value("winhighlight", "NormalFloat:NormalFloat", { win = win })
  vim.cmd("highlight NormalFloat ctermbg=NONE guibg=NONE")
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = buf,
    callback = function()
      local colorscheme = vim.api.nvim_get_current_line()
      vim.cmd("colorscheme " .. colorscheme)
    end
  })
  vim.on_key(function(key)
    if key == '\r' or key == '\n' then
      M.close_win()
    end
  end)
end

vim.api.nvim_set_keymap("n", config.keymap, "<cmd>ThemeSwitch<CR>", { noremap = true })
vim.api.nvim_create_user_command("ThemeSwitch", function()
  M.toggle_win()
end, {})

function M.setup(user_config)
  if user_config then
    config = vim.tbl_deep_extend("force", config, user_config)
  end
  if config.keymap then
    vim.api.nvim_del_keymap("n", config.keymap)
    vim.api.nvim_set_keymap("n", config.keymap, "<cmd>ThemeSwitch<CR>", { noremap = true })
  end
end

return M

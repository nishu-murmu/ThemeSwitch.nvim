local M = {}
local buf = nil
local win = nil

local function get_all_colorscheme()
  local colorscheme = {}
  local runtime_paths = vim.api.nvim_list_runtime_paths()
  for _, path in ipairs(runtime_paths) do
    local color_dir = path .. package.config:sub(1, 1) .. "colors"
    if vim.fn.isdirectory(color_dir) == 1 then
      for _, file in ipairs(vim.fn.readdir(color_dir)) do
        if file:match("%.vim$") or file:match("%.lua$") then
          table.insert(colorscheme, file:sub(1, #file - 4))
        end
      end
    end
  end
  return colorscheme
end

local function close_win()
  if not vim.api.nvim_win_is_valid(win) then
    return
  end
  vim.api.nvim_win_close(win, true)
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
end

local function toggle_win()
  if win and vim.api.nvim_win_is_valid(win) then
    close_win()
    return
  end

  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true)
  else
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {}) -- clear content
  end

  local width = vim.o.columns
  local height = vim.o.lines
  local win_width = 60
  local win_height = 10
  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, get_all_colorscheme())

  win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = "rounded",
    style = "minimal",
    title = ' [ Select ColorScheme ] ',
    title_pos = 'center',
    focusable = true,
  })

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
      close_win()
    end
  end)
end

vim.api.nvim_set_keymap("n", "<leader>c", "<cmd>ThemeSwitch<CR>", { noremap = true })
function M.setup()
  vim.api.nvim_create_user_command("ThemeSwitch", function()
    toggle_win()
  end, {})
end

return M

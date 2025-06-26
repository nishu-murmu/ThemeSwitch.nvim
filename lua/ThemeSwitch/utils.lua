local M = {}

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

function M.create_win(buf)
  local width = vim.o.columns
  local height = vim.o.lines
  local win_width = 60
  local win_height = 10
  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, get_all_colorscheme())
  local win = vim.api.nvim_open_win(buf, true, {
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
  return win
end

return M

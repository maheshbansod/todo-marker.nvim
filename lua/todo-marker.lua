local M = {}

local could_contain_todo = function()
  if vim.bo.filetype == "markdown" then
    return true
  end
  local current_buf_id = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(current_buf_id)

  if string.lower(filename):match("todo$") then
    return true
  end
  return false
end


-- the done marker - setting the default done marker
-- will be overriden by the setup
local done_marker = "x"

--- Setup the plugin
---@param opts {
--- done_marker: string|nil,
--- no_autodetect_marker: boolean,
---}|nil
M.setup = function(opts)
  if opts and opts.done_marker then
    done_marker = opts.done_marker
  end
  local should_autodected_marker = true
  if opts and opts.no_autodetect_marker then
    should_autodected_marker = false
  end
  if should_autodected_marker and could_contain_todo() then
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for _, line in ipairs(lines) do
      local marker = string.match(line, "^%s*- %[([xX])%] ")
      if marker then
        done_marker = marker
        break
      end
    end
  end
end

M.toggle_todo_item = function()
  -- get current line from buffer that the cursor is on
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line_num = row - 1
  local current_line = vim.api.nvim_buf_get_lines(0, current_line_num, current_line_num + 1, false)[1]

  -- check if the line begins with something like `\s*- \[[ x]\] `
  local todo_pattern = "^%s*-%s*%[[ xX]?%]"
  local start_match, _ = current_line:find(todo_pattern)

  if start_match then
    -- if it does, then replace the x with whitespace or space with x

    local bracket_start_idx = current_line:find("%[", start_match)
    local bracket_close_idx = current_line:find("%]", bracket_start_idx)
    local content_len = bracket_close_idx - bracket_start_idx - 1
    if bracket_start_idx and bracket_close_idx and (content_len == 0 or content_len == 1) then
      local char_inside = current_line:sub(bracket_start_idx + 1, bracket_close_idx - 1)
      local new_char

      if char_inside:match("[xX]") then
        new_char = " "
      else
        new_char = done_marker
      end

      local new_line = current_line:sub(1, bracket_start_idx - 1) ..
          "[" .. new_char .. "]" ..
          current_line:sub(bracket_close_idx + 1, -1)

      -- Update the buffer with the modified line
      vim.api.nvim_buf_set_lines(0, current_line_num, current_line_num + 1, false, { new_line })
    end
  end
end

return M

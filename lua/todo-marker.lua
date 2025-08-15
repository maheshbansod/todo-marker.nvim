local M = {}

M.setup = function()
  print('hello')
end

M.toggle_todo_item = function()
  -- get current line from buffer that the cursor is on
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line_num = row - 1
  local current_line = vim.api.nvim_buf_get_lines(0, current_line_num, current_line_num + 1, false)[1]

  -- check if the line begins with something like `\s*- \[[ x]\] `
  local todo_pattern = "^%s*-%s*%[[ xX]?%]"
  local start_match, end_match = current_line:find(todo_pattern)

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
        new_char = "x"
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

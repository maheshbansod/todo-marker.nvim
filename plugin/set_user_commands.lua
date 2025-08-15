vim.api.nvim_create_user_command("TodoMarkerToggle", function()
  require('todo-marker').toggle_todo_item()
end, {})

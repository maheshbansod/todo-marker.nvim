
# Todo Marker

A NeoVim plugin to toggle a todo item in a markdown file

### Installing

With lazy:

```
  {
    "maheshbansod/todo-marker.nvim",
    config = function()
      local tm = require('todo-marker')
      tm.setup()
      vim.keymap.set('n', '<leader>m', tm.toggle_todo_item)
    end
  }
```
The above config will let you use the keybinding `<leader><map>` to toggle a todo item
when you're on a line containing one.


# httpyac.nvim

Neovim plugin for running HTTP requests from `.http` files using httpyac.

![Example](example-run.png)

## Requirements

- Neovim >= 0.8.0
- [httpyac](https://httpyac.github.io/) - Install with `npm install -g httpyac`

## Installation

### Using lazy.nvim (LunarVim)
```lua
{
  "SuriyaRuk/httpyac.nvim",
  ft = "http",
  config = function()
    require("httpyac").setup({
      split_direction = "vertical", -- vertical, horizontal
      output_type = "terminal", -- terminal, buffer
    })
  end
}
```

### Using packer.nvim
```lua
use {
  'SuriyaRuk/httpyac.nvim',
  ft = 'http',
  config = function()
    require('httpyac').setup()
  end
}
```

### Using vim-plug
```vim
Plug 'SuriyaRuk/httpyac.nvim'
```

## Usage

Create a `.http` file:
```http
### Get JSON Placeholder
GET https://jsonplaceholder.typicode.com/posts/1

### Create Post
POST https://jsonplaceholder.typicode.com/posts
Content-Type: application/json

{
  "title": "foo",
  "body": "bar",
  "userId": 1
}
```

## Keybindings

Default keybindings for `.http` files:

- `<leader>hr` - Run request at cursor (terminal output)
- `<leader>hb` - Run request at cursor (buffer output)
- `<leader>ha` - Run all requests
- `<leader>hl` - List all requests and select
- `<C-j>` - Quick run request at cursor

## Configuration
```lua
require("httpyac").setup({
  split_direction = "vertical", -- "vertical" or "horizontal"
  output_type = "terminal",     -- "terminal" or "buffer"
})
```

## Features

- ✅ Run individual HTTP requests
- ✅ Run all requests in file
- ✅ List and select requests
- ✅ Terminal or buffer output
- ✅ Auto-detect request blocks
- ✅ Support all httpyac features

## License

MIT

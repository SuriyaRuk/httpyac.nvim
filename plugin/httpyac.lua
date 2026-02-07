-- Auto setup with default config
vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function()
    local httpyac = require('httpyac')
    local opts = { buffer = true, noremap = true, silent = true }

    -- <leader>hr = Run request ที่ cursor อยู่
    vim.keymap.set('n', '<leader>hr', httpyac.run_request, opts)

    -- <leader>hb = Run request แสดงผลใน buffer
    vim.keymap.set('n', '<leader>hb', httpyac.run_request_to_buffer, opts)

    -- <leader>ha = Run ทุก requests
    vim.keymap.set('n', '<leader>ha', httpyac.run_all, opts)

    -- <leader>hl = List requests และเลือก
    vim.keymap.set('n', '<leader>hl', httpyac.list_requests, opts)

    -- Ctrl-j = Quick run
    vim.keymap.set('n', '<C-j>', httpyac.run_request, opts)
  end
})

-- ตั้งค่า filetype detection
vim.filetype.add({
  extension = {
    http = 'http',
  }
})

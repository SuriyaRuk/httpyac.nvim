local M = {}

-- ฟังก์ชันหา request name จากบรรทัดปัจจุบัน
local function get_request_name()
  local current_line = vim.fn.line('.')
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  -- หาบรรทัดที่มี ### ก่อนหน้า cursor
  for i = current_line, 1, -1 do
    local line = lines[i]
    if line:match("^###%s+(.+)") then
      local name = line:match("^###%s+(.+)")
      return name
    end
  end
  return nil
end

-- ฟังก์ชันรัน httpyac
function M.run_request()
  local file_path = vim.fn.expand('%:p')
  local file_type = vim.fn.expand('%:e')
  -- ตรวจสอบว่าเป็นไฟล์ .http หรือไม่
  if file_type ~= 'http' then
    vim.notify('This is not a .http file', vim.log.levels.ERROR)
    return
  end
  local request_name = get_request_name()
  if not request_name then
    vim.notify('No request found. Move cursor to a request block.', vim.log.levels.WARN)
    return
  end
  -- สร้าง command
  local cmd = string.format('httpyac "%s" --name "%s"', file_path, request_name)
  vim.notify('Running: ' .. request_name, vim.log.levels.INFO)
  -- รันคำสั่งและแสดงผลใน split window
  vim.cmd('vsplit')
  vim.cmd('enew')
  vim.fn.termopen(cmd, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify('Request completed successfully', vim.log.levels.INFO)
      else
        vim.notify('Request failed with code: ' .. exit_code, vim.log.levels.ERROR)
      end
    end
  })
  vim.cmd('startinsert')
end

-- ฟังก์ชันรัน request และแสดงผลใน buffer
function M.run_request_to_buffer()
  local file_path = vim.fn.expand('%:p')
  local file_type = vim.fn.expand('%:e')
  if file_type ~= 'http' then
    vim.notify('This is not a .http file', vim.log.levels.ERROR)
    return
  end
  local request_name = get_request_name()
  if not request_name then
    vim.notify('No request found', vim.log.levels.WARN)
    return
  end
  vim.notify('Running: ' .. request_name, vim.log.levels.INFO)
  local cmd = string.format('httpyac "%s" --name "%s" 2>&1', file_path, request_name)
  -- รันแบบ async
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        -- สร้าง buffer ใหม่
        vim.cmd('vsplit')
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(0, buf)
        -- ตั้งค่า buffer
        vim.bo[buf].buftype = 'nofile'
        vim.bo[buf].filetype = 'json'
        vim.bo[buf].bufhidden = 'wipe'
        -- ใส่ output
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
        -- ตั้งชื่อ buffer
        vim.api.nvim_buf_set_name(buf, 'HTTP Response: ' .. request_name)
      end
    end,
  })
end

-- ฟังก์ชันรันทั้งไฟล์
function M.run_all()
  local file_path = vim.fn.expand('%:p')
  local file_type = vim.fn.expand('%:e')
  if file_type ~= 'http' then
    vim.notify('This is not a .http file', vim.log.levels.ERROR)
    return
  end
  local cmd = string.format('httpyac "%s" --all', file_path)
  vim.notify('Running all requests...', vim.log.levels.INFO)
  vim.cmd('vsplit')
  vim.cmd('enew')
  vim.fn.termopen(cmd)
  vim.cmd('startinsert')
end

-- ฟังก์ชันแสดงรายการ requests
function M.list_requests()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local requests = {}
  for i, line in ipairs(lines) do
    if line:match("^###%s+(.+)") then
      local name = line:match("^###%s+(.+)")
      table.insert(requests, {
        line = i,
        name = name
      })
    end
  end
  if #requests == 0 then
    vim.notify('No requests found', vim.log.levels.WARN)
    return
  end
  vim.ui.select(requests, {
    prompt = 'Select request to run:',
    format_item = function(item)
      return string.format('%d: %s', item.line, item.name)
    end
  }, function(choice)
    if choice then
      vim.api.nvim_win_set_cursor(0, { choice.line, 0 })
      M.run_request()
    end
  end)
end

-- Setup function
function M.setup(opts)
  opts = opts or {}
  -- Default config
  M.config = vim.tbl_deep_extend('force', {
    split_direction = 'vertical', -- vertical, horizontal
    output_type = 'terminal',     -- terminal, buffer
  }, opts)
end

return M

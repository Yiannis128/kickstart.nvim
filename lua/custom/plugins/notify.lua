-- Notification UI
vim.pack.add { 'https://github.com/rcarriga/nvim-notify' }

local notify = require 'notify'
notify.setup {
  stages = 'fade_in_slide_out',
  timeout = 3000,
}
vim.notify = notify

-- Enable the Telescope picker for notification history (<leader>sN)
pcall(require('telescope').load_extension, 'notify')

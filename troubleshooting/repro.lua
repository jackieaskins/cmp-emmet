vim.env.LAZY_STDPATH = '.repro'
load(vim.fn.system('curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua'))()

require('lazy.minit').repro({
  spec = {
    {
      'hrsh7th/nvim-cmp',
      config = function()
        local cmp = require('cmp')

        cmp.setup({
          mapping = {
            ['<C-N>'] = cmp.mapping(cmp.mapping.select_next_item()),
            ['<C-P>'] = cmp.mapping(cmp.mapping.select_prev_item()),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete()),
            ['<C-E>'] = cmp.mapping(cmp.mapping.abort()),
            ['<C-Y>'] = cmp.mapping(cmp.mapping.confirm({
              select = true,
              behavior = cmp.ConfirmBehavior.Replace,
            })),
          },
          snippet = {
            expand = function(args)
              vim.snippet.expand(args.body)
            end,
          },
          sources = { { name = 'emmet' } },
        })
      end,
    },
    {
      'jackieaskins/cmp-emmet',
      build = 'npm run release',
    },
  },
})

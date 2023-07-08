local supported_filetypes = {
  'css',
  'html',
  'javascript',
  'javascriptreact',
  'less',
  'markdown', -- Detect codeblocks in markdown files
  'pug',
  'sass',
  'scss',
  'typescriptreact',
  'xml',
}

-- Based on Treesitter integration in https://github.com/dcampos/cmp-emmet-vim/blob/master/lua/cmp_emmet_vim/init.lua#L37
local function get_language_at_cursor()
  local success, parser = pcall(vim.treesitter.get_parser)

  if not success then
    return vim.bo.filetype
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  return parser
    :language_for_range({
      cursor[1] - 1,
      cursor[2],
      cursor[1] - 1,
      cursor[2],
    })
    :lang()
end

local source = {}

function source.new()
  return setmetatable({}, { __index = source })
end

function source:is_available()
  return vim.tbl_contains(supported_filetypes, vim.bo.filetype)
end

function source:get_keyword_pattern()
  return '.'
end

function source:complete(params, callback)
  local content = ''

  local context = params.context
  local bufnr = context.bufnr
  local cursor = context.cursor

  vim.fn.jobstart({
    'cmp-emmet',
    '--content',
    table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n'),
    '--languageId',
    get_language_at_cursor(),
    '--position',
    vim.fn.json_encode({ line = cursor.line, character = cursor.character }),
    '--uri',
    vim.uri_from_bufnr(bufnr),
  }, {
    on_stdout = function(_, data)
      local output = vim.trim(data[1])
      if output ~= '' then
        content = content .. output
      end
    end,
    on_exit = function()
      local trimmed_content = vim.trim(content)

      if trimmed_content == '' then
        return callback(nil)
      end

      local results = vim.fn.json_decode(trimmed_content)
      source.incomplete = results and results.isIncomplete or false
      callback(results and results.items or nil)
    end,
  })
end

return source

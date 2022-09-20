local filetype_syntax_map = {
  html = 'html',
  xml = 'xml',
  typescriptreact = 'jsx',
  javascriptreact = 'jsx',
  css = 'css',
  sass = 'css',
  scss = 'css',
  less = 'css',
}

local source = {}

function source.new()
  return setmetatable({}, { __index = source })
end

function source:is_available()
  return vim.tbl_contains(
    { 'html', 'xml', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
    vim.bo.filetype
  )
end

function source:get_keyword_pattern()
  return '.'
end

function source:complete(params, callback)
  local content = ''

  local context = params.context
  local bufnr = context.bufnr
  local cursor = context.cursor
  local filetype = context.filetype

  vim.fn.jobstart({
    'cmp-emmet',
    '--content',
    table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n'),
    '--languageId',
    filetype,
    '--position',
    vim.fn.json_encode({ line = cursor.line, character = cursor.character }),
    '--syntax',
    filetype_syntax_map[filetype],
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

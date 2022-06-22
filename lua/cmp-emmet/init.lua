local prefix = '~'

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

function source:get_trigger_characters()
  return { '~' }
end

function source:complete(params, callback)
  local results = {}

  vim.fn.jobstart({
    'cmp-emmet',
    '--params',
    vim.fn.json_encode(params),
    '--prefix',
    prefix,
  }, {
    on_stdout = function(_, data)
      local output = data[1]
      if output ~= '' then
        table.insert(results, vim.fn.json_decode(output))
      end
    end,
    on_exit = function()
      callback(#results > 0 and results or nil)
    end,
  })
end

return source

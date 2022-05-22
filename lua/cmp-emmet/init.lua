local source = {}

function source.new()
  local self = setmetatable({}, { __index = source })
  return self
end

function source:is_available()
  return vim.tbl_contains(
    { 'html', 'xml', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
    vim.bo.filetype
  )
end

function source:get_trigger_characters()
  local alpha = {
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  }
  local numeric = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
  local closing_brackets = { ')', ']', '}' }
  local extra = { '!', ':' }

  return vim.tbl_flatten({ alpha, numeric, closing_brackets, extra })
end

local debounce_timer = vim.loop.new_timer()
function source:complete(params, callback)
  debounce_timer:stop()
  debounce_timer:start(
    300,
    0,
    vim.schedule_wrap(function()
      local results = {}

      vim.fn.jobstart({ 'cmp-emmet', '--params', vim.fn.json_encode(params) }, {
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
    end)
  )
end

return source

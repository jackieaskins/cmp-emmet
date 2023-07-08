# cmp-emmet

[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) source for [Emmet](https://emmet.io/).

Uses [vscode-emmet-helper](https://github.com/microsoft/vscode-emmet-helper). Integrates with Treesitter to determine the language under the cursor.

## Requirements

- [NodeJS](https://nodejs.org/en/)

## Installation

Install with your favorite package manager.

### lazy

```lua
{ 'jackieaskins/cmp-emmet', build = 'npm run release'  }
```

### packer

```lua
use({ 'jackieaskins/cmp-emmet', run = 'npm run release' })
```

### vim-plug

```vim
Plug 'jackieaskins/cmp-emmet', { 'do': 'npm run release' }
```

## Setup

```lua
require('cmp').setup({
  sources = {
    { name = 'emmet' }
  }
})
```

## Alternatives

When I created this plugin, there were two main options: `emmet-ls` (which I found too noisy) and `emmet-vim` (which didn't allow for integration with `nvim-cmp`). Since then there have been more options created. Feel free to check these out in case this plugin doesn't work for you:

Plugins:

- [mattn/emmet-vim](https://github.com/mattn/emmet-vim) - The original Vim Emmet plugin
- [dcampos/cmp-emmet-vim](https://github.com/dcampos/cmp-emmet-vim) - Another `nvim-cmp` completion source, has a dependency on `mattn/emmet-vim`
- [xinleibird/cmp-emmet](https://github.com/xinleibird/cmp-emmet) - Fork of this plugin

Language Servers:

- [aca/emmet-ls](https://github.com/aca/emmet-ls) - Original emmet language server
- [olrtg/emmet-language-server](https://github.com/olrtg/emmet-language-server) - Emmet language server that also uses `vscode-emmet-helper`

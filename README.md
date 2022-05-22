# cmp-emmet

[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) source for [Emmet](https://emmet.io/).

## Requirements

- [NodeJS](https://nodejs.org/en/)

## Installation

Install with your favorite package manager.

### vim-plug

```vim
Plug 'jackieaskins/cmp-emmet', { 'do': 'npm run release' }
```

### packer

```lua
use({
  'jackieaskins/cmp-emmet',
  run = 'npm run release'
})
```

## Setup

```lua
require('cmp').setup({
  sources = {
    { name = 'emmet' }
  }
})
```

# Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)

## Installation

### Install External Dependencies

External Requirements:

- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [neovim](https://neovim.io/)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- [Nerd Font](https://www.nerdfonts.com/)
- [Lazy Git](https://github.com/jesseduffield/lazygit)

### Clone repo

```sh
cd ~/.config
git clone https://github.com/Lurk/nvim.git nvim
```

## Updating plugins

Plugins are managed by Neovim's built-in `vim.pack`.

- `:lua vim.pack.update()` — update all plugins. Opens a buffer showing the
  pending diffs.
- `:lua vim.pack.update({ 'plugin-name' })` — update a single plugin.
- In the confirmation buffer, review the diffs then `:write` (`:w`) to apply,
  or `:quit` to cancel.
- `:lua vim.pack.update(nil, { force = true })` — update all and apply without
  the confirmation step.
- `:lua = vim.pack.get()` — list installed plugins and their versions.
- `:lua vim.pack.del({ 'plugin-name' })` — remove a plugin.

## Custom keys

- `U` - redo

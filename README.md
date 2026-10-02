# Neovim config

Personal Neovim configuration for Neovim 0.12 or newer.

## Requirements

- Git, `curl`, `tar`, `make`, and a C compiler
- [ripgrep](https://github.com/BurntSushi/ripgrep) for Telescope text search
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) 0.26.1 or newer
- A Nerd Font for icons

Language servers for Lua, Python, and C/C++ are installed automatically through Mason.

## Install

```sh
git clone https://github.com/akpiya/nvimconfig.git ~/.config/nvim
nvim
```

Run `:Lazy sync` to update plugins and `:checkhealth` to diagnose local dependencies.

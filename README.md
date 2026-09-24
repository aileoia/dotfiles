# Dotfiles

Personal Linux configuration for a zsh + Neovim + Regolith/i3 workstation.

Dotbot links files from this repo into `$HOME`. The mapping lives in
`install.conf.yaml`.

## Layout

| Path | Role |
| --- | --- |
| `zshrc`, `p10k.zsh` | zsh, Antigen plugins, Powerlevel10k |
| `config/nvim/` | AstroNvim v6 user config |
| `vimrc` | Classic Vim (vim-plug), kept as a fallback |
| `config/i3.config`, `config/i3blocks.conf` | standalone i3 |
| `config/regolith3/` | Regolith 3 i3 extras and Xresources |
| `config/ranger/`, `config/feh/` | file manager and image viewer |
| `gitignore` | global git ignore |
| `install-conda-and-some-more.zsh` | optional Miniforge, Neovim AppImage, pipx tools |

Vendored as git submodules: [Dotbot](https://github.com/anishathalye/dotbot),
[Antigen](https://github.com/zsh-users/antigen),
[vim-plug](https://github.com/junegunn/vim-plug).

## Install

```bash
git clone https://github.com/aileoia/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

`./install` initializes submodules, creates `~/.local/bin`, symlinks configs,
appends `exec zsh` to `~/.bashrc` if missing, and runs Vim `:PlugInstall`.

Recommended on the host:

- `zsh` (the install still runs without it)
- a [Nerd Font](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k) for Powerlevel10k
- Neovim 0.12+ on `PATH` (or `~/.local/bin`) for the AstroNvim config
- `direnv` if you want the hook in `zshrc`

Antigen bundles install on the first zsh session. AstroNvim plugins and Mason
language servers install on the first `nvim` start.

### Optional Python / Neovim bootstrap

```bash
./install-conda-and-some-more.zsh
```

That script is separate from Dotbot. It downloads a Neovim AppImage, installs
Miniforge, and pipx-installs tools such as black, ruff, pre-commit, and ranger.

### Partial install

Edit `install.conf.yaml` and rerun `./install`. Extra arguments are passed
through to Dotbot.

## Shell

- Theme: Powerlevel10k (`p10k configure` or edit `p10k.zsh`)
- Plugins: git, vi-mode, autosuggestions, history-substring-search,
  syntax-highlighting, conda completion, you-should-use
- Conda hook assumes `$HOME/miniforge3`
- Extra env: `$HOME/.environment` if present
- Aliases: `vim` → `nvim`, `gl` / `glr` for fast-forward / rebase pulls

## Neovim

AstroNvim v6 with community packs for Docker, Helm, JSON, Lua, Markdown,
Python (ruff), TOML, and YAML. Format on save is on. User plugin examples in
`config/nvim/lua/plugins/user.lua` and `polish.lua` are still disabled.

The classic `vimrc` remains for Vim-only machines.

## Desktop

Regolith 3 workspaces (terminal, web, Slack, chat) and i3lock. Standalone i3
config is still linked for non-Regolith boxes.

## License

LGPL-3.0 (see `LICENSE`).

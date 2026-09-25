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
| `install-runtimes.sh` | optional Neovim, Node LTS, uv Python, CLI tools |

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

### Optional runtimes (Neovim, Node, Python, CLI tools)

Separate from Dotbot. Formerly `install-conda-and-some-more.zsh`. Does not
install Miniforge; conda remains optional if you want it later.

```bash
bash install-runtimes.sh
DESKTOP=1 bash install-runtimes.sh
```

Installs into `~/.local`:

- Neovim 0.12+ from the official GitHub tarball (not an AppImage)
- Node.js 22.13+ LTS, plus the `neovim` npm package
- [uv](https://docs.astral.sh/uv/) with CPython 3.12 and a dedicated
  `~/.local/share/nvim/python` environment containing `pip` and `pynvim`
- Neovim health tools from their official releases: lazygit, fd, gdu, and btm
- `uv tool` CLIs: ruff, pre-commit, ranger

Set `EXTRAS=1` to also install dvc and tox. Re-running skips pieces that are
already present.

Set `DESKTOP=1` to install
[`@mermaid-js/mermaid-cli`](https://github.com/mermaid-js/mermaid-cli) and
[Kitty](https://sw.kovidgoyal.net/kitty/) for inline Mermaid diagrams through
Snacks. The script verifies a real `mmdc` render. On Linux systems where
AppArmor blocks Chromium's user-namespace sandbox, it creates a local
`--no-sandbox` wrapper; only render trusted Markdown in that mode. Regolith and
standalone i3 launch the user-local Kitty from `Mod+Enter`.

### Partial install

Edit `install.conf.yaml` and rerun `./install`. Extra arguments are passed
through to Dotbot.

## Shell

- Theme: Powerlevel10k (`p10k configure` or edit `p10k.zsh`)
- Plugins: git, vi-mode, autosuggestions, history-substring-search,
  syntax-highlighting, conda completion, you-should-use
- Conda hook is a no-op unless `$HOME/miniforge3` exists (not installed by this repo)
- Extra env: `$HOME/.environment` if present
- Aliases: `vim` → `nvim`, `gl` / `glr` for fast-forward / rebase pulls

## Neovim

AstroNvim v6 with community packs for Docker, Helm, JSON, Lua, Markdown,
Python (ruff), TOML, and YAML. Format on save is on. User plugin examples in
`config/nvim/lua/plugins/user.lua` and `polish.lua` are still disabled. Mason
and `python3_host_prog` use the dedicated uv environment created by
`install-runtimes.sh`.

Snacks document images are enabled. Mermaid fences use the Mermaid Treesitter
parser, `mmdc`, and Kitty's graphics protocol for inline previews. `:checkhealth`
may still list missing Go, Rust, Ruby, PHP, Julia, and other language runtimes;
those are Mason capability checks, not requirements for the configured packs.
See the [Kitty and Mermaid cheat sheet](docs/kitty-cheatsheet.md) for shortcuts
and preview troubleshooting.

Comparison of Neovim distributions (AstroNvim, LazyVim, omarchy-nvim,
and others): [docs/neovim-distributions.md](docs/neovim-distributions.md).

The classic `vimrc` remains for Vim-only machines.

## Desktop

Regolith 3 workspaces (terminal, web, Slack, chat) and i3lock. Standalone i3
config is still linked for non-Regolith boxes.

## License

LGPL-3.0 (see `LICENSE`).

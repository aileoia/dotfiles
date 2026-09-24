# Neovim distributions

Last reviewed: 2026-09.

This note compares batteries-included Neovim **distributions** with
**starters** and **from-scratch** configs. It is a decision log for this
dotfiles repo, not an install guide.

This repo tracks [AstroNvim](https://docs.astronvim.com/) v6. See
[`config/nvim/`](../config/nvim/) and the Neovim section of the
[root README](../README.md).

## What a distro is

A **distribution** ships an opinionated plugin stack, keymaps, UI, and
usually LSP / formatters so the editor is usable on first launch. You
customize *on top* of someone else's layer (AstroNvim's `astrocore` /
`astrolsp`, LazyVim extras, NvChad's chadrc, and so on).

A **starter** (most often [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim))
is a small, commented config you are expected to own and grow. There is
no extras catalog or major-version upgrade path from upstream.

A **custom** config is `lazy.nvim` (or another manager) plus plugins you
chose. Maximum control; you keep the graph working.

To try another stack without overwriting this repo's linked
`~/.config/nvim`, use Neovim's `$NVIM_APPNAME` (see `:help $NVIM_APPNAME`).
Example: `NVIM_APPNAME=lazyvim nvim` with a separate config tree under
`~/.config/lazyvim`.

## How this repo chose

AstroNvim v6 with [astrocommunity](https://github.com/AstroNvim/astrocommunity)
language packs for Docker, Helm, JSON, Lua, Markdown, Python (ruff),
TOML, and YAML (`config/nvim/lua/community.lua`). The core pin is
`version = "^6"` in `config/nvim/lua/lazy_setup.lua`. Format on save is
on. That matches a workstation that already lives in Lua plugin specs
and needs those filetypes more than a desktop-theme loop or a
from-scratch learning config.

The classic [`vimrc`](../vimrc) remains a Vim-only fallback, not a
Neovim distro.

## Comparison

| Setup | Plugin manager | Configuration model | Language extras | Versioning | Typical audience |
| --- | --- | --- | --- | --- | --- |
| [AstroNvim](https://docs.astronvim.com/) | lazy.nvim | User template + astrocore / astrolsp / astroui | astrocommunity packs | Semver on the core (`^6` here) | People who want an IDE-like base and modular packs |
| [LazyVim](https://www.lazyvim.org/) | lazy.nvim | Starter + `lazyvim.plugins` + extras | Built-in extras (`lang.*`, etc.) | Distro releases on top of lazy.nvim | People who want extras-first and LazyVim docs / keymaps |
| [omarchy-nvim](https://omarchy.org/manual/neovim/) | lazy.nvim (via LazyVim) | Omarchy package wrapping LazyVim | LazyVim extras, plus Omarchy defaults | Follows Omarchy / package updates | Omarchy Linux users who want zero-config Neovim on that desktop |
| [NvChad](https://nvchad.com/) | lazy.nvim | chadrc / NvChad UI layer | More DIY than Astro / LazyVim | Historically looser than AstroNvim | People who want a lean UI and to wire LSP themselves |
| [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) | lazy.nvim | One well-commented config you own | None (you add it) | You merge upstream if you want | Learners and people who refuse a distro layer |
| [LunarVim](https://www.lunarvim.org/) | lazy.nvim | `lvim` wrapper and abstractions | Batteries included (historically) | Maintenance-coast as of 2026 | Existing LunarVim installs, not new defaults |
| [SpaceVim](https://spacevim.org/) | layers (Vim + Neovim) | TOML / layers | Layer catalog | Older release cadence | Users already in the SpaceVim layer model |
| Custom | typically lazy.nvim | Your lua tree | Whatever you assemble | You | People who will maintain the graph |

omarchy-nvim is listed next to LazyVim because it **is** LazyVim,
packaged for [Omarchy](https://omarchy.org/), not a separate core
distro like AstroNvim or NvChad.

## Per-setup notes

### AstroNvim (this repo)

**Pros**

- Modular [astrocommunity](https://github.com/AstroNvim/astrocommunity)
  packs for the languages this machine actually edits.
- Versioned core, so updates can stay inside a major (`^6`) until you
  choose a migration.
- Strong IDE defaults (LSP, Mason, treesitter, UI) without inventing a
  keymap scheme from scratch.

**Cons**

- Configuration goes through Astro modules (`astrocore`, `astrolsp`,
  `astroui`). That is another API to learn.
- Major jumps (for example v4 to v6) can force Mason / LSP spec rewrites.
- More moving parts than kickstart; startup is usually slower than a
  lean NvChad or a tiny custom config.

### LazyVim

**Pros**

- Extras system: enable a language extra and get a tested LSP /
  formatter / plugin set.
- Documentation and leader-key conventions at
  [lazyvim.org](https://www.lazyvim.org/).
- Same author as lazy.nvim, so the plugin manager and distro match.

**Cons**

- Still an opinionated layer; overrides follow LazyVim's file layout,
  not "just lua plugins".
- Maintenance tempo depends on the upstream maintainer.
- Migrating *from* AstroNvim is a keymap and config-shape rewrite, not
  a pin bump.

### omarchy-nvim

Omarchy Linux ships a complete Neovim setup as the `omarchy-nvim`
package, built on LazyVim, aimed at working without writing
configuration. See the [Omarchy Neovim manual](https://omarchy.org/manual/neovim/).

**Pros**

- Zero-config IDE on an Omarchy install (`n` alias, desktop binding).
- Desktop theme sync: Omarchy theme files can drive Neovim (typically
  linking `neovim.lua` into `lua/plugins/theme.lua`).
- Newcomer-oriented keymaps on top of LazyVim (`Space` leader, which-key).

**Cons**

- Tied to Omarchy / Arch packaging (`/usr/share/omarchy-nvim` vs
  `~/.config/nvim`). Not a portable default for this zsh + Regolith
  + AstroNvim repo.
- Setup scripts may back up and **overwrite** an existing nvim config.
- Extra layer on LazyVim (desktop integration; some community ports add
  Copilot / agent tooling). You inherit both LazyVim *and* Omarchy
  packaging choices.

Use it if you live on Omarchy and want that theme/desktop loop. Do not
switch this repo to it for "another LazyVim".

### NvChad

**Pros**

- Lean UI, often among the faster distro startups.
- Clear visual defaults; good if you want a base and will configure LSP
  yourself.

**Cons**

- Less "IDE complete" out of the box than AstroNvim or LazyVim.
- Versioning has historically been looser than AstroNvim's semver pin,
  so updates can surprise you.

### kickstart.nvim

**Pros**

- Small, heavily commented, you own every line.
- Excellent learning path; easy to diff and bisect.

**Cons**

- Not a distro: no extras catalog, no upstream language packs.
- LSP, formatters, and UI polish are ongoing DIY.

### LunarVim

**Pros**

- Historically a complete, batteries-included stack with an `lvim`
  wrapper that can sit beside another Neovim config.

**Cons**

- As of 2026 it is often described as maintenance-coast (weaker Neovim
  version tracking, fewer pushes). Fine if it already works; a poor
  *new* default.

### SpaceVim

**Pros**

- Long-lived layer catalog spanning Vim and Neovim.

**Cons**

- Heavier, less aligned with the current Lua / lazy.nvim ecosystem this
  repo already uses.

### Custom (from-scratch)

**Pros**

- Full control; every plugin is a choice you can explain.
- Same idea as keeping a classic Vim `vimrc` for machines without
  Neovim.

**Cons**

- Highest ongoing maintenance: LSP combinations, lockfiles, breaking
  plugin APIs.

## When to stay vs switch

Stay on **AstroNvim** while the community packs and Mason / LSP stack
stay aligned with Neovim 0.12+.

Consider **LazyVim** if you want extras-first configuration and are
willing to drop the Astro\* APIs.

Consider **omarchy-nvim** only if the machine is Omarchy and the
desktop theme integration matters more than portability.

Consider **kickstart.nvim** if the goal is to own the config and learn
the stack.

Do not migrate for a few dozen milliseconds of startup.

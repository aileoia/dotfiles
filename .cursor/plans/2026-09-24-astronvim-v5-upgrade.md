# AstroNvim v4 → v6 + Neovim upgrade

## Goal

Restore a matched Neovim + AstroNvim + Mason + astrocommunity stack so language servers (especially Docker and Python) attach again. Starting point was Neovim 0.11.3 + AstroNvim v4.32.3 + Mason 1.x, while `astrocommunity` HEAD (2026-09-23) already targeted AstroNvim v6 / Mason 2.x.

## Why this path

Pinning astrocommunity back to March 2025 would make Docker/Python work on v4, but the community plugin has already drifted and will keep doing so. **AstroNvim `^6`** (not v5) is the line that matches current astrocommunity, Mason 2.x (`mason-org/`), `mason-tool-installer`, and Neovim 0.12 `vim.lsp.config`. Official template: `version = "^6"`. Official migration: https://docs.astronvim.com/configuration/v6_migration/

## Current state (2026-09-24)

### What already happened

- Mason shims under `~/.local/share/nvim/mason/bin/` had all been deleted (zero symlinks). Tree was moved aside to `~/.local/share/nvim/mason.broken` and a new Mason tree was created.
- Reinstall only brought back 9 of the original 15 packages: `hadolint`, `helm-ls`, `json-lsp`, `lua-language-server`, `marksman`, `selene`, `stylua`, `taplo`, `yaml-language-server`.
- **Marksman works.** LSP log at 11:06 and 11:07 shows it attaching to `/home/leo/repos/leo-personal`. Neovim prefixes stderr as `[ERROR]`; Marksman's own lines are `INF`.
- **Docker does not work.** Current astrocommunity `pack.docker` installs `docker-language-server`. March 2025 `nvim-lspconfig` only knows `dockerls` and `docker_compose_language_service`.
- **Python stack is gone from Mason:** `basedpyright`, `debugpy`, Mason `ruff`. Shell still has `~/.local/bin/ruff`, so ruff diagnostics may still appear.
- `lua/community.lua` already dropped `{ import = "astrocommunity.pack.python-ruff" }`. Replacement is `astrocommunity.pack.python.ruff`. Do not restore the old import.
- `lazy-lock.json` lives at `~/.config/nvim/lazy-lock.json` (real file, not a symlink). It was rewritten 2026-09-24 at 11:03 and is the v4 pin set.

### Version mismatch that caused silent Mason skips

| Piece | Installed (v4 era) | Notes |
|---|---|---|
| Neovim | 0.11.3 AppImage (then 0.12.5) | `/home/leo/.local/bin/nvim`, historically **root-owned** |
| AstroNvim | v4.32.3 (`c5e610f`, 2025-03-18) | `version = "^4"` in `config/nvim/lua/lazy_setup.lua` |
| nvim-lspconfig | 2025-03-18 | old `lspconfig.configs` API, no `docker-language-server` |
| mason.nvim | v1.11.0 | `williamboman/` era |
| mason-lspconfig.nvim | v1.32.0 | remote was `williamboman/mason-lspconfig.nvim.git` |
| astrocommunity | `26fb637` 2026-09-23 | packs use `mason-org/mason-lspconfig.nvim` + `mason-tool-installer.nvim` |

All pack `ensure_installed` specs are `optional = true`. lazy.nvim skips them when the plugin name does not match. `mason-tool-installer.nvim` is not installed at all. Result: no error, just missing servers.

Python pack layout now: `pack/python/{base, basedpyright, black, isort, pyrefly, ruff, ty}`. Default `pack.python` is base + basedpyright + black + isort. There is no `pack/python-ruff`.

## Approach

One migration: backup → Neovim 0.12.5 binary (user, `sudo`) → AstroNvim `^6` → Mason 2.x reinstall → rewrite user LSP/Mason specs → verify filetypes. Escape hatch: pin astrocommunity to a March-2025 commit and revert `^6` if LSP is too broken.

Read upstream before editing:

- https://docs.astronvim.com/configuration/v6_migration/
- https://github.com/AstroNvim/AstroNvim/releases
- https://github.com/neovim/neovim/releases (stable 0.12.5)
- The v6 user template: https://github.com/AstroNvim/template

## Steps

### 0. Safety

- [x] Branch this repo off `master` (`nvim-astronvim-v6`).
- [x] Copy `~/.config/nvim/lazy-lock.json` into `config/nvim/lazy-lock.json` and commit it **before** `:Lazy sync`.
- [ ] Back up `~/.local/share/nvim` and `~/.local/state/nvim` (or use `NVIM_APPNAME=astronvim_v6` so the v4 data dir is untouched).
- [ ] Keep the 0.11.3 AppImage as `nvim.0.11.3.bak` if it still exists.
- [ ] Confirm GitHub is reachable (`curl` to `api.github.com`). Mason registry fetch failed on 2026-09-18 with wget exit 4.

### 1. Neovim binary (user prerequisite)

- [ ] Replace `/home/leo/.local/bin/nvim` with 0.12.5 AppImage (`sudo`; then `chown leo:leo`).
- [ ] `chown -R leo:leo` on nvim XDG dirs and `lazy-lock.json` so Mason is not rewritten as root.
- [ ] `nvim --version` in a real terminal (not a FUSE-less sandbox) → `NVIM v0.12.5`.
- [ ] Confirm `:checkhealth` starts before any config change.

Do not wipe Mason in this step.

### 2. AstroNvim v6

- [ ] `config/nvim/lua/lazy_setup.lua`: `version = "^4"` → `version = "^6"`.
- [ ] `config/nvim/lua/community.lua`: add `{ import = "astrocommunity.pack.python.ruff" }`. Keep docker/helm/json/lua/markdown/python/toml/yaml.
- [ ] `astrocore.lua`: `features.diagnostics_mode` → `features.diagnostics` (v6 template).
- [ ] `astrolsp.lua`: v6 template APIs (`client:supports_method`, `handlers["*"]`, `vim.lsp.codelens.enable`). Keep `format_on_save` and inlay hints.
- [ ] Move `.neoconf.json` `lua_ls` format-off into `config/nvim/lsp/lua_ls.lua` (v6 dropped neoconf.nvim).
- [ ] Isolated `:Lazy sync` (`NVIM_APPNAME=astronvim_v6`) and resolve plugin rename conflicts (`mason-org/mason.nvim`, `mason-org/mason-lspconfig.nvim`).
- [ ] Commit the new `lazy-lock.json` once sync succeeds.

### 3. Mason 2.x

- [ ] Wipe Mason 1.x tree for the v6 data dir. `mason.broken` can go after Phase 5.
- [ ] Rewrite `config/nvim/lua/plugins/mason.lua` to `WhoIsSethDaniel/mason-tool-installer.nvim` (Mason package names). Activate it with the expected tool list.
- [ ] Do not use `setup_handlers` — gone in mason-lspconfig 2.x; AstroLSP attaches via `vim.lsp.enable`.

Expected tools after reinstall: `lua-language-server`, `basedpyright`, `ruff`, `docker-language-server`, `json-lsp`, `marksman`, `taplo`, `yaml-language-server`, `helm-ls`, `stylua`, `selene`, `hadolint`, `black`, `isort`, `debugpy`.

### 4. LSP / formatting config

- [ ] No live `require("lspconfig")[server].setup()` handlers in user config.
- [ ] Leave `none-ls.lua` disabled; current packs use `conform.nvim` + `nvim-lint`.
- [ ] Leave `treesitter.lua` disabled (v6 uses AstroCore `treesitter` + `nvim-treesitter` `main`).
- [ ] Keep `format_on_save`.

### 5. Verify

Open a real file of each type and confirm a client attaches (`:checkhealth vim.lsp`, not `:LspInfo` on 0.12):

- [ ] Lua (`config/nvim/lua/lazy_setup.lua`)
- [ ] Python
- [ ] Dockerfile
- [ ] `docker-compose.yaml` (filetype `yaml.docker-compose`)
- [ ] YAML, JSON, TOML, Markdown, Helm

Docker payoff: one `docker-language-server` instead of `dockerls` + `docker_compose_language_service`.

### 6. Commit and merge

- [ ] Commit remaining config + `lazy-lock.json` on the branch.
- [ ] Merge to `master` when `:checkhealth` is clean (manual).
- [ ] Remove `~/.local/share/nvim/mason.broken` and the old AppImage backup when confident.

## Key decisions and trade-offs

- **v6 now vs pin astrocommunity.** v6 is more work (plugin renames + LSP API + treesitter `main`). Pinning is a one-file rollback if this stalls. Do not half-upgrade (new Neovim + still `^4` as the destination).
- **v5 is stale.** astrocommunity HEAD and the official template already require v6.
- **Track `lazy-lock.json` in this repo.** Dotbot globs `config/nvim/*`; once the file exists here it will be linked.
- **Binary first, then config.** Failures have one cause.
- **Two ruffs.** After Mason reinstall, Neovim will prefer `…/mason/bin/ruff` over `~/.local/bin/ruff`.
- **Root-owned nvim.** Fix ownership during Phase 1.
- **UX:** v5/v6 replaced Telescope / nvim-cmp / alpha with snacks + blink.cmp.

## Files likely touched

- `config/nvim/lua/lazy_setup.lua` — AstroNvim version pin
- `config/nvim/lua/community.lua` — ruff import path
- `config/nvim/lua/plugins/mason.lua` — mason-tool-installer
- `config/nvim/lua/plugins/astrolsp.lua` — LSP attach API
- `config/nvim/lua/plugins/astrocore.lua` — diagnostics feature table
- `config/nvim/lua/plugins/none-ls.lua` — leave disabled
- `config/nvim/lsp/lua_ls.lua` — replace neoconf lua_ls format setting
- `config/nvim/lazy-lock.json` — **add**
- `~/.local/bin/nvim` — binary
- `~/.local/share/nvim/mason` — wipe + reinstall (or isolated `astronvim_v6` data dir)

## Escape hatch

If Phase 4 is too broken: set astrocommunity to a commit from ~2025-03 matching AstroNvim v4.32.3, keep `version = "^4"`, restore `williamboman` mason specs, and list v1 server names (`dockerls`, `docker_compose_language_service`, `basedpyright`, `lua_ls`, …) in `mason.lua`.

# Neovim distribution documentation

## Goal

Give this repo a durable, opinionated comparison of Neovim distributions
(batteries-included configs) versus starters and from-scratch setups, with
AstroNvim first because that is what `config/nvim/` actually uses. Include
omarchy-nvim (Omarchy’s packaged LazyVim setup).

## Approach chosen and why

Keep the comparison in `docs/` and link it from the root README. Do not
replace `config/nvim/README.md`, which is still the upstream AstroNvim
template install guide.

## Key decisions and trade-offs

- Decision-oriented note, not a tutorial.
- omarchy-nvim sits next to LazyVim because it is LazyVim plus Omarchy
  packaging, not a peer core distro.
- Cite upstream docs rather than copying third-party articles.

## Steps

- [x] Persist this plan under `.cursor/plans/`.
- [x] Write `docs/neovim-distributions.md`.
- [x] Link it from the Neovim section of `README.md`.

## Files

- [`docs/neovim-distributions.md`](../../docs/neovim-distributions.md)
- [`README.md`](../../README.md)
- [`config/nvim/lua/community.lua`](../../config/nvim/lua/community.lua)
- [`config/nvim/lua/lazy_setup.lua`](../../config/nvim/lua/lazy_setup.lua)

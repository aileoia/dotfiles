# User-local runtime bootstrap

## Goal

Replace Miniforge-as-kitchen-sink with a bash `install-runtimes.sh` that installs Neovim, Node LTS, uv/CPython, and CLI tools under `~/.local` so desktops and servers can start coding without conda.

## Approach

uv for Python and tools; official Node and Neovim tarballs; conda stays optional and is not installed by this repo.

## Steps

- [x] Add `install-runtimes.sh` (bash, idempotent); delete `install-conda-and-some-more.zsh`
- [x] Drop miniforge `node`/`npm` links in `install.conf.yaml`
- [x] Point Mason PATH and `python3_host_prog` at uv CPython
- [x] Update README; conda optional

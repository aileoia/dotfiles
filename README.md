# My dotfiles

These are my configuration files for

  * vim
  * zsh
  * i3
  * more ...

The basic idea is to link the files in this repository to the corresponding
configuration files (e.g. `~/.vimrc -> vimrc`).  To see which files get linked,
checkout `install.conf.yaml`.

## Getting started

### Installation

Clone recursively
```bash
git clone --recursive https://github.com/aileoia/dotfiles ~/.dotfiles
```
If you forget the `--recursive`, then just enter
```bash
git submodule update --init --recursive
```

This will get all the dependencies.  To install, enter:
```bash
cd ~/.dotfiles
./install
```

The zsh theme installed by default is
[powerlevel10k](https://github.com/romkatv/powerlevel10k) for which it is
recommended to install the [Meslo Nerd
Font](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k).

### I just want part of it

If you are in a hurry, just have a look at look at `install.conf.yaml`, it is
almost self-explained.  If you have a bit more time, checkout
[dotbot](https://github.com/anishathalye/dotbot), which is the bootstrapping
library used here.  It is also shipped as a submodule so that the installation
of the these files can happen without having to install it manually.

## What's inside

### `zsh`

The `zsh` shell is defined as default shell by appending `exec zsh` at the
bottom of the `~/.bashrc` (see `install.conf.yaml`).

The zsh plugins are managed by [antigen](https://github.com/zsh-users/antigen),
which is provided as a git submodule.  _Note that the plugins get installed
only the first time you start a `zsh` shell._

The theme used is [powerlevel10k](https://github.com/romkatv/powerlevel10k)
already configured for my taste.  To reconfigure it, run `p10k configure` or
just remove the file `p10k.zsh`.  Note that for this theme to work well, the
Meslo Nerd Font is recommended, see above.

Checkout `zshrc` to see which plugins are activated, they are defined right
after `bundle` (any recommendation is welcome!).

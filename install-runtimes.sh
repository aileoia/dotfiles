#!/usr/bin/env bash
# User-local runtimes for Neovim and day-to-day coding.
# Replaces install-conda-and-some-more.zsh (Miniforge is optional and separate).
#
# Usage:
#   bash install-runtimes.sh
#   EXTRAS=1 bash install-runtimes.sh   # also install dvc and tox
#
# Layout:
#   ~/.local/opt/nvim   official Neovim tarball
#   ~/.local/opt/node   Node.js LTS tarball
#   ~/.local/bin        nvim, node, npm, npx, uv, uv tools

set -o errexit -o nounset -o pipefail

LOCAL_BIN="${HOME}/.local/bin"
LOCAL_OPT="${HOME}/.local/opt"
NVIM_MIN_VERSION="0.12.0"
PYTHON_VERSION="3.12"

mkdir --parents "${LOCAL_BIN}" "${LOCAL_OPT}"
export PATH="${LOCAL_BIN}:${PATH}"

log() {
  printf '%s\n' "$*"
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

download() {
  url=$1
  dest=$2
  if need_cmd curl; then
    curl --fail --silent --show-error --location --retry 3 --output "${dest}" "${url}"
  elif need_cmd wget; then
    wget --quiet --output-document="${dest}" "${url}"
  else
    die "need curl or wget"
  fi
}

# True if $1 is greater than or equal to $2 (dotted numeric versions).
version_ge() {
  [ "$(printf '%s\n' "$2" "$1" | sort --version-sort | head --lines=1)" = "$2" ]
}

nvim_reported_version() {
  if ! need_cmd nvim; then
    return 1
  fi
  nvim --version 2>/dev/null | awk 'NR==1 { sub(/^v/, "", $2); print $2; exit }'
}

detect_arch() {
  machine=$(uname --machine)
  case "${machine}" in
    x86_64)
      NVIM_ASSET="nvim-linux-x86_64.tar.gz"
      NODE_ARCH="x64"
      ;;
    aarch64 | arm64)
      NVIM_ASSET="nvim-linux-arm64.tar.gz"
      NODE_ARCH="arm64"
      ;;
    *)
      die "unsupported architecture: ${machine}"
      ;;
  esac
}

install_nvim() {
  current=$(nvim_reported_version || true)
  if [ -n "${current}" ] && version_ge "${current}" "${NVIM_MIN_VERSION}"; then
    log "Neovim ${current} already satisfies >= ${NVIM_MIN_VERSION}, skipping"
    return 0
  fi

  log "Installing Neovim from GitHub stable (${NVIM_ASSET})"
  tmpdir=$(mktemp --directory)
  trap 'rm --recursive --force "${tmpdir}"' RETURN
  tarball="${tmpdir}/${NVIM_ASSET}"
  download "https://github.com/neovim/neovim/releases/download/stable/${NVIM_ASSET}" "${tarball}"

  rm --recursive --force "${LOCAL_OPT}/nvim"
  mkdir --parents "${LOCAL_OPT}/nvim"
  tar --extract --gzip --file "${tarball}" --directory "${LOCAL_OPT}/nvim" --strip-components=1
  ln --symbolic --force --no-dereference "${LOCAL_OPT}/nvim/bin/nvim" "${LOCAL_BIN}/nvim"
  trap - RETURN
  rm --recursive --force "${tmpdir}"

  log "Installed $(nvim --version | head --lines=1)"
}

latest_node_lts_version() {
  index=$(mktemp)
  download "https://nodejs.org/dist/index.tab" "${index}"
  # columns: version date files npm v8 uv zlib openssl modules lts security
  awk 'NR > 1 && $10 != "-" { print $1; exit }' "${index}"
  rm --force "${index}"
}

install_node() {
  if need_cmd node && need_cmd npm; then
    log "Node $(node --version) already on PATH, skipping download"
  else
    version=$(latest_node_lts_version)
    [ -n "${version}" ] || die "could not resolve Node.js LTS version"
    asset="node-${version}-linux-${NODE_ARCH}.tar.gz"
    log "Installing Node.js LTS ${version} (${asset})"

    tmpdir=$(mktemp --directory)
    trap 'rm --recursive --force "${tmpdir}"' RETURN
    tarball="${tmpdir}/${asset}"
    download "https://nodejs.org/dist/${version}/${asset}" "${tarball}"

    rm --recursive --force "${LOCAL_OPT}/node"
    mkdir --parents "${LOCAL_OPT}/node"
    tar --extract --gzip --file "${tarball}" --directory "${LOCAL_OPT}/node" --strip-components=1
    ln --symbolic --force --no-dereference "${LOCAL_OPT}/node/bin/node" "${LOCAL_BIN}/node"
    ln --symbolic --force --no-dereference "${LOCAL_OPT}/node/bin/npm" "${LOCAL_BIN}/npm"
    ln --symbolic --force --no-dereference "${LOCAL_OPT}/node/bin/npx" "${LOCAL_BIN}/npx"
    trap - RETURN
    rm --recursive --force "${tmpdir}"
  fi

  log "Installing neovim npm package into ${HOME}/.local"
  npm install --global --prefix "${HOME}/.local" neovim
}

install_uv() {
  if need_cmd uv; then
    log "uv $(uv --version) already on PATH, skipping installer"
  else
    log "Installing uv into ${LOCAL_BIN}"
    if need_cmd curl; then
      curl --location --silent --show-error --fail https://astral.sh/uv/install.sh |
        env UV_INSTALL_DIR="${LOCAL_BIN}" UV_NO_MODIFY_PATH=1 sh
    else
      wget --quiet --output-document=- https://astral.sh/uv/install.sh |
        env UV_INSTALL_DIR="${LOCAL_BIN}" UV_NO_MODIFY_PATH=1 sh
    fi
  fi

  log "Installing CPython ${PYTHON_VERSION} via uv"
  uv python install "${PYTHON_VERSION}"
  uv python pin --global "${PYTHON_VERSION}" >/dev/null || true

  python_bin=$(uv python find)
  log "Installing pynvim for ${python_bin}"
  uv pip install --python "${python_bin}" pynvim
}

uv_tool() {
  pkg=$1
  bin=${2:-$1}
  if need_cmd "${bin}"; then
    log "${bin} already on PATH, skipping uv tool install ${pkg}"
    return 0
  fi
  log "uv tool install ${pkg}"
  uv tool install "${pkg}"
}

install_tools() {
  uv_tool ruff
  uv_tool pre-commit
  uv_tool ranger-fm ranger

  extras=${EXTRAS:-0}
  if [ "${extras}" = "1" ]; then
    uv_tool dvc
    uv_tool tox
  else
    log "Skipping dvc and tox (set EXTRAS=1 to install)"
  fi
}

detect_arch
log "Installing user-local runtimes into ${HOME}/.local"
install_nvim
install_node
install_uv
install_tools
log "Done. Ensure ${LOCAL_BIN} is on PATH (zshrc already prepends it)."

#!/usr/bin/env bash
# User-local runtimes for Neovim and day-to-day coding.
# Replaces install-conda-and-some-more.zsh (Miniforge is optional and separate).
#
# Usage:
#   bash install-runtimes.sh
#   EXTRAS=1 bash install-runtimes.sh   # also install dvc and tox
#   DESKTOP=1 bash install-runtimes.sh  # also install Mermaid CLI and Kitty
#
# Layout:
#   ~/.local/opt/nvim   official Neovim tarball
#   ~/.local/opt/node   Node.js LTS tarball
#   ~/.local/opt/kitty  official Kitty binary release (DESKTOP=1)
#   ~/.local/bin        runtimes and CLI tools

set -o errexit -o nounset -o pipefail

LOCAL_BIN="${HOME}/.local/bin"
LOCAL_OPT="${HOME}/.local/opt"
NVIM_PYTHON="${HOME}/.local/share/nvim/python"
NVIM_MIN_VERSION="0.12.0"
NODE_MIN_VERSION="22.13.0"
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

github_latest_tag() {
  repo=$1
  metadata=$(mktemp)
  download "https://api.github.com/repos/${repo}/releases/latest" "${metadata}"
  tag=$(awk -F '"' '/"tag_name":/ { print $4; exit }' "${metadata}")
  rm --force "${metadata}"
  [ -n "${tag}" ] || die "could not resolve latest release for ${repo}"
  printf '%s\n' "${tag}"
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
      LAZYGIT_ARCH="x86_64"
      FD_ARCH="x86_64"
      GDU_ARCH="amd64"
      BTM_ARCH="x86_64"
      KITTY_ARCH="x86_64"
      ;;
    aarch64 | arm64)
      NVIM_ASSET="nvim-linux-arm64.tar.gz"
      NODE_ARCH="arm64"
      LAZYGIT_ARCH="arm64"
      FD_ARCH="aarch64"
      GDU_ARCH="arm64"
      BTM_ARCH="aarch64"
      KITTY_ARCH="arm64"
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

node_reported_version() {
  if ! need_cmd node; then
    return 1
  fi
  node --version 2>/dev/null | sed 's/^v//'
}

install_node() {
  current=$(node_reported_version || true)
  if [ -n "${current}" ] && need_cmd npm && version_ge "${current}" "${NODE_MIN_VERSION}"; then
    log "Node ${current} already satisfies >= ${NODE_MIN_VERSION}, skipping download"
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

  python_bin="${NVIM_PYTHON}/bin/python"
  if [ ! -x "${python_bin}" ]; then
    log "Creating dedicated Neovim Python environment at ${NVIM_PYTHON}"
    mkdir --parents "$(dirname "${NVIM_PYTHON}")"
    uv venv --python "${PYTHON_VERSION}" "${NVIM_PYTHON}"
  fi

  log "Installing pip and pynvim into ${NVIM_PYTHON}"
  uv pip install --python "${python_bin}" pip pynvim
}

install_lazygit() {
  if need_cmd lazygit; then
    log "lazygit already on PATH, skipping"
    return 0
  fi

  tag=$(github_latest_tag "jesseduffield/lazygit")
  version=${tag#v}
  asset="lazygit_${version}_Linux_${LAZYGIT_ARCH}.tar.gz"
  log "Installing lazygit ${version}"
  tmpdir=$(mktemp --directory)
  trap 'rm --recursive --force "${tmpdir}"' RETURN
  download "https://github.com/jesseduffield/lazygit/releases/download/${tag}/${asset}" "${tmpdir}/${asset}"
  tar --extract --gzip --file "${tmpdir}/${asset}" --directory "${tmpdir}" lazygit
  install --mode=0755 "${tmpdir}/lazygit" "${LOCAL_BIN}/lazygit"
  trap - RETURN
  rm --recursive --force "${tmpdir}"
}

install_fd() {
  if need_cmd fd || need_cmd fdfind; then
    log "fd already on PATH, skipping"
    return 0
  fi

  tag=$(github_latest_tag "sharkdp/fd")
  version=${tag#v}
  directory="fd-v${version}-${FD_ARCH}-unknown-linux-gnu"
  asset="${directory}.tar.gz"
  log "Installing fd ${version}"
  tmpdir=$(mktemp --directory)
  trap 'rm --recursive --force "${tmpdir}"' RETURN
  download "https://github.com/sharkdp/fd/releases/download/${tag}/${asset}" "${tmpdir}/${asset}"
  tar --extract --gzip --file "${tmpdir}/${asset}" --directory "${tmpdir}" "${directory}/fd"
  install --mode=0755 "${tmpdir}/${directory}/fd" "${LOCAL_BIN}/fd"
  trap - RETURN
  rm --recursive --force "${tmpdir}"
}

install_gdu() {
  if need_cmd gdu || need_cmd gdu-go; then
    log "gdu already on PATH, skipping"
    return 0
  fi

  tag=$(github_latest_tag "dundee/gdu")
  asset="gdu_linux_${GDU_ARCH}.tgz"
  member="gdu_linux_${GDU_ARCH}"
  log "Installing gdu ${tag#v}"
  tmpdir=$(mktemp --directory)
  trap 'rm --recursive --force "${tmpdir}"' RETURN
  download "https://github.com/dundee/gdu/releases/download/${tag}/${asset}" "${tmpdir}/${asset}"
  tar --extract --gzip --file "${tmpdir}/${asset}" --directory "${tmpdir}" "${member}"
  install --mode=0755 "${tmpdir}/${member}" "${LOCAL_BIN}/gdu"
  trap - RETURN
  rm --recursive --force "${tmpdir}"
}

install_btm() {
  if need_cmd btm; then
    log "btm already on PATH, skipping"
    return 0
  fi

  tag=$(github_latest_tag "ClementTsang/bottom")
  asset="bottom_${BTM_ARCH}-unknown-linux-gnu.tar.gz"
  log "Installing bottom ${tag#v}"
  tmpdir=$(mktemp --directory)
  trap 'rm --recursive --force "${tmpdir}"' RETURN
  download "https://github.com/ClementTsang/bottom/releases/download/${tag}/${asset}" "${tmpdir}/${asset}"
  tar --extract --gzip --file "${tmpdir}/${asset}" --directory "${tmpdir}" btm
  install --mode=0755 "${tmpdir}/btm" "${LOCAL_BIN}/btm"
  trap - RETURN
  rm --recursive --force "${tmpdir}"
}

install_mermaid_cli() {
  mermaid_cli="${HOME}/.local/lib/node_modules/@mermaid-js/mermaid-cli/src/cli.js"
  export PUPPETEER_CACHE_DIR="${HOME}/.cache/puppeteer"
  if [ -f "${mermaid_cli}" ]; then
    log "Mermaid CLI already installed, skipping npm install"
  else
    log "Installing Mermaid CLI into ${HOME}/.local"
    npm install --global --prefix "${HOME}/.local" @mermaid-js/mermaid-cli
  fi

  log "Installing the Chrome Headless Shell required by Mermaid CLI"
  puppeteer_cli="${HOME}/.local/lib/node_modules/@mermaid-js/mermaid-cli/node_modules/.bin/puppeteer"
  [ -x "${puppeteer_cli}" ] || die "Mermaid CLI did not install Puppeteer"
  "${puppeteer_cli}" browsers install chrome-headless-shell

  log "Verifying Mermaid rendering"
  tmpdir=$(mktemp --directory)
  trap 'rm --recursive --force "${tmpdir}"' RETURN
  printf '%s\n' 'flowchart LR' '  A[Bootstrap] --> B[Healthy Neovim]' >"${tmpdir}/health.mmd"
  if ! mmdc --input "${tmpdir}/health.mmd" --output "${tmpdir}/health.svg"; then
    log "Mermaid browser sandbox unavailable; installing a local no-sandbox wrapper"
    config_dir="${HOME}/.local/share/mermaid-cli"
    mkdir --parents "${config_dir}"
    printf '%s\n' '{ "args": ["--no-sandbox"] }' >"${config_dir}/puppeteer.json"
    node_bin=$(command -v node)
    rm --force "${LOCAL_BIN}/mmdc"
    cat >"${LOCAL_BIN}/mmdc" <<EOF
#!/usr/bin/env bash
exec "${node_bin}" "${mermaid_cli}" --puppeteerConfigFile "${config_dir}/puppeteer.json" "\$@"
EOF
    chmod 0755 "${LOCAL_BIN}/mmdc"
    mmdc --input "${tmpdir}/health.mmd" --output "${tmpdir}/health.svg"
  fi
  [ -s "${tmpdir}/health.svg" ] || die "mmdc did not render the verification diagram"
  trap - RETURN
  rm --recursive --force "${tmpdir}"
}

install_kitty() {
  kitty_dir="${LOCAL_OPT}/kitty"
  if [ -x "${kitty_dir}/bin/kitty" ]; then
    log "Kitty already installed at ${kitty_dir}, skipping download"
  else
    tag=$(github_latest_tag "kovidgoyal/kitty")
    version=${tag#v}
    asset="kitty-${version}-${KITTY_ARCH}.txz"
    log "Installing Kitty ${version}"
    tmpdir=$(mktemp --directory)
    trap 'rm --recursive --force "${tmpdir}"' RETURN
    download "https://github.com/kovidgoyal/kitty/releases/download/${tag}/${asset}" "${tmpdir}/${asset}"
    rm --recursive --force "${kitty_dir}"
    mkdir --parents "${kitty_dir}"
    tar --extract --xz --file "${tmpdir}/${asset}" --directory "${kitty_dir}"
    trap - RETURN
    rm --recursive --force "${tmpdir}"
  fi

  ln --symbolic --force --no-dereference "${kitty_dir}/bin/kitty" "${LOCAL_BIN}/kitty"
  ln --symbolic --force --no-dereference "${kitty_dir}/bin/kitten" "${LOCAL_BIN}/kitten"

  applications="${HOME}/.local/share/applications"
  mkdir --parents "${applications}"
  awk \
    -v executable="${kitty_dir}/bin/kitty" \
    -v icon="${kitty_dir}/share/icons/hicolor/256x256/apps/kitty.png" \
    '
      /^Exec=kitty/ { sub(/^Exec=kitty/, "Exec=" executable) }
      /^Icon=kitty$/ { $0 = "Icon=" icon }
      { print }
    ' "${kitty_dir}/share/applications/kitty.desktop" >"${applications}/kitty.desktop"
  if need_cmd update-desktop-database; then
    update-desktop-database "${applications}"
  fi
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
  install_lazygit
  install_fd
  install_gdu
  install_btm

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

  desktop=${DESKTOP:-0}
  if [ "${desktop}" = "1" ]; then
    install_mermaid_cli
    install_kitty
  else
    log "Skipping Mermaid CLI and Kitty (set DESKTOP=1 to install)"
  fi
}

detect_arch
log "Installing user-local runtimes into ${HOME}/.local"
install_nvim
install_node
install_uv
install_tools
log "Done. Ensure ${LOCAL_BIN} is on PATH (zshrc already prepends it)."

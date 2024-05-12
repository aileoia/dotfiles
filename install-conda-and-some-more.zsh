# Installs conda and additionnal python packages.

if [ $(uname -m) = "x86_64" ]
then
  NVIM_DL_LINK=https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
elif [ $(uname -m) = "aarch64" ]
then
  NVIM_DL_LINK=https://github.com/matsuu/neovim-aarch64-appimage/releases/download/v0.9.4/nvim-v0.9.4-aarch64.appimage
fi
echo "Download and intall neovim from ${NVIM_DL_LINK}"
wget ${NVIM_DL_LINK} -O ~/.local/bin/nvim
chmod +x ~/.local/bin/nvim

echo "Download an install miniconda"
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-$(uname -m).sh -O miniforge.sh
sh miniforge.sh -b
rm miniforge.sh

source zshrc

echo "Install neovim things"
pip install --user pipx pynvim jedi

conda install -y nodejs
npm install -g neovim

echo "Install a few python based things"
pipx install black
pipx install dvc"[all]"
pipx install flake8
pipx install isort
pipx install pre-commit
pipx install ranger-fm
pipx install ruff
pipx install thefuck
pipx install tox

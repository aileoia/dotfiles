# Installs conda and additionnal python packages.

# Download an install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-$(uname -m).sh -O miniconda.sh
sh miniconda.sh -b
rm miniconda.sh

source zshrc

pip install --user pipx pynvim jedi

conda install -y nodejs
npm install -g neovim

pipx install black
pipx install dvc"[all]"
pipx install flake8
pipx install isort
pipx install pre-commit
pipx install ranger-fm
pipx install ruff
pipx install thefuck
pipx install tox

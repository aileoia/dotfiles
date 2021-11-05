# Installs conda and additionnal python packages.

# Download an install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b
rm Miniconda3-latest-Linux-x86_64.sh

source zshrc

pip install --user pipx
pipx install dvc"[all]"
pipx install black
pipx install flake8
pipx install isort
pipx install pre-commit
pipx install tox

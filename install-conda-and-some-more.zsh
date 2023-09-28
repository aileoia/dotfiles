# Installs conda and additionnal python packages.

# Download an install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b
rm Miniconda3-latest-Linux-x86_64.sh

source zshrc

pip install --user pipx pynvim jedi
pipx install black
pipx install dvc"[all]"
pipx install flake8
pipx install isort
pipx install pre-commit
pipx install ranger-fm
pipx install thefuck
pipx install tox

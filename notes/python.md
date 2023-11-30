`pyenv` is a bit of a hassle to install using `nix` (see [this discourse.nixos thread](https://discourse.nixos.org/t/how-to-pyenv-install-or-equivalent/14235) and [this blog post](https://semyonsinchenko.github.io/ssinchenko/post/using-pyenv-with-nixos/)).

Instead, I chose to install globally a native `python3*` package from `nixpkgs`, and then use `direnv` to automatically
create and activate a `virtualenv` in the directories of my choice, by adding the following lines to the `.envrc` of the directory:
```bash
export VIRTUAL_ENV=".direnv/my-venv-name"
layout python
```
(see [direnv's wiki](https://github.com/direnv/direnv/wiki/Python#venv-stdlib-module) for more information)

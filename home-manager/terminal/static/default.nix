{
  config,
  pkgs,
  lib,
  ...
}: {
  home.file.".config/ipython/profile_default/ipython_config.py".text =
    /*
    python
    */
    ''
      c = get_config()

      c.InteractiveShellApp.extensions = ['autoreload']
      c.InteractiveShellApp.exec_lines = ['%autoreload 2']
    '';

  home.file.".config/nvim/ftplugin/hcl.lua".text =
    /*
    lua
    */
    ''
      vim.bo.commentstring="# %s"
    '';

  home.file.".config/ruff/pyproject.toml".text =
    /*
    toml
    */
    ''
      [tool.ruff]
      line-length = 120
      # Select: Flake rules (E, F, W), isort (I)
      select = ["E", "F", "W", "I"]
    '';

  home.file.".config/stylua.toml".text =
    /*
    toml
    */
    ''
      indent_type = "Spaces"
      indent_width = 2
    '';

  home.file.".bin/fif" = {
    executable = true;
    source = ./fif;
  };
}

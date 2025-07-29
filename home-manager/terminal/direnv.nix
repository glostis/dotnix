{
  config,
  pkgs,
  ...
}: {
  programs.direnv = {
    enable = true;
    stdlib =
      /*
      bash
      */
      ''
        # Taken from https://github.com/direnv/direnv/wiki/Python#poetry
        layout_poetry() {
            PYPROJECT_TOML="''${PYPROJECT_TOML:-pyproject.toml}"
            if [[ ! -f "$PYPROJECT_TOML" ]]; then
                log_status "No pyproject.toml found."
            fi

            if [[ -d ".venv" ]]; then
                VIRTUAL_ENV="$(pwd)/.venv"
            else
                VIRTUAL_ENV=$(poetry env info --path 2>/dev/null ; true)
            fi

            if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
                log_status "No virtual environment exists. Executing \`poetry install\` to create one."
                poetry install
                VIRTUAL_ENV=$(poetry env info --path)
            fi

            PATH_add "$VIRTUAL_ENV/bin"
            export POETRY_ACTIVE=1
            export VIRTUAL_ENV
        }

        # Taken from https://github.com/direnv/direnv/wiki/Python#uv
        layout_uv() {
            if [[ -d ".venv" ]]; then
                VIRTUAL_ENV="$(pwd)/.venv"
            fi

            if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
                log_status "No virtual environment exists. Executing \`uv venv\` to create one."
                uv venv
                VIRTUAL_ENV="$(pwd)/.venv"
            fi

            PATH_add "$VIRTUAL_ENV/bin"
            export UV_ACTIVE=1  # or VENV_ACTIVE=1
            export VIRTUAL_ENV
        }

        # Taken from https://github.com/direnv/direnv/issues/73#issuecomment-152284914
        export_function() {
            local name=$1
            local alias_dir=$PWD/.direnv/aliases
            mkdir -p "$alias_dir"
            PATH_add "$alias_dir"
            local target="$alias_dir/$name"
            if declare -f "$name" >/dev/null; then
              echo "#!/usr/bin/env bash" > "$target"
              declare -f "$name" >> "$target" 2>/dev/null
              echo "$name" >> "$target"
              chmod +x "$target"
            fi
        }
      '';
  };
}

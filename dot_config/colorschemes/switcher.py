import os
from pathlib import Path
import re
import subprocess

import yaml


def apply_alacritty(theme):
    path = os.path.expanduser("~/.config/alacritty/alacritty.yml")
    with open(path) as f:
        lines = f.readlines()
    regex = re.compile(r"^colors: \*.*$")
    with open(path, "w") as f:
        for line in lines:
            f.write(re.sub(regex, f"colors: *{theme}", line))


def apply_dunst(theme):
    if theme.split("-")[-1] == "dark":
        new_theme = "dark"
        old_theme = "light"
    else:
        new_theme = "light"
        old_theme = "dark"

    path = os.path.expanduser("~/.config/dunst/dunstrc")
    with open(path) as f:
        lines = f.readlines()
    to_comment = re.compile(fr"^([ ]*)(.*  # color {old_theme})$")
    to_uncomment = re.compile(fr"^([ ]*)# (.*  # color {new_theme})$")
    with open(path, "w") as f:
        for line in lines:
            if to_comment.match(line):
                f.write(to_comment.sub(fr"\1# \2", line))
            elif to_uncomment.match(line):
                f.write(to_uncomment.sub(fr"\1\2", line))
            else:
                f.write(line)
    subprocess.run("(pgrep dunst && killall dunst) || true", shell=True, check=True)


def apply_rofi(theme):
    path = os.path.expanduser("~/.config/rofi/config.rasi")
    with open(path) as f:
        lines = f.readlines()
    regex = re.compile(r'".*\.rasi"')
    with open(path, "w") as f:
        for line in lines:
            f.write(re.sub(regex, f'"{theme}.rasi"', line))


def apply_gtk(theme):
    path = os.path.expanduser("~/.config/gtk-3.0/settings.ini")
    with open(path) as f:
        lines = f.readlines()
    if theme.split("-")[-1] == "dark":
        b = "true"
    else:
        b = "false"
    regex = re.compile(r"^gtk-application-prefer-dark-theme = .*$")
    with open(path, "w") as f:
        for line in lines:
            f.write(re.sub(regex, f"gtk-application-prefer-dark-theme = {b}", line))
    subprocess.run("(pgrep 1password && killall 1password) || true", shell=True, check=True)


def apply_i3_polybar(theme):
    # Update the symlink to ~/.Xresources
    theme = theme.split("-")[-1]  # "dark" or "light"
    resources_path = os.path.expanduser(f"~/.config/colorschemes/Xresources-{theme}")
    symlink_path = os.path.expanduser("~/.Xresources")
    if os.path.exists(symlink_path):
        os.unlink(symlink_path)
    os.symlink(resources_path, symlink_path)

    # Relaunch xrdb and i3
    subprocess.run("xrdb ~/.Xresources && i3-msg reload", shell=True, check=True)

    # The polybar bars are launched using `--reload` which auto-reloads them when the
    # config changes, so touching the config to "change" it
    Path("~/.config/polybar/config.ini").expanduser().touch()


def apply_neovim():
    subprocess.run("(pgrep nvim && killall -USR1 nvim) || true", shell=True, check=True)


def apply_tmux():
    subprocess.run(
        ["tmux", "source-file", os.path.expanduser("~/.config/tmux/tmux.conf")],
        check=True,
    )


def apply_qutebrowser():
    subprocess.run(
        "(pgrep -f qutebrowser && qutebrowser :restart) || true", shell=True, check=True
    )


def main():
    alacritty_yaml = os.path.expanduser("~/.config/alacritty/alacritty.yml")
    with open(alacritty_yaml) as f:
        y = yaml.load(f.read(), Loader=yaml.Loader)

    with open(alacritty_yaml) as f:
        lines = f.readlines()

    regex = re.compile(r"^colors: \*(.*)$")
    for line in lines:
        if m := regex.search(line):
            current_theme = m.group(1)
            break

    themes = set(y["schemes"].keys())
    new_theme = (themes - set((current_theme,))).pop()

    colors = y["schemes"][new_theme]

    apply_alacritty(new_theme)
    apply_i3_polybar(new_theme)
    apply_dunst(new_theme)
    apply_rofi(new_theme)
    apply_gtk(new_theme)
    apply_neovim()
    apply_tmux()
    # apply_qutebrowser()


if __name__ == "__main__":
    main()

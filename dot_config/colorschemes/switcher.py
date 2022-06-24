import os
import re
import subprocess

import yaml


def apply_polybar(colors):
    polybar_colors = f"""
    background = #{colors['primary']['background'].lstrip('#')}
    background-alt = #{colors['primary']['background-alt'].lstrip('#')}
    foreground = {colors['primary']['foreground']}
    red = {colors['normal']['red']}
    green = {colors['normal']['green']}
    yellow = {colors['normal']['yellow']}
    blue = {colors['normal']['blue']}
    magenta = {colors['normal']['magenta']}
    cyan = {colors['normal']['cyan']}
    """

    with open(os.path.expanduser("~/.config/polybar/colors"), "w") as f:
        f.write(polybar_colors)
    subprocess.run([os.path.expanduser("~/.config/polybar/launch.sh")])


def apply_alacritty(theme):
    path = os.path.expanduser("~/.config/alacritty/alacritty.yml")
    with open(path) as f:
        lines = f.readlines()
    regex = re.compile(r"^colors: \*.*$")
    with open(path, "w") as f:
        for line in lines:
            f.write(re.sub(regex, f"colors: *{theme}", line))


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

    apply_polybar(colors)
    apply_alacritty(new_theme)
    apply_rofi(new_theme)
    apply_gtk(new_theme)
    apply_neovim()
    apply_tmux()
    apply_qutebrowser()


if __name__ == "__main__":
    main()

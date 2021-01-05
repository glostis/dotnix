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
    subprocess.run([os.path.expanduser("~/.config/polybar/launch.sh")], check=True)


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


def apply_neovim():
    subprocess.run("(pgrep nvim && killall -USR1 nvim) || true", shell=True, check=True)


def apply_tmux():
    subprocess.run(["tmux", "source-file", os.path.expanduser("~/.config/tmux/tmux.conf")], check=True)


def apply_qutebrowser():
    subprocess.run("(pgrep -f qutebrowser && qutebrowser :restart) || true", shell=True, check=True)


def main():
    alacritty_yaml = os.path.expanduser("~/.config/alacritty/alacritty.yml")
    with open(alacritty_yaml) as f:
        y = yaml.load(f.read(), Loader=yaml.Loader)

    themes = set(y["schemes"].keys())
    p = subprocess.run(
        ["rofi", "-dmenu", "-i", "-hide-scrollbar", "-lines", str(len(themes)), "-p", "Theme"],
        capture_output=True,
        check=True,
        input="\n".join(themes),
        text=True,
    )
    theme = p.stdout.strip()
    assert theme in themes

    colors = y["schemes"][theme]

    apply_polybar(colors)
    apply_alacritty(theme)
    apply_rofi(theme)
    # apply_neovim()
    apply_tmux()
    # apply_qutebrowser()


if __name__ == "__main__":
    main()

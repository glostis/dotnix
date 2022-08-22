# Setup
To setup Firefox:

- Create 2 profiles by going to `about:profiles`
    - One named `perso` linked to my personal Firefox account
    - One named `work` linked to my work Firefox account
    - Set the preferred one as default profile
- Log in to the respective Firefox accounts and activate sync, which should restore all settings / extensions
- Run `:source` to setup Tridactyl

# Customization

Firefox is highly customizable:
- The interface can be styled using a per-profile `userChrome.css`
- The settings can be changed, either:
    - By using the GUI and checking some boxes → only gives access to a limited number of options
    - By using the `about:config` page
    - By using a pre-profile `user.js` that sets the options of `about:config`, and that is read at start-up.

I've settled on a semi-manual mechanism to track changes to the `userChrome.css` and `user.js` files using `chezmoi`:
1. The files `~/.mozilla/firefox/dummy_profile/{user.js,chrome/userChrome.css}` are tracked normally using `chezmoi`
2. Some symlinks from these files to the files in the "real" Firefox profiles need to be set

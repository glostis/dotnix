# Setup
To setup Firefox:

- Create 2 profiles by going to `about:profiles`
    - One named `perso` linked to my personal Firefox account, in the folder `~/.mozilla/firefox/profile-perso/`
    - One named `work` linked to my work Firefox account, in the folder `~/.mozilla/firefox/profile-work/`
    - Set the preferred one as default profile
- Log in to the respective Firefox accounts and activate sync, which should restore all settings / extensions

# Customization

Firefox is highly customizable:
- The interface can be styled using a per-profile `userChrome.css`
- The webpages can be styled using a per-profile `userContent.css`
- The settings can be changed, either:
    - By using the GUI and checking some boxes → only gives access to a limited number of options
    - By using the `about:config` page
    - By using a pre-profile `user.js` that sets the options of `about:config`, and that is read at start-up.

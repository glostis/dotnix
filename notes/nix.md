```bash
hm expire-generations -2days
nix-collect-garbage --delete-older-than 2d
nix store gc
```

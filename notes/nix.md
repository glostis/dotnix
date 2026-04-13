```bash
hm expire-generations -2days
nix-collect-garbage --delete-older-than 2d
nix store gc
```

Check [nixpkgs PR tracker](https://nixpk.gs/pr-tracker.html) to see when a merged PR will land on nixos-unstable.

If you get rate limited by the Github API at some point, you can provide a personal Github token in the `nix` CLI you are running by adding the flag:

```
--option access-tokens "github.com=$(gh auth token)"
```

(taken from [nix issue comment](https://github.com/NixOS/nix/issues/4653#issuecomment-3046777152))

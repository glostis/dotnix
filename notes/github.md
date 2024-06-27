# How to juggle between two Github accounts on a local machine

## Setting the local committer

A different "user" can be set for all repos under a given directory by following
[this blog post](https://dev.to/equiman/how-to-use-multiple-users-with-git-2e9l).

In `~/.config/git/config`:
```toml
[includeIf "gitdir/i:~/code-work/"]
	path = ~/code-work/.gitconfig
[includeIf "gitdir/i:~/code-perso/"]
	path = ~/code-perso/.gitconfig
```

In `~/code-*/.gitconfig`:
```toml
[user]
	name = <My Name>
	email = <My work/personal email>
```

## Switching between two different SSH key pairs

This relies on the `GIT_SSH_COMMAND` environment variable, or the `core.sshCommand` git configuration, which can be set
to `ssh -i PATH/TO/PRIVATEKEY/FILE -o IdentitiesOnly=yes -F /dev/null` in order to use a non-default SSH key pair.
(`-F /dev/null` makes sure that `ssh` does not go and look into `~/.ssh/config` to find other identities to
authenticate with)

See [StackOverflow](https://stackoverflow.com/a/38474137) for reference.

The above snippet can therefore be extended with `~/code-*/.gitconfig`:
```toml
[core]
    sshCommand = ssh -i PATH/TO/PRIVATEKEY/FILE -o IdentitiesOnly=yes -F /dev/null
```

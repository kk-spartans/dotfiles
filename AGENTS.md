Don't edit /etc/nixos.

When making a PR: you're already in a new blank branch that's only for you, don't make a new branch and then a PR. When you're done make a PR.

If I ask you to make a PR, just output a command I can run in a code block (not snippet):
`sudo nixos-rebuild switch --flake github:kk-spartans/dotfiles/<branch>#kk-spartans`
(or #mac-pro if this is a change related to it).

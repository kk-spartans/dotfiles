# Dotfiles

Most of the stuff that seems weird is probably explained in the comments. I'm very new to nix, and am probably doing stuff wrong. My config options are variables in my flake:

- `pc`: whether to install hyprland and gui (or gui-related) apps. If you see something that could work on a headless machine here, it's probably because I don't use it on headless machines.
- `laptop`: installs hyprlock, configuring battery stuff, etc.
- `nvidia`: installs nvidia drivers, etc. I usually flick this one on and off depending on whether I like battery life.

Make sure to add the aw-watcher-lastfm config file, and tailscale authkey in `/etc/secrets`

My old (windows/ubuntu server) dotfiles are at `chezmoi`. Just run `chezmoi init kk-spartans` to get them. If someone opens an issue about it, I'll probably fix it. But otherwise, it's unmaintained.

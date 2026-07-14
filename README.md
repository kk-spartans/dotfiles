# Dotfiles

Most of the stuff that seems weird is probably explained in the comments. I'm very new to nix, and am probably doing stuff wrong. My config options are variables in my flake:

- `pc`: whether to install hyprland and gui (or gui-related) apps. If you see something that could work on a headless machine here, it's probably because I don't use it on headless machines.
- `laptop`: installs hyprlock, configuring battery stuff, etc.
- `gpu`: selects dedicated GPU support (`"amd"`, `"amd-si"`, `"nvidia"`, `"intel"`, or `"none"`). `"amd-si"` is for first-gen GCN / Southern Islands cards, like the late 2013 Mac Pro FirePro D-series GPUs. I usually flick this between `"nvidia"` and `"none"` depending on whether I like battery life.

My old (windows/ubuntu server) dotfiles are at `chezmoi`. If someone opens an issue about it, I'll probably fix it. But otherwise, it's unmaintained.

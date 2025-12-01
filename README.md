# 1444's dotfiles

> [!IMPORTANT]
> This repository has been migrated to [codeberg](https://codeberg.org/einetuer/dotfiles)

Welcome to my home! This is my nixos configuration, most notably including:

- river
- wayfire (dead)
- hyprland (dead)
- fish
- nixvim
- stylix
- a bunch of smaller things like waybar, \[rt\]ofi, etc
- all my wifi passwords? whoops! oh wait, theyre sops encrypted

The code is well structured and readable, but is not intended to be drop-in. I extend `lib` and depend
on pretty specific `specialArgs` (e.g. `inputs` and `outputs`), so don't expect to be able to use this repo
as an input to your configuration. Feel free to copy-paste though!

I started maintaining this repo a few months after getting into linux, so if you (or I, for nostalgic purposes) look at the commit history, we can pretty much see my entire linux journey! Isn't that great?

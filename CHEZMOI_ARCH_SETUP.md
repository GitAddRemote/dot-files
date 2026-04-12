# Arch chezmoi setup — session context

## Current state on Arch machine
- chezmoi installed fresh via pacman
- dot-files repo cloned to `~/Documents/project/dot-files`
- `~/.config/chezmoi/chezmoi.toml` manually created — contains `[data.platform]` with `family = "linux"`, `variant = "arch"`
- `sourceDir` may still need to be added to chezmoi.toml
- `chezmoi diff` was run and showed a large number of changes
- `chezmoi apply` has NOT been run yet

## First thing to verify
Make sure `~/.config/chezmoi/chezmoi.toml` looks like this:

```toml
sourceDir = "/home/hezeqiah/Documents/project/dot-files"

[data.platform]
family = "linux"
variant = "arch"
```

## Next steps
1. Confirm chezmoi.toml has `sourceDir` at the top
2. Optionally back up existing configs: `cp -r ~/.config ~/.config.bak`
3. Review `chezmoi diff` output carefully
4. Apply cautiously — target-by-target first given unknown Arch drift:
   `chezmoi apply ~/.tmux.conf ~/.config/ghostty ~/.config/nvim ~/.config/starship.toml`
   Or all at once: `chezmoi apply`
5. Open tmux, Ghostty, nvim — run `:Lazy sync` in nvim
6. Any Arch-specific tweaks found should go back into the repo as templates using `.platform.variant == "arch"`

## Delete this file after setup is complete

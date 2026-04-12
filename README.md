# dot-files

This repo is now a `chezmoi` source repo.

The actual `chezmoi` source root lives in [`home/`](./home) via [`.chezmoiroot`](./.chezmoiroot). That lets the repo keep normal project files like this README and bootstrap scripts at the top level without accidentally targeting `$HOME`.

## Install

Install `chezmoi` with your package manager:

- macOS: `brew install chezmoi`
- Arch: `sudo pacman -S chezmoi`
- Fedora: `sudo dnf install chezmoi`

Or use the helper script in this repo:

```bash
./scripts/bootstrap.sh
```

## Apply From This Checkout

From the repo root:

```bash
chezmoi -S "$PWD" diff
chezmoi -S "$PWD" apply
```

`-S "$PWD"` tells `chezmoi` to use this checkout as the source directory. `chezmoi` will then read [`.chezmoiroot`](./.chezmoiroot) and use `home/` as the managed source state.

## New Machine

After the repo is pushed, a new machine can be bootstrapped with:

```bash
chezmoi init --apply <repo-url>
```

Or by cloning this repo and running:

```bash
./scripts/bootstrap.sh
```

## Workflow

1. Edit files under `home/`.
2. Preview changes with `chezmoi -S "$PWD" diff`.
3. Apply changes with `chezmoi -S "$PWD" apply`.
4. Test the live config.
5. Commit and push.

This repo is the source of truth. Do not edit `~/.config/*` or `~/.tmux.conf` directly unless you are immediately bringing those changes back into `home/`.

## Notes

- Tmux plugins are no longer vendored in the repo. They are managed via [`.chezmoiexternal.toml`](./home/.chezmoiexternal.toml).
- The active managed targets are:
  - `~/.tmux.conf`
  - `~/.config/ghostty`
  - `~/.config/nvim`
  - `~/.config/starship.toml`

## Template Data

This repo also defines normalized template data in [`.chezmoi.toml.tmpl`](./.chezmoi.toml.tmpl):

- `.platform.family`
  - `macos`
  - `linux`
- `.platform.variant`
  - `macos`
  - `arch`
  - `fedora`
  - fallback `linux`

This keeps templates readable. For example, the Ghostty config template uses:

```tmpl
{{ if eq .platform.family "macos" -}}
background-blur-radius = 15
{{ end -}}
```

And a distro-specific Linux template can use:

```tmpl
{{ if eq .platform.variant "arch" -}}
# Arch-only settings here
{{ else if eq .platform.variant "fedora" -}}
# Fedora-only settings here
{{ end -}}
```

To inspect the current resolved values on a machine, run:

```bash
chezmoi -S "$PWD" data
```

#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

install_chezmoi() {
  if command -v chezmoi >/dev/null 2>&1; then
    return
  fi

  if command -v brew >/dev/null 2>&1; then
    brew install chezmoi
    return
  fi

  if command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed chezmoi
    return
  fi

  if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y chezmoi
    return
  fi

  echo "chezmoi is not installed and no supported package manager was found." >&2
  echo "Install chezmoi manually, then run: chezmoi -S \"$repo_root\" apply" >&2
  exit 1
}

install_chezmoi
chezmoi -S "$repo_root" apply

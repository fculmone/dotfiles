#!/usr/bin/env bash
# Symlink dotfiles into $HOME. Idempotent — safe to re-run.
#
# Portable by design:
#   * POSIX-ish bash, no bash 4+ features (macOS ships bash 3.2)
#   * entries absent from this repo are skipped, so adding a config is
#     "drop the file in + add one `link` line"
#   * shell-agnostic: zsh and bash rc files are both handled if present
set -euo pipefail
cd "$(dirname "$0")"
DOTFILES="$PWD"

link() {
  rel="$1"; name="$2"
  src="$DOTFILES/$rel"; dst="$HOME/$name"

  if [ ! -e "$src" ]; then
    echo "skip    $name  (not in this repo yet)"
    return 0
  fi
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok      $name"
    return 0
  fi
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak-$(date +%Y%m%d-%H%M%S)"
    echo "backup  $name -> $name.bak-*"
  fi
  ln -sfn "$src" "$dst"
  echo "link    $name"
}

# Secrets / per-machine values never live in git. Only create the sidecar for
# an rc file this repo actually manages, so a bash-only box (WSL) doesn't get a
# stray ~/.zshrc.local and vice versa.
local_sidecar() {
  rel="$1"; name="$2"
  [ -e "$DOTFILES/$rel" ] || return 0
  [ -f "$HOME/$name" ] && return 0
  printf '# Machine-local shell config. NEVER commit this file.\n' > "$HOME/$name"
  chmod 600 "$HOME/$name"
  echo "create  ~/$name  (put secrets here)"
}

link tmux/.tmux.conf .tmux.conf
link zsh/.zshrc      .zshrc       # not tracked yet
link bash/.bashrc    .bashrc      # not tracked yet

local_sidecar zsh/.zshrc  .zshrc.local
local_sidecar bash/.bashrc .bashrc.local

# Neovim config is a separate repo.
if [ ! -d "$HOME/.config/nvim" ]; then
  if command -v git >/dev/null 2>&1; then
    git clone https://github.com/fculmone/nvim-config.git "$HOME/.config/nvim"
    echo "clone   ~/.config/nvim"
  else
    echo "skip    ~/.config/nvim  (git not installed)"
  fi
fi

echo "done."

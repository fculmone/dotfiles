# dotfiles

Portable terminal config. Works on macOS, Linux, and WSL.

## Install

```sh
git clone https://github.com/fculmone/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` symlinks each tracked file into `$HOME`, backs up anything real it
would clobber, and is safe to re-run. It targets bash 3.2 (what macOS ships),
so it runs anywhere. Entries not yet in the repo are skipped — adding a config
is: drop the file in, add one `link` line.

## What's here

| Path | Notes |
|---|---|
| `tmux/.tmux.conf` | truecolor, extended keys, pane-aware mouse, vi copy mode |

Deliberately **not** set: prefix stays `C-b`, and there are no pane-navigation
bindings — Neovim already owns `<C-h/j/k/l>` for window navigation, so binding
the same keys in tmux would shadow it.

Planned: `zsh/.zshrc`, `bash/.bashrc`. `install.sh` already handles both and
skips them until they exist.

## Portability notes

* **Clipboard** is resolved at tmux config load — `pbcopy` on macOS,
  `clip.exe` on WSL, `wl-copy`/`xclip` on Linux. `set-clipboard on` also emits
  OSC 52 so copy works over SSH.
* **Shell-agnostic**: zsh and bash rc files are separate entries. A bash-only
  box only gets `~/.bashrc.local`; a zsh box only gets `~/.zshrc.local`.

## Secrets

Nothing secret is committed. API tokens and machine-specific values go in
`~/.zshrc.local` / `~/.bashrc.local` — gitignored, sourced from the rc file:

```sh
export SOME_API_TOKEN="..."
```

## Related

Neovim config is its own repo (kickstart.nvim fork, so it can track upstream):
<https://github.com/fculmone/nvim-config>

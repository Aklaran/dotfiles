---
name: zellij-navigation
description: Navigate and manage Zellij sessions, tabs, panes, and layouts. Use when working inside Zellij or when asked to move between panes/tabs, create splits, open floating panes, resize or rename panes, inspect the current layout, or coach someone through default Zellij keybindings.
---

# Zellij Navigation

Prefer the `zellij action ...` CLI when you can directly manipulate a live Zellij session. Use keybindings when the user wants interactive guidance.

## 0. Check context first

```bash
printenv ZELLIJ ZELLIJ_SESSION_NAME
zellij list-sessions -s
```

- If already inside Zellij, `zellij action ...` targets the current session.
- If outside Zellij, target a specific session with `zellij --session <name> action ...`.
- If no session exists yet, create one with `zellij attach -c <name>`.

## 1. Inspect before changing layout

```bash
zellij action list-tabs --json --all
zellij action list-panes --json --all
zellij action dump-layout
```

Use these before larger changes or when the user asks what is currently open.

## 2. Common pane actions

```bash
zellij action new-pane
zellij action new-pane -d right
zellij action new-pane -d down
zellij action new-pane -- <command>...
zellij action new-pane -f --width 60% --height 60% --x 20% --y 20% -- <command>...
zellij action move-focus left
zellij action move-focus right
zellij action move-focus up
zellij action move-focus down
zellij action resize increase right
zellij action resize decrease left
zellij action toggle-fullscreen
zellij action toggle-floating-panes
zellij action toggle-pane-embed-or-floating
zellij action close-pane
zellij action rename-pane "<name>"
```

Notes:
- Use floating panes for temporary tools, logs, and one-off commands.
- Use `new-pane -- <command>...` when you want a pane to open already running something.

## 3. Common tab actions

```bash
zellij action new-tab
zellij action new-tab -n logs
zellij action new-tab -l <layout> -n scratch
zellij action new-tab -- <command>...
zellij action go-to-next-tab
zellij action go-to-previous-tab
zellij action go-to-tab 2
zellij action rename-tab "<name>"
zellij action close-tab
zellij action next-swap-layout
zellij action previous-swap-layout
```

Notes:
- `go-to-tab` is index-based and works well for deterministic jumps.
- `new-tab -l <layout>` is the cleanest way to apply a known layout to a fresh tab.

## 4. Session actions

```bash
zellij attach -c work
zellij list-sessions -s
zellij action detach
zellij kill-session work
```

## 5. Default keybindings cheat sheet

These are the defaults from Zellij 0.44.0. User config may override them.

### Mode switches

- `Ctrl-p`: pane mode
- `Ctrl-t`: tab mode
- `Ctrl-n`: resize mode
- `Ctrl-h`: move mode
- `Ctrl-s`: scroll mode
- `Ctrl-o`: session mode
- `Ctrl-b`: tmux mode

### Pane mode (`Ctrl-p`)

- `h/j/k/l`: move focus
- `n`: new pane
- `d`: split down
- `r`: split right
- `s`: stacked pane
- `x`: close pane
- `f`: fullscreen
- `w`: toggle floating panes
- `e`: embed <-> floating
- `c`: rename pane

### Tab mode (`Ctrl-t`)

- `n`: new tab
- `h` or `k`: previous tab
- `l` or `j`: next tab
- `1..9`: jump to tab
- `r`: rename tab
- `x`: close tab

### Move mode (`Ctrl-h`)

- `h/j/k/l`: move pane

### Resize mode (`Ctrl-n`)

- `h/j/k/l`: resize toward that edge
- `=` or `+`: grow
- `-`: shrink

### Session mode (`Ctrl-o`)

- `d`: detach

### Tmux mode (`Ctrl-b`)

- `"`: split down
- `%`: split right
- `c`: new tab
- `x`: close pane
- `z`: fullscreen
- `n` / `p`: next / previous tab
- arrows or `h/j/k/l`: move focus
- `[`: scroll mode

## 6. Good operating pattern

1. Inspect with `list-tabs` and `list-panes`.
2. Make one layout change at a time.
3. Rename important panes and tabs immediately.
4. Use floating panes for transient work.
5. Capture useful layouts for reuse:

```bash
zellij action dump-layout > /tmp/current-layout.kdl
```

## 7. Caveats

```bash
zellij setup --check
zellij setup --dump-config
```

- Default keybindings may be overridden by the user's config.
- Prefer CLI actions for deterministic automation.
- Prefer keybinding guidance when coaching the user live inside Zellij.

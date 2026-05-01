# dotfiles

This repository contains my personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/), and designed for seamless use across local, containerized, and cloud development environments. It is structured to work out-of-the-box with:

- **chezmoi**: For dotfile management and templating
- **DevPod**: For reproducible development environments
- **VS Code Dev Containers**: For local and remote container-based development
- **GitHub Codespaces**: For cloud-based development

---

## Repository Structure

```
├── .chezmoi.toml.tmpl         # chezmoi configuration (templated)
├── .chezmoiexternals/         # chezmoi-managed external resources (tools, fonts, configs)
├── .chezmoiscripts/           # chezmoi hook scripts (e.g., install packages)
├── .devcontainer/             # VS Code Dev Container config (Dockerfile, devcontainer.json)
├── dot_*                      # Dotfiles (bashrc, gitconfig, tmux, wezterm, zshrc, etc.)
├── dot_config/                # XDG config files (alacritty, git, k9s, mise, nvim, starship, zellij)
├── private_dot_gnupg/         # Private GPG config (not tracked by chezmoi)
├── setup                      # Bootstrap script for new machines
```

---

## Usage

### 1. Bootstrapping (Any Environment)

Clone the repo and run the setup script:

```sh
./setup
```

This will:
- Bootstrap Git identity into `~/.gitconfig.local`
- Generate `~/.ssh/id_ed25519` if missing and optionally upload it to GitHub via `gh`
- Install chezmoi (if not present)
- Apply all dotfiles to your home directory
- Ensure a compatible user-local `mise` is available when the current environment ships an older version (for example, repo-specific devcontainers)
- Install Pi via `mise`
- Configure Pi to install `sirdar` as a package on first startup
- Remove stale legacy Pi extension directories (`pi-diff-ui`, `sirdar`, `orchestrator`) if they exist from the old bootstrap pattern

### 2. chezmoi

chezmoi manages all dotfiles, templates, and external resources. It detects if you are running in a remote/container/Codespaces environment and adapts accordingly (see `.chezmoi.toml.tmpl`).

- **chezmoi apply**: Apply dotfiles to your home directory
- **chezmoi update**: Pull and apply latest changes

### 3. DevPod

DevPod is supported via `.chezmoiexternals/devpod.toml`, which ensures the DevPod binary is installed and available in your environment.

On the host, `dot_zshrc.tmpl` defines a `devpod()` shell wrapper that injects sensible defaults into every `devpod up`, each only if you didn't already pass it explicitly:

| Auto-injected flag | Purpose | Source |
|---|---|---|
| `--ide none` | Don't auto-launch openvscode in the browser | hardcoded — pass `--ide openvscode` to override |
| `--dotfiles $DOTFILES_REPO_URL` | Bootstrap every devpod with this repo | `git@github.com:aklaran/dotfiles` |
| `--mount` for `~/repos/obsidian-vault` | Bind-mount Obsidian vault to `/obsidian` (symlinked to `~/Obsidian` inside) | only if the vault dir exists on host |
| `--mount` for `~/.pi/agent/auth.json` | Share pi login token; sessions stay devpod-local | only if file exists on host |
| `--mount` for `~/.claude/.credentials.json`, `~/.claude.json`, `~/.claude/CLAUDE.md` | Share Claude Code login + user memory; sessions/policy-limits/backups stay devpod-local | each only if present |
| `--workspace-env DOTFILES_GIT_NAME` / `DOTFILES_GIT_EMAIL` | Forward host git identity so `setup` runs non-interactively in the devpod | read from `~/.gitconfig.local` (or `--global`) |

Which means: log in to pi / Claude Code once on the host, and every existing + future devpod inherits the auth. Same for git identity.

#### Existing devpods

New bind mounts only take effect on container (re)create. To pick up the auth/vault mounts on a workspace that already exists:

```sh
devpod up --recreate <workspace>
```

This rebuilds the container around the persistent home volume — installed tooling and your `setup` results survive.

#### Obsidian vault

To enable the auto-mount, create a git-backed vault at `~/repos/obsidian-vault`:

```sh
mkdir -p ~/repos/obsidian-vault && cd ~/repos/obsidian-vault
git init -b main
cat > .gitignore <<'EOF'
.obsidian/workspace*.json
.obsidian/cache
.trash/
EOF
git add -A && git commit -m "init vault"
gh repo create obsidian-vault --private --source=. --push
```

Open the folder once in Obsidian.app on your Mac, then enable the **Obsidian Git** community plugin with auto-pull on startup + auto-commit/push on an interval. Inside any devpod the vault is at `~/Obsidian` with an `obs` alias to jump there. Agents can `cd $OBSIDIAN_VAULT && git pull/commit/push` using the forwarded SSH agent.

#### Trust caveats for the auth mounts

- Anything inside a devpod can read your pi / Claude tokens (same posture as your forwarded SSH agent). Fine for personal repos; reconsider for someone else's devpod.
- Only auth files (and Claude's `CLAUDE.md` user memory) are shared. Sessions, extensions, policy-limits, and per-machine state are NOT mounted, so two devpods can run concurrent agent sessions without races.
- Auth files are single-file bind mounts; if either app ever switches to atomic-rename writes the in-container view will go stale (you'd see "logged out" inside the devpod). Recover by recreating the container or, as a workaround, removing the affected line from the wrapper and re-logging in per devpod.
- `~/.claude.json` also contains project history; sharing it means your Mac's repo paths show up in `claude --resume` lists inside devpods. Mostly cosmetic.
- Per-agent memory: pi has no first-party memory — save anything you want to remember to the mounted Obsidian vault. Claude Code's user-level memory lives in `~/.claude/CLAUDE.md` and is shared via the wrapper.

### 4. VS Code Dev Containers

- The `.devcontainer/` folder contains a `devcontainer.json` and a Debian-based `Dockerfile` with `mise` preinstalled.
- Open the repo in VS Code and "Reopen in Container" to get a fully provisioned environment with all tools and dotfiles.

### 5. GitHub Codespaces

- This repo is Codespaces-ready. Just "Open in Codespaces" on GitHub and all dotfiles, tools, and configs will be provisioned automatically.

---

## Highlights

- **Shells**: zsh (default), bash
- **Prompt**: [starship](https://starship.rs/) with custom theme
- **Editor**: [Neovim](https://neovim.io/) (LazyVim-based), with plugins and extras
- **Terminal**: [WezTerm](https://wezfurlong.org/wezterm/), [alacritty](https://alacritty.org/)
- **Multiplexers**: tmux, zellij
- **Tools**: Managed with [mise](https://mise.jdx.dev/) (see `.config/mise/mise.toml`)
- **AI tooling**: Pi is installed via `mise`, with `sirdar` configured as a Pi package source
- **Kubernetes**: k9s with custom skin
- **Fonts**: DepartureMono (auto-installed)

---

## First-Apply Review Checklist

Before applying this repo to a new machine, review these files for identity- or host-specific behavior:

- `dot_gitconfig` — shared Git defaults; identity is intentionally split into `~/.gitconfig.local`
- `private_dot_ssh/config.tmpl` — SSH agent/use-keychain defaults plus the default GitHub key path
- `private_dot_pi/private_agent/settings.json` — Pi default model/provider (`gpt-5.4` on `openai-codex`) plus package sources
- `.chezmoi.toml.tmpl` — chezmoi Git auto-commit/auto-push are disabled by default
- `setup` — bootstraps Git identity, SSH keys, and chezmoi
- `private_dot_pi/private_agent/settings.json` — review the configured Pi package sources before first apply on a new machine
- `dot_zshrc.tmpl` — host-side `devpod()` wrapper hardcodes `DOTFILES_REPO_URL` and `OBSIDIAN_VAULT_HOST`; update if your username or vault path differ
- `dot_tmux.conf.tmpl`, `dot_config/zellij/config.kdl`, `dot_config/systemd/user/voxtype.service` — shell/terminal/systemd defaults that may still need taste-level tuning

## Git + SSH bootstrap

`./setup` supports both interactive setup and non-interactive bootstrapping.

Interactive flow:
- prompts for `user.name` / `user.email` if `~/.gitconfig.local` is missing
- reuses an existing SSH agent if `SSH_AUTH_SOCK` already has loaded identities (great for DevPod / forwarded-agent setups)
- otherwise generates `~/.ssh/id_ed25519` if needed
- offers to upload the public key with `gh ssh-key add` when GitHub CLI is already authenticated

Non-interactive flow:

```sh
DOTFILES_GIT_NAME="Your Name" \
DOTFILES_GIT_EMAIL="you@example.com" \
./setup
```

Useful overrides:
- `DOTFILES_GITCONFIG_LOCAL` — alternate location for the per-machine Git identity file
- `DOTFILES_SSH_KEY_PATH` — alternate SSH key path
- `DOTFILES_SKIP_APPLY=1` — run bootstrap steps without applying chezmoi
- `DOTFILES_FORCE_SSH_KEYGEN=1` — create a local SSH key even if an agent is already available

After apply, `setup` also removes legacy extension directories left behind by the old bootstrap pattern:
- `~/.pi/agent/extensions/pi-diff-ui`
- `~/.pi/agent/extensions/sirdar`
- `~/.pi/agent/extensions/orchestrator`

## Customization

- All dotfiles are templated for local/remote/container/cloud detection
- Add or modify tools in `.config/mise/mise.toml`
- Add external resources in `.chezmoiexternals/`
- Add post-install scripts in `.chezmoiscripts/`

---

## License

These dotfiles are provided as-is for personal use and inspiration. Use at your own risk.

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

### 2. chezmoi

chezmoi manages all dotfiles, templates, and external resources. It detects if you are running in a remote/container/Codespaces environment and adapts accordingly (see `.chezmoi.toml.tmpl`).

- **chezmoi apply**: Apply dotfiles to your home directory
- **chezmoi update**: Pull and apply latest changes

### 3. DevPod

DevPod is supported via `.chezmoiexternals/devpod.toml`, which ensures the DevPod binary is installed and available in your environment.

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
- **Tools**: Managed with [mise](https://mise.jdx.dev/) (see `.config/mise/config.toml`)
- **Kubernetes**: k9s with custom skin
- **Fonts**: DepartureMono (auto-installed)

---

## First-Apply Review Checklist

Before applying this repo to a new machine, review these files for identity- or host-specific behavior:

- `dot_gitconfig` — shared Git defaults; identity is intentionally split into `~/.gitconfig.local`
- `private_dot_ssh/config.tmpl` — SSH agent/use-keychain defaults plus the default GitHub key path
- `private_dot_pi/private_agent/settings.json` — Pi default model/provider (`gpt-5.4` on `openai-codex`)
- `.chezmoi.toml.tmpl` — chezmoi Git auto-commit/auto-push are disabled by default
- `setup` — bootstraps Git identity, SSH keys, and chezmoi
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

## Customization

- All dotfiles are templated for local/remote/container/cloud detection
- Add or modify tools in `.config/mise/config.toml`
- Add external resources in `.chezmoiexternals/`
- Add post-install scripts in `.chezmoiscripts/`

---

## License

These dotfiles are provided as-is for personal use and inspiration. Use at your own risk.
